//This PL/SQL script reports the %space left on each tablespace 

DECLARE
CURSOR cur_ts IS
SELECT tablespace_name, 
SUM(bytes/1024/1024) bytes
FROM dba_data_files
GROUP BY tablespace_name;

CURSOR cur_ts_fs(p_ts VARCHAR2) IS 
SELECT SUM(BYTES/1024/1024) fs, 
MAX(bytes/1024/1024) mx
FROM dba_free_space 
WHERE tablespace_name = p_ts;

lv_fs NUMBER := 0;
percent_fs NUMBER := 0;
large_fs NUMBER := 0;
lv_name V$database.name%TYPE;

BEGIN
DBMS_OUTPUT.enable(1000000);
SELECT name into lv_name from v$database;

DBMS_OUTPUT.PUT_LINE('*****************'||lv_name||' Database -- Tablespace Summary - Freespace Report *********************');

DBMS_OUTPUT.PUT_LINE('Tablespace name ' ||
' Total Space(M)' ||
' Used Space(M) ' ||
'Largest Free Space(M)' ||
' %Free Space');

DBMS_OUTPUT.PUT_LINE('**************** ' ||
' **************' ||
' ************* ' ||
'*********************' ||
' ***********');

FOR lv_cur_ts IN cur_ts LOOP

FOR lv_cur_ts_fs IN cur_ts_fs(lv_cur_ts.tablespace_name) LOOP

lv_fs := lv_cur_ts.bytes - lv_cur_ts_fs.fs;
percent_fs := ( (lv_cur_ts_fs.fs) /(lv_cur_ts.bytes) ) * 100;
large_fs := lv_cur_ts_fs.mx;

END LOOP;


DBMS_OUTPUT.PUT_LINE(RPAD(lv_cur_ts.tablespace_name,20)||
LPAD(lv_cur_ts.bytes,20)||
LPAD(lv_fs,20)||
LPAD(large_fs,20)||
LPAD( ROUND(percent_fs,2),12)
);

END LOOP;

END;
/