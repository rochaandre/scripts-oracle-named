-------------------------------------------------------------------------------
--
-- Script:	buffer_pool_miss_rates.sql
-- Purpose:	reports the buffer pool miss rates
-- For:		Oracle 8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select 
  p.bp_name  buffer_pool,
  decode(sum(s.pread),
    0, ' not used',
    to_char(
      100 * sum(s.pread) /
      decode(sum(s.dbbget + s.conget), 0, 1, sum(s.dbbget + s.conget)),
      '9990.00'
    ) || '%'
  )  miss_rate
from
  sys.x_$kcbwds s,
  sys.x_$kcbwbpd p
where
  s.inst_id = userenv('Instance') and
  p.inst_id = userenv('Instance') and
  s.set_id >= p.bp_lo_sid and
  s.set_id <= p.bp_hi_sid and
  p.bp_size != 0
group by
  p.bp_name
/

@restore_sqlplus_settings
