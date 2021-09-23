-------------------------------------------------------------------------------
--
-- Script:	my_sid.sql
-- Purpose:	to get the SID for the current session
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	@my_sid
--
--		  OR
--
--		set termout off
--		@my_sid
--		set termout on
--		... &Sid ...
--
-------------------------------------------------------------------------------

column pid new_value Pid
column sid new_value Sid
column serial# new_value Serial

select
  p.pid,
  s.sid,
  s.serial#
from
  sys.v_$session  s,
  sys.v_$process  p
where
  s.sid = (select sid from sys.v_$mystat where rownum = 1) and
  p.addr = s.paddr
/

clear columns
