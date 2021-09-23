-------------------------------------------------------------------------------
--
-- Script:	rollback_reuse_time.sql
-- Purpose:	to get the average time to reuse a rollback segment extent
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column explain format a53
column explain heading "Average time before rollback segment extent reuse ..."
column hours format 9999999 heading "in hours"
column minutes heading "in minutes"

select
  null explain,
  trunc(
    24 * (sysdate - to_date(i1.value||' '||i2.value, 'j SSSSS')) / v.cycles
  )  hours,
  trunc(
    1440 * (sysdate - to_date(i1.value||' '||i2.value, 'j SSSSS')) / v.cycles
  )  minutes
from
  sys.v_$instance  i1,
  sys.v_$instance  i2,
  ( select
      max(
	(r.writes + 24 * r.gets) /			-- bytes used /
	nvl(least(r.optsize, r.rssize), r.rssize) *	-- segment size
	(r.extents - 1) / r.extents			-- reduce by 1 extent
      )  cycles
    from
      sys.v_$rollstat  r
    where
      r.status = 'ONLINE' 
  )  v
where
  i1.key = 'STARTUP TIME - JULIAN' and
  i2.key = 'STARTUP TIME - SECONDS'
/ 

@restore_sqlplus_settings
