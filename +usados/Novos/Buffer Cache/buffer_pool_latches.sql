-------------------------------------------------------------------------------
--
-- Script:	buffer_pool_latches.sql
-- Purpose:	to check the lru latches
-- For:		8.0 and 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  x.bp_name  buffer_pool,
  x.bp_size  buffers,
  x.bp_set_ct  latches,
  sum(l.gets)  gets,
  sum(l.sleeps)  sleeps
from
  sys.v_$latch_children  l,
  sys.x_$kcbwbpd  x
where
  x.inst_id = userenv('Instance') and
  l.child# between x.bp_lo_sid and x.bp_hi_sid and
  l.name = 'cache buffers lru chain'
group by
  x.bp_name,
  x.bp_size,
  x.bp_set_ct
/

@restore_sqlplus_settings
