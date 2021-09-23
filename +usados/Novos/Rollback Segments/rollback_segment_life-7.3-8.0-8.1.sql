-------------------------------------------------------------------------------
--
-- Script:	rollback_segment_life.sql
-- Purpose:	to check the useful life of rollback segments 
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Comment:	The rollback segment wrap number can only go up to 2^32 - 1.
--		before the segment has to be dropped and recreated.
--		This script shows what percentage of the useful life of each
--		online rollback segment has been used up.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  r.segment_name,
  to_char(x.wrap / 42949672.94, '990.000') || '%'  life_used
from
  ( select
      ktuxeusn  usn,
      max(ktuxesqn)  wrap
    from
      sys.x_$ktuxe
    group by
      ktuxeusn
  )  x,
  sys.dba_rollback_segs  r
where
  r.segment_id = x.usn and
  r.status = 'ONLINE'
order by
  2 desc
/

@restore_sqlplus_settings
