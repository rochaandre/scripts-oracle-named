-------------------------------------------------------------------------------
--
-- Script:	system_times.sql
-- Purpose:	to report the time used and waiting for the instance
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  e.event,
  e.time_waited
from
  sys.v_$system_event  e
where
  e.event != 'Null event' and
  e.event != 'rdbms ipc message' and
  e.event != 'pipe get' and
  e.event != 'virtual circuit status' and
  e.event != 'lock manager wait for remote message' and
  e.event not like '% timer' and
  e.event not like 'SQL*Net message from %'
union all
select
  s.name,
  s.value
from
  sys.v_$sysstat  s
where
  s.name = 'CPU used by this session'
order by
  2 desc
/

@restore_sqlplus_settings
