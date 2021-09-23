-------------------------------------------------------------------------------
--
-- Script:	suspicious_sql.sql
-- Purpose:	to find suspicious sql that may need tuning
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

prompt This script shows SQL statement that account for more than
prompt a certain percentage of buffer gets.
prompt
@accept Percent "Threshold percentage of buffer gets" 5

column executes format 9999999
break on load on executes

select
  substr(
    to_char(
      100 * s.buffer_gets / t.total_buffer_gets,
      '99.00'
    ),
    2
  ) ||
  '%'  load,
  s.executions executes,
  p.sql_text
from
  ( 
    select
      sum(buffer_gets)  total_buffer_gets
    from
      sys.v_$sql
    where
      command_type != 47
  )  t,
  sys.v_$sql  s,
  sys.v_$sqltext  p
where
  100 * s.buffer_gets / t.total_buffer_gets > &Percent and
  s.buffer_gets > 50 * s.executions and
  s.command_type != 47 and
  p.address = s.address
order by
  1, s.address, p.piece
/

undefine Percent
@restore_sqlplus_settings
