-------------------------------------------------------------------------------
--
-- Script:	fixed_table_columns.sql
-- Purpose:	to generate a description of the fixed table columns
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

prompt Spooling output to: fixed_table_columns.lst

set trimspool on
set pagesize 0
set termout off
set echo off

spool fixed_table_columns.tmp
prompt set echo on
select 
  'describe SYS.X_' || substr(name,2)
from
  sys.v_$fixed_table
where
  name like 'X$%'
order by
  name
/
prompt spool off
spool off

spool fixed_table_columns
@fixed_table_columns.tmp

host rm -f fixed_table_columns.tmp	-- for Unix
host del fixed_table_columns.tmp	-- for others

@restore_sqlplus_settings
