-------------------------------------------------------------------------------
--
-- Script:	protect_rbs.sql
-- Purpose:	to prevent extent reuse in a rollback segment for a period
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Synopsis:	sqlplus -s / @protect_rbs <rbs_name> <seconds> &
--
-- Description:	This script is designed to be used from prevent_1555.sql.
--		Please see that script for details.
--
-------------------------------------------------------------------------------
alter rollback segment &1 shrink
/
delete from
  system.protected_rollback_seg
where
  segment_name = '&1' and
  protection_expires < sysdate
/
insert into system.protected_rollback_seg values ('&1', sysdate + &2/86400)
/
commit
/
set transaction use rollback segment &1
/
delete from
  system.protected_rollback_seg
where
  segment_name = '&1' and
  protection_expires <= sysdate + &2/86400
/
execute sys.dbms_lock.sleep(&2)
/
commit
/
exit
