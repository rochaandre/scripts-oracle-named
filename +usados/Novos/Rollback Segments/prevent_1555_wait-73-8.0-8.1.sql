-------------------------------------------------------------------------------
--
-- Script:	prevent_1555_wait.sql
-- Purpose:	to wait until old transactions have finished
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams (with thanks to Anita Bardeen and Yong Huang for
--			     pointing out the need for such a script)
--
-- Description:	This script is designed to be used with prevent_1555.sql.
--		Please see that script for details.
--
-------------------------------------------------------------------------------
set termout off

column obj# new_value ObjNo

select
  o.obj#
from
  sys.obj$  o,
  sys.user$  u
where
  o.name = 'PROTECTED_ROLLBACK_SEG' and
  u.user# = o.owner# and
  u.name = 'SYSTEM'
/

column obj# clear


column startscn new_value StartSCN

select
  max(t.ktcxbssw || '.' || t.ktcxbssb)  startscn
from
  sys.x_$ktadm  l,
  sys.x_$ktcxb  t
where
  l.ktadmtab = &ObjNo and
  l.ksqlkmod = 3 and
  t.ktcxbxba = l.kssobown
/

column startscn clear

declare
  old_transactions  number;
begin
  loop
    select
      count(*)
    into
      old_transactions
    from
      sys.x_$ktcxb  t,
      sys.v_$session  s
    where
      t.ktcxbssw || '.' || t.ktcxbssb < '&StartSCN' and
      bitand(t.ksspaflg, 1) != 0 and
      bitand(t.ktcxbflg, 2) != 0 and
      t.indx not in
      (
        select
          t.indx
        from
          sys.x_$ktadm  l,
          sys.x_$ktcxb  t
        where
          l.ktadmtab = &ObjNo and
          l.ksqlkmod = 3 and
          t.ktcxbxba = l.kssobown
      ) and
      s.saddr = t.ktcxbses;
    if old_transactions = 0 then
      exit;
    end if;
    sys.dbms_lock.sleep(60);
  end loop;
end;
/

undefine ObjNo
undefine StartSCN

set termout on
