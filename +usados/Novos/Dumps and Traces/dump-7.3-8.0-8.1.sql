-------------------------------------------------------------------------------
--
-- Script:	immediate_dump.sql
-- Purpose:	to take a state dump or structure dump
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Structure "Structure to dump" systemstate
@accept Level     "Level of dump"     10

set termout off
alter session set max_dump_file_size = unlimited
/
set termout on

prompt
prompt alter session set events 'immediate trace name &Structure level &Level'
set feedback on
alter session set events 'immediate trace name &Structure level &Level'
/

undefine Structure
undefine Level

@restore_sqlplus_settings
