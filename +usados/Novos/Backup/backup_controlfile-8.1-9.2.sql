-------------------------------------------------------------------------------
--
-- Script:	backup_controlfile.sql
-- Purpose:	to save a create controlfile statement
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This script uses the backup controlfile to trace command to
--		save a create controlfile statement, and then moves the trace
--		file into the APT create directory.
--
--		The SQL*Plus connection is closed, because its trace file has
--		been moved.
--
-------------------------------------------------------------------------------

alter database backup controlfile to trace
/

set termout off
@trace_file_name
set termout on

disconnect
host mv &Trace_Name $CREATE/create_controlfile.sql
exit

