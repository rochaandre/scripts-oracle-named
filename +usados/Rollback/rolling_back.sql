-------------------------------------------------------------------------------
--
-- Script:	rolling_back.sql
-- Purpose:	to predict when transactions will finish rolling back
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------


set serveroutput on
set feedback off
prompt
prompt Looking for transactions that are rolling back ...
prompt

declare
  cursor tx is
    select
      s.username,
      t.xidusn,
      t.xidslot,
      t.xidsqn,
      t.used_ublk
    from
      sys.v_$transaction  t,
      sys.v_$session  s
    where
      t.used_ublk > 1 and
      s.saddr = t.ses_addr;
  user_name  varchar2(30);
  xid_usn    number;
  xid_slot   number;
  xid_sqn    number;
  used_ublk1 number;
  used_ublk2 number;
begin
  open tx;
  loop
    fetch tx into user_name, xid_usn, xid_slot, xid_sqn, used_ublk1;
    exit when tx%notfound;
    if tx%rowcount = 1
    then
      sys.dbms_lock.sleep(10);
    end if;
    select
      sum(used_ublk)
    into
      used_ublk2
    from
      sys.v_$transaction
    where
      xidusn  = xid_usn and
      xidslot = xid_slot and
      xidsqn  = xid_sqn;
    if used_ublk2 < used_ublk1
    then
      sys.dbms_output.put_line(
        user_name ||
        '''s transaction ' ||
        xid_usn  || '.' ||
        xid_slot || '.' ||
        xid_sqn  ||
        ' will finish rolling back at approximately ' ||
        to_char(
          sysdate + used_ublk2 / (used_ublk1 - used_ublk2) / 6 / 60 / 24,
          'HH24:MI:SS DD-MON-YYYY'
        )
      );
    end if;
  end loop;
  if user_name is null
  then
    sys.dbms_output.put_line('No transactions appear to be rolling back.');
  end if;
end;   
/

prompt

