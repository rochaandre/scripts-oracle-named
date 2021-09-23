-------------------------------------------------------------------------------
--
-- Script:	suspend_process.sql
-- Purpose:	to suspend an Oracle process indefinitely
-- For:		up to 8.0 on Unix (a generic version is available from 8.1)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_sid
--		@suspend_process
--
-------------------------------------------------------------------------------
prompt Calling svrmgrl to suspend process.
host echo "connect internal\noradebug setorapid &Pid\noradebug suspend" | svrmgrl | grep "SVRMGR>"
