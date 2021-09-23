-------------------------------------------------------------------------------
--
-- Script:	set_prompt.sql
-- Purpose:	to include the user and instance in the SQL*Plus prompt
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
define Prompt = "SQL> "
column prompt new_value Prompt

set termout off
select
  user || ' @ ' || instance_name || ':' || chr(10) || 'SQL> '  prompt
from
  sys.v_$instance
/
set termout on
set sqlprompt "&Prompt"
