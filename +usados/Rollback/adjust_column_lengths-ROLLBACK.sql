ttitle off 
clear columns 
clear breaks 
column upper(value) new_value _DB_NAME 
select upper(value) from v$parameter 
where upper(name) = 'DB_NAME'; 

column usn format 990 
column extents format 99,999 heading "EXT" 
column shrinks format 9,999,999 
column extends format 9,999,999 
column xacts format 999 heading "ACT" 
column waits format 999,999 
column wraps format 99,999 
column writes format 999,999,999,999 
rem column aveshrink format 99,999 heading "AVE|SHRNK" 
column status format a10 
column rssize format a6 
column optsize format a6 
column hwmsize format a6 
column segment_name format a6 heading NAME 
ttitle 'Rollback Report For &_DB_NAME' 
break on report 
compute sum of WRITES on report 
compute sum of GETS on report 
compute sum of WAITS on report 
compute sum of AVEACTIVE on report 
set pages 1000 lines 160 

select d.segment_name, r.XACTS, r.EXTENTS, 
floor(RSSIZE/1024/1024)||'M' RSSIZE, 
floor(OPTSIZE/1024/1024)||'M' OPTSIZE, 
floor(HWMSIZE/1024/1024)||'M' HWMSIZE, 
r.GETS, r.WAITS, abs(WRITES) WRITES, 
r.SHRINKS, r.EXTENDS, r.WRAPS, r.AVESHRINK, 
r.AVEACTIVE, d.STATUS 
from v$rollstat r, v$rollname n, dba_rollback_segs d 
where r.usn (+) = n.usn 
and n.name (+)= d.segment_name 
order by segment_name 
/*order by abs(WRITES) desc*/ 
/ 
