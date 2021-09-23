 Declare
   SendorAddress  Varchar2(30)  := 'DBPD001_FrontEnd@vesper.com.br';
   ReceiverAddress varchar2(30) := 'abarcelos@vesper.com.br';
   EmailServer     varchar2(30) := '';
   Port number  := 25;
   conn UTL_SMTP.CONNECTION;
   crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
   mesg VARCHAR2( 4000 );
   mesg_body varchar2(4000);
 BEGIN
   conn:= utl_smtp.open_connection( '10.21.25.16');
   utl_smtp.helo( conn, EmailServer );
   utl_smtp.mail( conn, SendorAddress);
   utl_smtp.rcpt( conn, ReceiverAddress );
   mesg:=
         'Date: '||TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' )|| crlf ||
          'From:'||SendorAddress|| crlf ||
          'Subject:'||'DDL Realizado' || crlf ||
          'To: '||ReceiverAddress || crlf ||
          '' || crlf ||
          ' teste'|| crlf ||
          ' teste ';
   utl_smtp.data( conn, mesg );
   utl_smtp.quit( conn );
 END;
/
