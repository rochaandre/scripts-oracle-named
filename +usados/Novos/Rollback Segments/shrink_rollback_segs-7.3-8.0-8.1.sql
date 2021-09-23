-------------------------------------------------------------------------------
--
-- Script:	shrink_rollback_segs.sql
-- Purpose:	to shrink all online rollback segments back to optimal
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set pagesize 0
set termout off

spool shrink_rollback_segs.tmp
select 
  'alter rollback segment ' || segment_name || ' shrink;'
from
  sys.dba_rollback_segs
where
  status = 'ONLINE'
/
spool off

@shrink_rollback_segs.tmp

host rm -f shrink_rollback_segs.tmp	-- for Unix
host del shrink_rollback_segs.tmp	-- for others

@restore_sqlplus_settings
