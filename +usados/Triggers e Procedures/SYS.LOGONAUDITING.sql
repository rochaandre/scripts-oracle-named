CREATE OR REPLACE TRIGGER "SYS"."LOGONAUDITING" AFTER
LOGON ON DATABASE DECLARE
   v_osuserid     VARCHAR2(30);
   CURSOR c1 IS
     SELECT osuser
       FROM v$session
      WHERE USERNAME = 'USR_CONS_MIS'
   ;
 BEGIN
   OPEN c1;
   FETCH c1 INTO v_osuserid ;
   IF c1%FOUND THEN
      INSERT INTO system.logon_audit_table VALUES ( v_osuserid, to_char(sysdate,'dd/mm/yyyy - hh24:mm:ss'));
   END IF;
   CLOSE c1;
 END;