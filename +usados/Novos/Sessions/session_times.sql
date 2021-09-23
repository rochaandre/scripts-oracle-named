-------------------------------------------------------------------------------
--
-- Script:	session_times.sql
-- Purpose:	to report the time used and waiting for a session
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@set_sid
--		@session_times
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  e.event,
  e.time_waited
from
  sys.v_$session_event  e
where
  e.sid = &Sid
union all
select
  n.name,
  s.value
from
  sys.v_$statname  n,
  sys.v_$sesstat  s
where
  s.sid = &Sid and
  n.statistic# = s.statistic# and
  n.name = 'CPU used by this session'
order by
  2 desc
/

@restore_sqlplus_settings
