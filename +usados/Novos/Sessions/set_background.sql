-------------------------------------------------------------------------------
--
-- Script:	set_background.sql
-- Purpose:	to set the SID of a background to be used by other scripts
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Name "Please enter the background name" SMON

column pid new_value Pid
column sid new_value Sid
column serial# new_value Serial

select
  b.name, p.pid, s.sid, s.serial#
from
  sys.v_$bgprocess b,
  sys.v_$process p,
  sys.v_$session s
where
  b.name = '&Name' and
  p.addr = b.paddr and
  s.paddr = p.addr
/

undefine Name
@restore_sqlplus_settings
define Pid=&Pid
define Sid=&Sid
define Serial=&Serial
