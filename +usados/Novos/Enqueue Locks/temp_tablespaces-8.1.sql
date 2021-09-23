-------------------------------------------------------------------------------
--
-- Script:	temp_tablespaces.sql
-- Purpose:	to check the style of temporary tablespaces in use
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select /*+ ordered */
  t.name  tablespace_name,
  decode(
    t.bitmapped, 0, decode(t.contents$, 0, 'PERMANENT', 'TEMPORARY'), 'TEMPFILE'
  )  style,
  u.users,
  sum(i.writes)/1024  kwrites
from
  (
    select
      tempts#,
      count(*)  users
    from
      sys.user$
    where
      type# = 1
    group by
      tempts#
  )  u,
  ( select
      df.fetsn  ts#,
      di.kcfiopbw * df.febsz  writes
    from
      sys.x_$kccfe  df,
      sys.x_$kcfio  di
    where
      di.inst_id = userenv('Instance') and
      df.inst_id = userenv('Instance') and
      di.kcfiofno = df.fenum
    union all
    select
      tf.tftsn  ts#,
      ti.kcftiopbw * tf.tfbsz  writes
    from
      sys.x_$kcctf  tf,
      sys.x_$kcftio  ti
    where
      ti.inst_id = userenv('Instance') and
      tf.inst_id = userenv('Instance') and
      ti.kcftiofno = tf.tfnum
  )  i,
  sys.ts$  t
where
  i.ts# = u.tempts# and
  t.ts# = i.ts#
group by
  t.name,
  t.bitmapped,
  t.contents$,
  u.users
/

@restore_sqlplus_settings
