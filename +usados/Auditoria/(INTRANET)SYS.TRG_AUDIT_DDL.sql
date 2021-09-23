CREATE OR REPLACE TRIGGER "SYS"."TRG_AUDIT_DDL" AFTER
DDL ON DATABASE begin
  declare
  v_terminal      VARCHAR2(10);
  v_program       VARCHAR2(10);
  v_module        VARCHAR2(48);
  v_osuser        VARCHAR2(30);
  v_logon_time    DATE;
  v_MysessionID   NUMBER;
  SendorAddress   varchar2(30) := 'SPO63_INTRANET@pergidao.com.br';
  ReceiverAddress varchar2(30) := 'pimentel18@perdigao.com.br';
--  ReceiverAddress2 varchar2(30) := 'evv@perdigao.com.br';
  EmailServer     varchar2(30) := '';
  Port            number := 25;
  crlf            VARCHAR2(2) := CHR(13) || CHR(10);
  mesg            VARCHAR2(4000);
  mesg_body       varchar2(4000);
  other_session   exception;
  send_mail       exception;
  conn UTL_SMTP.CONNECTION;
  cursor cs_Rec is

     select OSUSER,
            PROGRAM,
            MODULE,
            LOGON_TIME
     from v$session
     where AUDSID = (v_MysessionID);

     begin

        select USERENV('TERMINAL')          
        into v_terminal 
        from dual;
        
        select NVL(USERENV('SESSIONID'),0)  
        into v_MysessionID 
        from dual;
       
        If not (cs_Rec%ISOPEN) then
           open cs_Rec;
        end if;

        fetch cs_Rec into v_osuser,v_program,v_module,v_logon_time;
 
       if ora_login_user = 'INTERNAL' or v_MYsessionID = 0  then
           v_program := 'INTERNAL';
           raise other_session;
       end if;

       if v_osuser in ('pimentel18')  or ora_login_user  is null then
           raise other_session;
       end if;


       insert into SYS.AUDIT_DDL(USERNAME,TERMINAL,PROGRAM,MODULE,LOGON_TIME,OSUSER,OBJECT_NAME,OBJECT_TYPE,OBJECT_OWNER,COMMAND)
       values (ora_login_user,v_terminal,v_program,v_module,v_logon_time,v_osuser,ora_dict_obj_name,ora_dict_obj_type,ora_dict_obj_owner,ora_sysevent);
       close cs_Rec;

        conn:= utl_smtp.open_connection( '172.16.49.193');
        utl_smtp.helo( conn, EmailServer );
        utl_smtp.mail( conn, SendorAddress);
        utl_smtp.rcpt( conn, ReceiverAddress );
--        utl_smtp.rcpt( conn, ReceiverAddress2 );
        mesg:=
       'Date: '||TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' )|| crlf ||
       'From:'||SendorAddress|| crlf ||
       'Subject:'||'DDL Realizado' || crlf ||
       'To: '||ReceiverAddress || crlf ||
--       'Cc: '||ReceiverAddress2 || crlf ||
       '' || crlf ||
       ' DDl Realizado, segue o Log:'|| crlf ||
       ' ========================================'|| crlf ||
       ' Usuário Oracle.: ' || ora_login_user || crlf ||
       ' Terminal.......: ' || v_terminal || crlf ||
       ' Programa.......: ' || v_program || crlf ||
       ' Modulo.........: ' || v_module || crlf ||
       ' Logon Time.....: ' || to_char(v_logon_time,'dd/mm/yyyy - hh24:mi:ss') || crlf ||
       ' Usuário SO.....: ' || v_osuser || crlf ||
       ' Nome do Objeto.: ' || ora_dict_obj_name || crlf ||
       ' Tipo do Objeto.: ' || ora_dict_obj_type || crlf ||
       ' Dono do Objeto.: ' || ora_dict_obj_owner || crlf ||
       ' Comando........: ' || ora_sysevent || crlf ||
       ' ========================================'|| crlf ||
       ' Verifique o log na tabela sys.audit_ddl';
                
       utl_smtp.data( conn, mesg );
       utl_smtp.quit( conn );

   exception
       when other_session then
           close cs_Rec;
  --         raise_application_error(-20001, '*****>>> Atenção Usuário ' || v_osuser ||' ! Você executou um procedimento não permitido. Enviando e_mail automático para a Diretoria da Perdigão...  *****');
         when others then
            DBMS_OUTPUT.PUT_LINE
            ('Processo nao foi executado, entrar em contato com DBA -'||sqlerrm);
            close cs_Rec;
     end;
end;