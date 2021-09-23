-------------------------------------------------------------------------------
--
-- Script:	consider_histogram.sql
-- Purpose:	to recommend the number of buckets for a histogram if needed
-- For:		8.1.6+
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams -- based a suggestion from Steve Orr
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

accept TableName  prompt "Table : "
accept ColumnName prompt "Column: "
prompt Scanning table ... Please wait

column popular_pct format a11
column buckets     format 999999

select
  distinct_values,
  popular_values,
  nvl(apt_format(sum_popular, '9999999999%'), '        n/a')  popular_pct,
  case
    when np_skew is null then null
    when np_skew between 0.8 and 1.25
    then '     UNIFORM'
    else '        SKEW'
  end  non_pop_dist,
  case
    when np_skew not between 0.8 and 1.25
    then least(254, distinct_values)
    else nvl(least(254, distinct_values, ceil(2/min_popular) - 1), 0)
  end  buckets
from
  ( select
      count(*)  distinct_values,
      count(popular)  popular_values,
      sum(popular)  sum_popular,
      min(popular)  min_popular,
      (min(non_popular) + max(non_popular)) / 2 / avg(non_popular)  np_skew
    from
      ( select
	  case when freq > 1/254 then freq else null end  popular,
	  case when freq < 1/254 then freq else null end  non_popular
	from
	  ( select
	      ratio_to_report(count(&ColumnName)) over ()  freq
	    from
	      &TableName
	    group by
	      &ColumnName
	  )
      )
  )
/

@restore_sqlplus_settings
