-------------------------------------------------------------------------------
--
-- Script:	resource_waiters.sql
-- Purpose:	to show the sessions that have waited for a certain event
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Event "Event name" "buffer busy waits"

column sid format a4 justify right
column program format a30

select
  nvl(b.name, lpad(to_char(e.sid), 4))  sid,
  s.program,
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
  sys.v_$session_event  e,
  sys.v_$session  s,
  sys.v_$bgprocess  b
where
  e.event = '&Event' and
  s.sid = e.sid and
  b.paddr (+) = s.paddr
union all
select
  null,
  'All Disconnected Sessions',
  y.time_waited - n.time_waited,
  y.average_wait
from
  sys.v_$system_event  y,
  (
  select
    sum(time_waited)  time_waited
  from
    sys.v_$session_event
  where
    event = '&Event'
  )  n
where
  y.event = '&Event'
order by
  3 desc
/

undefine Event
@restore_sqlplus_settings
