-------------------------------------------------------------------------------
--
-- Script:	set_sid.sql
-- Purpose:	to set the SID to be used by other scripts
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set termout off
@my_sid
set termout on

prompt Your own session's SID is &Sid
@accept Sid "Please enter the SID" &Sid

column pid new_value Pid
column serial# new_value Serial

select
  p.pid, s.sid, s.serial#
from
  sys.v_$session s,
  sys.v_$process p
where
  s.sid = &Sid and
  p.addr = s.paddr
/

@restore_sqlplus_settings
define Pid=&Pid
define Sid=&Sid
define Serial=&Serial
