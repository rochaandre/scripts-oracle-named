REM This query will helpp you see how much undo tablespace you require based on the recent usage and your undo_retention parameter. 

SELECT begin_time, 
txncount-lag(txncount) over (order by end_time) as txncount, 
maxquerylen, 
maxconcurrency, 
undoblks/((end_time - begin_time)*86400) as bks_per_sec, 
(undoblks/((end_time - begin_time)*86400)) * t.block_size/1024 as kb_per_second, 
((undoblks/((end_time - begin_time)*86400)) * t.block_size/1024) * TO_NUMBER(p2.value)/1024 as undo_MB_required, 
ssolderrcnt, 
nospaceerrcnt 
FROM v$undostat s, 
dba_tablespaces t, 
v$parameter p, 
v$parameter p2 
WHERE t.tablespace_name = UPPER(p.value) 
AND p.name = 'undo_tablespace' 
AND p2.name = 'undo_retention' 
ORDER BY begin_time 
; 
