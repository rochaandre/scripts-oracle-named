CREATE OR REPLACE TRIGGER "SYS"."TRG_DESABILITA_DDL" BEFORE
DDL ON DATABASE BEGIN
 IF USER = 'TESTCOLL' THEN
   RAISE_APPLICATION_ERROR(-20099, 'DDL n?o permitido. Contacte a equipe de DBA Ramal 6941/6439');
 END IF;
END;