CREATE OR REPLACE TRIGGER "SYS"."TRG_AUDIT_DDL" AFTER
DDL ON DATABASE begin
  declare
  v_terminal		VARCHAR2(10);
	v_program		  VARCHAR2(10);
  v_module	    VARCHAR2(48);
	v_osuser		  VARCHAR2(30);
	v_MysessionID	NUMBER;
  SendorAddress    varchar2(30) := 'DBPD001@vesper.com.br';
  ReceiverAddress  varchar2(30) := 'abarcelos@vesper.com.br';
  ReceiverAddress2 varchar2(30) := 'smero@vesper.com.br';
  EmailServer      varchar2(30) := '';
  Port number  := 25;
  conn UTL_SMTP.CONNECTION;
  crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
  mesg VARCHAR2( 4000 );
  mesg_body varchar2(4000);
  other_session     exception;

 cursor cs_Rec is

     select OSUSER,PROGRAM,MODULE
     from v$session
     where AUDSID= (v_MysessionID);

     begin

         select USERENV('TERMINAL')          into v_terminal from dual;
         select NVL(USERENV('SESSIONID'),0)  into v_MysessionID from dual;

         If not (cs_Rec%ISOPEN) then
           open cs_Rec;
         end if;

         fetch cs_Rec into v_osuser,v_program,v_module;

--         if ora_login_user = 'INTERNAL'  or v_MYsessionID = 0  then
--           v_program := 'INTERNAL';
--         end if;

         if v_osuser in ('abarc','smero','oracle8i') or ora_login_user  is null then
            raise other_session;
         end if;

         insert into SYS.AUDIT_DDL(USERNAME,TERMINAL,PROGRAM,MODULE,LOGON_TIME,OSUSER,OBJECT_NAME,OBJECT_TYPE,OBJECT_OWNER,COMMAND)
         values (ora_login_user,v_terminal,v_program,v_module,sysdate,v_osuser,ora_dict_obj_name,ora_dict_obj_type,ora_dict_obj_owner,ora_sysevent);

         close cs_Rec;

         conn:= utl_smtp.open_connection( '10.21.25.16');
         utl_smtp.helo( conn, EmailServer );
         utl_smtp.mail( conn, SendorAddress);
         utl_smtp.rcpt( conn, ReceiverAddress );
         utl_smtp.rcpt( conn, ReceiverAddress2 );
         mesg:=
        'Date: '||TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' )|| crlf ||
        'From:'||SendorAddress|| crlf ||
        'Subject:'||'DDL Realizado' || crlf ||
        'To: '||ReceiverAddress || crlf ||
        'Cc: '||ReceiverAddress2 || crlf ||
        '' || crlf ||
        ' DDl Realizado pelo usuário:  '||ora_login_user|| crlf ||
        ' Objeto: '|| ora_dict_obj_name || crlf ||
        ' Usuário do S.O: ' ||v_osuser || crlf ||
        ' Verifique o log na tabela sys.audit_ddl';
        utl_smtp.data( conn, mesg );
        utl_smtp.quit( conn );

        exception
        when other_session then
           close cs_Rec;

        when others then
           DBMS_OUTPUT.PUT_LINE
           ('Processo nao foi executado, entrar em contato com DBA -'||sqlerrm);
           close cs_Rec;
   end;
end;