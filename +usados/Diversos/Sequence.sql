CREATE TABLE "DBADMIN"."TESTE" ("COD" NUMBER, "NOME" 
    VARCHAR2(30))  
    TABLESPACE "USERS" PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 
    255 
    STORAGE ( INITIAL 128K NEXT 128K MINEXTENTS 1 MAXEXTENTS 4096
    PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1) 
    LOGGING 

CREATE SEQUENCE "DBADMIN"."TESTESEQ" INCREMENT BY 1 START WITH 21
    MAXVALUE 1.0E27 MINVALUE 1 NOCYCLE 
    CACHE 20 NOORDER

CREATE OR REPLACE TRIGGER "DBADMIN"."TESTE" BEFORE
INSERT ON "DBADMIN"."TESTE" FOR EACH ROW WHEN (new.cod is null
) begin
select testeseq.nextval into :new.cod from dual;
end;
#####################################################################
 create table bob(a number , b varchar2(21)); 
 create sequence x ; 
create trigger y before insert on bob 
for each row 
when (new.a is null) 
begin 
select x.nextval into :new.a from dual; 
end; / 
