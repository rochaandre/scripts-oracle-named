-------------------------------------------------------------------------------
--
-- Script:	stale_statistics.sql
-- Purpose:	to find tables with obviously stale statistics, based on size
-- For:		8.0
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column table_name format a45
column change heading " CHANGE"

select /*+ ordered */
  u.name ||'.'|| o.name  table_name,
  1 + s.groups + t.blkcnt + t.empcnt  analyzed_size,
  s.blocks  current_size,
  substr(
    to_char(
      100 * (s.blocks - 1 - s.groups - t.blkcnt - t.empcnt) /
            (1 + s.groups + t.blkcnt + t.empcnt),
      '999.00'
    ),
    2
  ) ||
  '%'  change
from
  sys.file$  f,
  sys.seg$  s,
  sys.tab$  t,
  sys.obj$  o,
  sys.user$  u
where
  s.file# = f.file# and
  s.type# = 5 and
  t.ts# = s.ts# and
  t.file# = s.file# and
  t.block# = s.block# and
  abs(s.blocks - 1 - s.groups - t.blkcnt - t.empcnt) > 4 and
  o.obj# = t.obj# and
  u.user# = o.owner#
order by
  4
/

@restore_sqlplus_settings
