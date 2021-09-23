-------------------------------------------------------------------------------
--
-- Script:	resource_waits.sql
-- Purpose:	to show the total waiting time for resource types
-- For:		7.3 (does not check for OPS)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column average_wait format 9999990.00

select
  substr(e.event, 1, 40)  event,
  e.time_waited,
  e.time_waited / decode(
    e.event,
    'latch free', e.total_waits,
    decode(
      e.total_waits - e.total_timeouts,
      0, 1,
      e.total_waits - e.total_timeouts
    )
  )  average_wait
from
  sys.v_$system_event  e
where
  e.event = 'buffer busy waits' or
  e.event = 'enqueue' or
  e.event = 'free buffer waits' or
  e.event = 'latch free' or
  e.event = 'log buffer space' or
  e.event = 'parallel query qref latch' or
  e.event = 'pipe put' or
  e.event = 'write complete waits' or
  e.event like 'library cache%' or
  e.event like 'log file switch%' or
  e.event = 'row cache lock'
/

@restore_sqlplus_settings
