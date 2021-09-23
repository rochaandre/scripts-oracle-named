-------------------------------------------------------------------------------
--
-- Script:	resume_process.sql
-- Purpose:	to resume a suspended Oracle process
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_sid
--		@resume_process
--
-------------------------------------------------------------------------------
oradebug setorapid &Pid
oradebug resume
