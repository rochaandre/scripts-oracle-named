-------------------------------------------------------------------------------
--
-- Script:	trace_event_on.sql
-- Purpose:	to turn on a trace event
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Event "Event number to turn on" 10046
@accept Level "Level of event" 8

set termout off
alter session set max_dump_file_size = unlimited
/
set termout on

prompt
prompt alter session set events '&Event trace name context forever, level &Level'
set feedback on
alter session set events '&Event trace name context forever, level &Level'
/

@restore_sqlplus_settings
