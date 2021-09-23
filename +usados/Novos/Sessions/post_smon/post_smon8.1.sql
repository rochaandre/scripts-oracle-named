-------------------------------------------------------------------------------
--
-- Script:	post_smon.sql
-- Purpose:	to post SMON to cleanup stray temporary segments
-- For:		8.1
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

oradebug wakeup &Smon

undefine Smon
@restore_sqlplus_settings
