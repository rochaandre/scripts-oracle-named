-------------------------------------------------------------------------------
--
-- Script:	routine_waits.sql
-- Purpose:	to show the average wait time of routine waits
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
  sys.v_$system_event  e,
  sys.v_$instance  i
where
  e.event = 'DFS lock handle' or
  e.event = 'rdbms ipc reply' or
  e.event like 'SQL*Net%to%' or
  e.event like 'db file%' or
  e.event like 'direct path%' or
  e.event like 'global cache lock % to %' or
  e.event like 'global cache lock open %' or
  ( e.event like 'log file%' and
    e.event not like 'log file switch%'
  ) or
  ( e.event = 'row cache lock' and
    i.parallel = 'YES'
  )
/

@restore_sqlplus_settings
