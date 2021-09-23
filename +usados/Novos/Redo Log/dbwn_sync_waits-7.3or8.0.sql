-------------------------------------------------------------------------------
--
-- Script:	dbwn_sync_waits.sql
-- Purpose:	how many write batches have to wait for a log file sync?
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  decode(
    sum(w.total_waits),
    0, 'NONE',
    to_char(
      nvl(100 * sum(l.total_waits) / sum(w.total_waits), 0),
     '99990.00'
    ) || '%'
  )  sync_waits
from
  sys.v_$bgprocess  b,
  sys.v_$session  s,
  sys.v_$session_event  l,
  sys.v_$session_event  w
where
  b.name like 'DBW_' and
  s.paddr = b.paddr and
  l.sid = s.sid and
  l.event = 'log file sync' and
  w.sid = s.sid and
  w.event = 'db file parallel write'
/

@restore_sqlplus_settings

