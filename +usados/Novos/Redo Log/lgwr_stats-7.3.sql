-------------------------------------------------------------------------------
--
-- Script:	lgwr_stats.sql
-- Purpose:	to show if the log_buffer is well sized
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description: These statistics show whether the log_buffer is well sized.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column write_size format 9999999999999 heading "Average Log|Write Size"
column threshold  format 9999999999999 heading "Background|Write Theshold"

select
  ceil(b.value/w.value) * x.lebsz  write_size,
  ceil(p.value/x.lebsz/3) * x.lebsz  threshold
from
  (select value from sys.v_$sysstat where name = 'redo blocks written') b,
  (select value from sys.v_$sysstat where name = 'redo writes') w,
  (select max(lebsz) lebsz from sys.x_$kccle) x,
  (select value from sys.v_$parameter where name = 'log_buffer') p
where
  w.value > 0
/

column sync_cost_ratio format 990.00 heading "Sync Cost Ratio"

select
  s.average_wait/t.average_wait  sync_cost_ratio
from
  (select average_wait from sys.v_$system_event where event = 'log file parallel write') t,
  (select average_wait from sys.v_$system_event where event = 'log file sync') s
where
  t.average_wait > 0
/

@restore_sqlplus_settings
