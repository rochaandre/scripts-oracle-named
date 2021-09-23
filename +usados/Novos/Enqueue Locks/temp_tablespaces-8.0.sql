-------------------------------------------------------------------------------
--
-- Script:	temp_tablespaces.sql
-- Purpose:	to check whether permanent or temporary tablespaces are in use
-- For:		8.0
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  t.name,
  decode(t.contents$, 0, 'PERMANENT', 'TEMPORARY')  style,
  u.users,
  sum(i.kcfiopbw * e.febsz) / 1024  kwrites
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
  sys.ts$  t,
  sys.file$  f,
  sys.x_$kcfio  i,
  sys.x_$kccfe  e
where
  i.inst_id = userenv('Instance') and
  e.inst_id = userenv('Instance') and
  t.ts# = u.tempts# and
  f.ts# = t.ts# and
  i.kcfiofno = f.file# and
  e.fenum = i.kcfiofno
group by
  t.name,
  u.users,
  t.contents$
/

@restore_sqlplus_settings
