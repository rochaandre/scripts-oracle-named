-------------------------------------------------------------------------------
--
-- Script:	post_process.sql
-- Purpose:	to post an Oracle process
-- For:		up to 8.0 on Unix (a generic version is available from 8.1)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_background  OR  @set_sid
--		@post_process
--
-------------------------------------------------------------------------------
prompt Calling svrmgrl to post process.
host echo "connect internal\noradebug wakeup &Pid" | svrmgrl | grep "SVRMGR>"
