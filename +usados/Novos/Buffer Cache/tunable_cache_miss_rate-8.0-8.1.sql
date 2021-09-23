-------------------------------------------------------------------------------
--
-- Script:	tunable_cache_miss_rate.sql
-- Purpose:	to get the cache miss rate exclusive of multiblock reads
-- For:		Oracle 8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select 
  to_char(100 * misses / (hits + misses), '9990.00') || '%'  miss_rate
from
  ( select
      total_waits  misses
    from
      sys.v_$system_event
    where
      event = 'db file sequential read'
  ),
  ( select 
      sum(dbbget + conget - pread)  hits
    from
      sys.x_$kcbwds
    where
      inst_id = userenv('Instance')
  )
/

@restore_sqlplus_settings
