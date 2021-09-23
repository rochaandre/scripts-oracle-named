-------------------------------------------------------------------------------
--
-- Script:	sub_optimal.sql
-- Purpose:	to raise optimal to reduce dynamic extension 
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This script suggests raising optimal if rollback segments of
--		that optimal size have been shrinking more than once per reuse
--		cycle, and have shrunk at least twice.
--
--		The suggested optimal is the present value plus an average
--		shrink, rounded to a whole number of extents minus one block
--		for the segment header. This is based on the assumption that
--		all extents are equally sized.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column name format a30 heading "Rollback Segment"
column optsize format 99999999999 heading "Current Optimal"
column new_opt format 99999999999 heading "Suggested Optimal"

select
  n.name,
  s.optsize,
  ( ceil(s.extents * (s.optsize + s.aveshrink)/(s.rssize + p.value))
    * (s.rssize + p.value)
    / s.extents
  ) - p.value  new_opt
from
  ( select
      optsize,
      avg(rssize)     rssize,
      avg(extents)    extents,
      max(wraps)      wraps,
      max(shrinks)    shrinks,
      avg(aveshrink)  aveshrink
    from
      sys.v_$rollstat
    where
      optsize is not null and
      status = 'ONLINE' 
    group by
      optsize
  )  s,
  ( select
      kvisval  value
    from
      sys.x_$kvis
    where
      kvistag = 'kcbbkl' )  p,
  sys.v_$rollstat  r,
  sys.v_$rollname  n
where
  s.shrinks > 1 and
  s.shrinks > s.wraps / ceil(s.optsize / ((s.rssize + p.value) / s.extents)) and
  r.optsize = s.optsize and
  r.status = 'ONLINE' and
  n.usn = r.usn
/

@restore_sqlplus_settings
