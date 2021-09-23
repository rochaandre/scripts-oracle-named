USER é "SYSTEM"

  1  CREATE TABLE "SYSTEM"."LOGON_AUDIT_TABLE" ("USUARIO" VARCHAR2(30),
  2      "DATA_LOGON" VARCHAR2(30))
  3      TABLESPACE "SYSTEM" PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS
  4      255
  5      STORAGE ( INITIAL 16K NEXT 16K MINEXTENTS 1 MAXEXTENTS 505
  6      PCTINCREASE 50 FREELISTS 1 FREELIST GROUPS 1)
  7*     LOGGING
SQL> conn sys@dbmis

  1  CREATE OR REPLACE TRIGGER "SYS"."LOGONAUDITING" AFTER
  2  LOGON ON DATABASE DECLARE
  3     v_osuserid     VARCHAR2(30);
  4     CURSOR c1 IS
  5       SELECT osuser
  6         FROM v$session
  7        WHERE USERNAME = 'USR_CON_MIS'
  8     ;
  9   BEGIN
 10     OPEN c1;
 11     FETCH c1 INTO v_osuserid ;
 12     IF c1%FOUND THEN
 13        INSERT INTO system.logon_audit_table VALUES ( v_osuserid, to_char(sysdate,'dd/mm/yyyy - hh24:mi:ss'))
 14     END IF;
 15     CLOSE c1;
 16*  END;
SQL> /

Gatilho criado.

SQL> cREATE SYNONYM mis.logon_audit_table FOR system.logon_audit_table
