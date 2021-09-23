-------------------------------------------------------------------------------
--
-- Script:	fixed_view_text.sql
-- Purpose:	to extract the view text for the V$ views
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

prompt Spooling output to: fixed_view_text.lst

set termout off
set pagesize 0
set linesize 2048
set trimspool on

spool fixed_view_text
select
  'create view ' || view_name || ' as ' || view_definition || ';'
from
  sys.v_$fixed_view_definition
order by
  view_name
/
spool off

@restore_sqlplus_settings
