-------------------------------------------------------------------------------
--
-- Script:	stale_statistics.sql
-- Purpose:	to find tables with obviously stale statistics, based on size
-- For:		8.1 and higher
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
  sys.ts$  ts,
  sys.seg$  s,
  sys.tab$  t,
  sys.obj$  o,
  sys.user$  u
where
  ts.bitmapped = 0 and
  s.ts# = ts.ts# and
  s.type# = 5 and
  t.ts# = s.ts# and
  t.file# = s.file# and
  t.block# = s.block# and
  abs(s.blocks - 1 - s.groups - t.blkcnt - t.empcnt) > 4 and
  o.obj# = t.obj# and
  u.user# = o.owner#
union all
select /*+ ordered */
  u.name ||'.'|| o.name  table_name,
  1 + s.groups + t.blkcnt + t.empcnt  analyzed_size,
  sys.dbms_space_admin.segment_number_blocks(
    s.ts#, s.file#, s.block#, s.type#, s.cachehint,
    nvl(s.spare1,0), t.dataobj#, s.blocks
  )  current_size,
  substr(
    to_char(
      100 * (sys.dbms_space_admin.segment_number_blocks(
                s.ts#, s.file#, s.block#, s.type#, s.cachehint,
                nvl(s.spare1,0), t.dataobj#, s.blocks
              ) - 1 - s.groups - t.blkcnt - t.empcnt
            ) /
            (1 + s.groups + t.blkcnt + t.empcnt),
      '999.00'
    ),
    2
  ) ||
  '%'  change
from
  sys.ts$  ts,
  sys.seg$  s,
  sys.tab$  t,
  sys.obj$  o,
  sys.user$  u
where
  ts.bitmapped > 0 and
  s.ts# = ts.ts# and
  s.type# = 5 and
  t.ts# = s.ts# and
  t.file# = s.file# and
  t.block# = s.block# and
  t.blkcnt is not null and
  abs(sys.dbms_space_admin.segment_number_blocks(
        s.ts#, s.file#, s.block#, s.type#, s.cachehint,
        nvl(s.spare1,0), t.dataobj#, s.blocks
      ) - 1 - s.groups - t.blkcnt - t.empcnt) > 4 and
  o.obj# = t.obj# and
  u.user# = o.owner#
order by
  4
/

@restore_sqlplus_settings
