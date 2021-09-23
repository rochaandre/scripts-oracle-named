-------------------------------------------------------------------------------
--
-- Script:	routine_waits.sql
-- Purpose:	to show the average wait time of routine waits
-- Version:	prior to 8.0 (does not check for OPS)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column average_wait format 9999990.00

select
  substr(e.event, 1, 40)  event,
  e.average_wait
from
  sys.v_$system_event  e
where
  e.event = 'DFS lock handle' or
  e.event = 'rdbms ipc reply' or
  e.event like 'SQL*Net%to%' or
  e.event like 'db file%' or
  ( e.event like 'log file%' and
    e.event not like 'log file switch%'
  ) or
  e.event = 'row cache lock'
/

@restore_sqlplus_settings
