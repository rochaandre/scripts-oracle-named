-------------------------------------------------------------------------------
--
-- Script:	trace_event_off.sql
-- Purpose:	to turn off a trace event
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Event "Event number to turn off" &Event

alter session set events '&Event trace name context off'
/

undefine Event
@restore_sqlplus_settings
