Declare
  SendorAddress  Varchar2(30)  := 'swadhwa@TEST.com';  
   /* Address of the person who is sending Email */
  ReceiverAddress varchar2(30) := 'abarcelos@vesper.com.br';
 /* Address of the person who is receiving Email */
  EmailServer     varchar2(30) := '10.21.25.16'; 
 /* Address of your Email Server Configured for sending emails */
  Port number  := 25;
  /*  Port Number responsible for sending email */
  conn UTL_SMTP.CONNECTION; 
  /* UTL_SMTP package establish a connection with the SMTP server */
  crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
  /* crlf  used  for carriage return */
 mesg VARCHAR2( 4000 );
 /*  Variable for storing message contents */
mesg_body varchar2(4000)
/* Variable for storing HTML code */
   := '    <html>
            <head>
            <title>Oracle Techniques By Sameer Wadhwa</title>
            </head>
            <body bgcolor="#FFFFFF" link="#000080">
            <table cellspacing="0" cellpadding="0" width="100%">
            <tr align="LEFT" valign="BASELINE">
            <td width="100%" valign="middle"><h1><font color="#00008B"><b>Send Mail in HTML                      Format</b></font></h1>
             </td>
         </table>
          <ul>
           <li><b><a href="www.geocities.com/samoracle">Oracle Techniques is for DBAs </li>
           <l><b>                                     by Sameer Wadhwa </b> </l>              
              </ul>
             </body>
             </html>';
BEGIN
  /* Open Connection */
  conn:= utl_smtp.open_connection( EmailServer, Port );   
 /* Hand Shake */
  utl_smtp.helo( conn, EmailServer );
 /* Configure Sender and Recipient  with UTL_SMTP */
  utl_smtp.mail( conn, SendorAddress);
  utl_smtp.rcpt( conn, ReceiverAddress );
/* Making Message buffer */
  mesg:= 
        'Date: '||TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' )|| crlf ||
         'From:'||SendorAddress|| crlf ||
         'Subject: Mail Through ORACLE Database' || crlf ||
         'To: '||ReceiverAddress || crlf ||
         '' || crlf ||mesg_body||'';
/* Configure Sending Message */
/*You need to put 'MIME-Verion: 1.0' (this is case-sensitive!) */
 /*Content-Type-Encoding is actually Content-Transfer-Encoding. */
/*The MIME-Version, Content-Type, Content-Transfer-Encoding should */
/* be the first 3 data items in your message */ 
utl_smtp.data(conn, 'MIME-Version: 1.0' ||CHR(13)|| CHR(10)||'Content-type: text/html' || CHR(13)||CHR(10)||mesg);    
/* Closing Connection */
utl_smtp.quit( conn );
/* End of logic */
END;
/
