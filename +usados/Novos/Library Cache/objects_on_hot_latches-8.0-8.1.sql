-------------------------------------------------------------------------------
--
-- Script:	objects_on_hot_latches.sql
-- Purpose:	to list the library cache objects on the hot KGL latches
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column object_name format a60

select /*+ ordered */
  l.child#  latch#,
  o.kglnaobj  object_name
from
  ( select
      count(*)  latches,
      avg(sleeps)  sleeps
    from
      sys.v_$latch_children
    where
      name = 'library cache'
  )  a,
  sys.v_$latch_children  l,
  ( select
      s.buckets *
      power(
        2,
        least(
          8,
          ceil(log(2, ceil(count(*) / s.buckets)))
        )
      )  buckets
    from
      ( select
	  decode(y.ksppstvl,
	    0, 509,
	    1, 1021,
	    2, 2039,
	    3, 4093,
	    4, 8191,
	    5, 16381,
	    6, 32749,
	    7, 65521,
	    8, 131071,
            509
	  )  buckets
	from
	  sys.x_$ksppi  x,
	  sys.x_$ksppcv  y
	where
	  x.inst_id = userenv('Instance') and
	  y.inst_id = userenv('Instance') and
	  x.ksppinm = '_kgl_bucket_count' and
	  y.indx = x.indx
      )  s,
      sys.x_$kglob  c
    where
      c.inst_id = userenv('Instance') and
      c.kglhdadr = c.kglhdpar
    group by
      s.buckets
  )  b,
  sys.x_$kglob  o
where
  l.name = 'library cache' and
  l.sleeps > 2 * a.sleeps and
  mod(mod(o.kglnahsh, b.buckets), a.latches) + 1 = l.child# and
  o.inst_id = userenv('Instance') and
  o.kglhdadr = o.kglhdpar
/

@restore_sqlplus_settings
