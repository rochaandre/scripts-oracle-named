-------------------------------------------------------------------------------
--
-- Script:	trace_zip.sql
-- Purpose:	to dynamically zip the current process's trace file
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@trace_zip
--		-- produce big trace file
--		@trace_nozip
--
-- Description:	This script creates a named pipe in place of the process's
--		trace file, and spawns a gzip process to compress it.
--		The trc_nozip.sql script removes the named pipe and exits.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set termout off
@trace_file_name

set define :
host mknod :Trace_Name p && nohup gzip < :Trace_Name > :Trace_Zipped &

alter session set max_dump_file_size = unlimited
/

@restore_sqlplus_settings
