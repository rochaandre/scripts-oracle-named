SET lines 150 PAGES 999 TRIMS ON ECHO OFF VERIFY OFF FEEDBACK OFF

PROMPT 

ACCEPT sid NUMBER PROMPT 'Enter SID: '
ACCEPT serial NUMBER PROMPT 'Enter SERIAL#: '

COLUMN sql_text HEADING "SQL Statement" Format a100

SELECT T.sql_text
FROM v$session S, 
  v$sqltext_with_newlines T
WHERE S.sid = &sid
  AND S.serial# = &serial
  AND S.sql_address = T.address
  AND S.sql_hash_value = T.hash_value
ORDER BY T.piece
/


SET TRIMS ON ECHO OFF VERIFY ON FEEDBACK ON
