-------------------------------------------------------------------------------
--
-- Script:	resume_process.sql
-- Purpose:	to resume a suspended Oracle process
-- For:		up to 8.0 on Unix (a generic version is available from 8.1)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_sid
--		@suspend_process
--
-------------------------------------------------------------------------------
prompt Calling svrmgrl to resume process.
host echo "connect internal\noradebug setorapid &Pid\noradebug resume" | svrmgrl | grep "SVRMGR>"
