-------------------------------------------------------------------------------
--
-- Script:	enough_rollback_segs.sql
-- Purpose:	to check the number of rollback segments
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	The division of waits in to write waits and read waits may not
--		be right if rollback segments have been taken offline.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column segs heading "ROLLBACK|SEGMENTS"
column tx_hwm heading "CONCURRENT|TRANSACTIONS"
column write_waits heading "WRITE|WAITS"
column read_waits heading "READ|WAITS"

select
  segs,
  tx_hwm,
  write_waits,
  all_waits - write_waits  read_waits
from
  ( select
      count(*)  segs,
      sum(waits)  write_waits
    from
      sys.v_$rollstat
    where
      usn > 0 and
      status = 'ONLINE'
  ),
  ( select
      count(*)  tx_hwm
    from
      sys.x_$ktcxb
    where
      ktcxbflg > 0
  ),
  ( select
      "COUNT"  all_waits
    from
      sys.v_$waitstat
    where
      class = 'undo header'
  )
/

@restore_sqlplus_settings
