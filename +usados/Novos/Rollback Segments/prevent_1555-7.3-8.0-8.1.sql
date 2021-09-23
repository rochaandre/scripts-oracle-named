-------------------------------------------------------------------------------
--
-- Script:	prevent_1555.sql
-- Purpose:	to prevent ORA-1555 during the running of a critical report
-- For:		Unix only
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	sqlplus -s / @prevent_1555 <seconds>
--		rbs_protectors=$(sh prevent_1555.sh)
--		sqlplus -s / @prevent_1555_wait
--		#
--		# run the sensitive report or program here
--		#
--		kill $rbs_protectors
--
-- Description:	ORA-1555 errors are prevented by leaving an uncommitted
--		transaction in each online rollback segment.  This ensures
--		that rollback segments will not reuse extents during the
--		running of the critical report. Instead, rollback segments
--		will be extended if necessary.
--
--		This script creates a shell script to call protect_rbs.sql in
--		the background for each online rollback segment. That script
--		places an uncommitted transaction in the rollback segment
--		specified, and sleeps for the specified number of seconds.
--		If the critical report finishes before the time allowed, then
--		the processes protecting the rollback segments are killed so
--		that the uncommitted transactions are rolled back by PMON.
--
--		The risk of running out of space in the rollback segment
--		tablespace space(s) is mitigated by protect_rbs.sql shinking
--		the rollback segment first.
--
--		The script prevent_1555_setup.sql must be run first (once) to
--		create the clustered table required in the SYSTEM schema.
--
--		The script protected_rollback_segs.sql can be used to monitor
--		the status of each rollback segment.
--
-------------------------------------------------------------------------------
set define :
set verify off
set recsep off
set heading off
set feedback off
set termout off
set trimspool on

spool prevent_1555.sh
prompt rm -f prevent_1555.sh
select
  'sqlplus / @protect_rbs ' || segment_name || ' :1 > /dev/null & echo $!'
from
  sys.dba_rollback_segs
where
  status = 'ONLINE' and
  segment_name != 'SYSTEM'
/
spool off
exit
