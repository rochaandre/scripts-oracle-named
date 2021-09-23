-------------------------------------------------------------------------------
--
-- Script:	post_smon.sql
-- Purpose:	to post SMON to cleanup stray temporary segments
-- For:		up to 8.0 on Unix (a generic version is available from 8.1)
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column pid new_value Smon

set termout off
select
  p.pid
from
  sys.v_$bgprocess b,
  sys.v_$process p
where
  b.name = 'SMON' and
  p.addr = b.paddr
/
set termout on

prompt Calling svrmgrl to post SMON.
host echo "connect internal\noradebug wakeup &Smon" | svrmgrl | grep "SVRMGR>"

undefine Smon
@restore_sqlplus_settings
