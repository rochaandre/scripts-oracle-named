CREATE OR REPLACE  PROCEDURE "SYS"."KILLSESSION" 
  ( param1 IN number,
    param2 IN number)
  IS
  vsid         number := null;
  vsid2        number := null;
  vserial#     number := null ;
  vcomando     VARCHAR2(100):= null;
  vusername    varchar2(30) := null;
  vosuser      varchar2(30) := null;
  vaudsid      number       := null;
  vaudsid2     number       := null;
  own_session       exception;
  not_exist_session exception;
  other_session     exception;
  cursor c1 (vsid number , vserial# number) is
      select audsid,username,osuser from v$session
      where sid = vsid and serial#=vserial# ;
BEGIN
   vsid := param1;
   vserial# := param2;
   open c1 (vsid , vserial#);
   loop
     fetch c1 into vaudsid,vusername,vosuser ;
     if (vaudsid is null) or (vsid is null) or
        (vserial# is null) then
        raise not_exist_session;
     end if;

     select userenv('SESSIONID') into vaudsid2 from dual;
     if vaudsid = vaudsid2 then
        raise own_session ;
     end if;

     if vusername <> 'MIS' or vusername is null then
         raise other_session;
     end if;
     vcomando := 'ALTER SYSTEM KILL SESSION '''|| vsid ||','||
                  vserial# || '''';
     Execute Immediate(vcomando);
     insert into killed_session values
     (vsid,vserial#,vusername,vosuser,sysdate);
     commit;
     dbms_output.put_line('Sessao foi encerrada');
     exit;
   end loop;
   close c1;
exception
   when other_session then
       DBMS_OUTPUT.PUT_LINE
       ('Sem privilegio para encerrar outra sessao');
       close c1;
   when own_session then
       DBMS_OUTPUT.PUT_LINE
       ('A propria sessao nao pode ser finalizada');
       close c1;
   when not_exist_session then
       DBMS_OUTPUT.PUT_LINE
       ('Nao existe sessao:'||vsid||'-'||vserial#);
       close c1;
   when others then
       DBMS_OUTPUT.PUT_LINE
       ('Processo nao foi executado, entrar em contato com DBA -'||sqlerrm);
       close c1;
END;
