-------------------------------------------------------------------------------
--
-- Script:	missing_statistics.sql
-- Purpose:	to count the number of segments in each schema with/out stats
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column schema_name format a19
column clusters_with format 99999999 heading "CLUSTERS|WITH|STATS"
column tables_with format 99999999 heading "TABLES|WITH|STATS"
column indexes_with format 99999999 heading "INDEXES|WITH|STATS"
column clusters_without format 99999999 heading "CLUSTERS|WITHOUT|STATS"
column tables_without format 99999999 heading "TABLES|WITHOUT|STATS"
column indexes_without format 99999999 heading "INDEXES|WITHOUT|STATS"

select
  u.name  schema_name,
  nvl(c.stats, 0)  clusters_with,
  t.stats  tables_with,
  nvl(i.stats, 0)  indexes_with,
  nvl(c.total - c.stats, 0)  clusters_without,
  t.total - t.stats  tables_without,
  nvl(i.total - i.stats, 0)  indexes_without
from
  ( select
      o1.owner#,
      count(c1.spare4)  stats, 
      count(*)  total
    from
      sys.clu$  c1,
      sys.obj$  o1
    where
      c1.obj# = o1.obj#
    group by
      o1.owner#
  )  c,
  ( select
      o2.owner#,
      count(t2.rowcnt)  stats, 
      count(*)  total
    from
      sys.tab$  t2,
      sys.obj$  o2
    where
      t2.obj# = o2.obj# and
      t2.tab# is null
    group by
      o2.owner#
  )  t,
  ( select
      o3.owner#,
      count(i3.blevel)  stats, 
      count(*)  total
    from
      sys.ind$  i3,
      sys.obj$  o3
    where
      i3.obj# = o3.obj#
    group by
      o3.owner#
  )  i,
  sys.user$  u
where
  u.user# = t.owner# and
  u.user# = c.owner# (+) and
  u.user# = i.owner# (+)
order by
  t.total - t.stats + nvl(c.total - c.stats, 0) + nvl(i.total - i.stats, 0)  
/

@restore_sqlplus_settings
