-------------------------------------------------------------------------------
--
-- Script:	tunable_cache_miss_rate.sql
-- Purpose:	to get the cache miss rate exclusive of multiblock reads
-- For:		7.3 (not precise because there is no reliable CR get stat)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select 
  to_char(100 * misses / (logical - physical + misses), '9990.00') || '%'
    miss_rate
from
  ( select
      total_waits  misses
    from
      sys.v_$system_event
    where
      event = 'db file sequential read'
  ),
  ( select 
      value  physical
    from
      sys.v_$sysstat
   where
      name = 'physical reads'
  ),
  ( select
      sum(value)  logical
    from
      sys.v_$sysstat
    where
      name like '%consistent read gets' or
      name = 'db block gets'
  )
/

@restore_sqlplus_settings


