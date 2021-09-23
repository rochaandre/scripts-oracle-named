-------------------------------------------------------------------------------
--
-- Script:	tune_spin_count.sql
-- Purpose:	to try out a different value for the spin_count
-- For:		7.3 to 8.0
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This script takes note of total misses and spin_gets so far
--		and computes the spin hit rate so far. It then prompts the
--		user to change the spin_count and sleeps for a user specified
--		number of minutes. It then calculates the misses, spin_gets
--		and spin hit rate over the interval and reports the results.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column value new_value Spin_count format a10 heading "SPIN_COUNT"

select
  p.value
from
  sys.v_$parameter p
where
  p.name = 'spin_count' and
  issys_modifiable = 'IMMEDIATE'
/

column misses     new_value Misses     noprint
column spin_gets  new_value Spin_gets  noprint
column sleeps     new_value Sleeps     noprint
column hit_rate   format a13           heading "SPIN HIT RATE"
column spin_cost  format 999999999     heading "SPIN COST"

select
  sum(l.misses)  misses,
  sum(l.spin_gets)  spin_gets,
  sum(l.sleeps)  sleeps,
  to_char(100 * sum(l.spin_gets) / sum(l.misses), '99999990.00') || '%'  hit_rate,
  &Spin_count * sum(l.sleeps) / sum(l.misses) spin_cost
from
  sys.v_$latch  l
where
  l.misses > 0
/

prompt
accept New_spin_count prompt "Enter new _spin_count value to try: "
@accept Seconds_to_wait "Enter time to wait (in seconds): " 300

alter system set spin_count = &New_spin_count
/

prompt
execute sys.dbms_lock.sleep(&Seconds_to_wait);

select
  to_char(
    100 * (sum(l.spin_gets) - &Spin_gets) / (sum(l.misses) - &Misses),
    '99999990.00'
  ) || '%'  hit_rate,
  &New_spin_count * (sum(l.sleeps) - &Sleeps) / (sum(l.misses) - &Misses)
    spin_cost
from
  sys.v_$latch  l
where
  l.misses > 0
having
  sum(misses) > &Misses
/

undefine Spin_count
undefine Misses
undefine Spin_gets
undefine Sleeps
undefine New_spin_count
undefine Seconds_to_wait

@restore_sqlplus_settings
