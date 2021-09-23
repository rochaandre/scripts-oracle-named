SELECT TRUNC( SUM(VALUE)/1024/1024)  FROM V$SGA
/
SELECT TRUNC((1-(PHY.VALUE/(CUR.VALUE+CON.VALUE)))*100) 
FROM V$SYSSTAT CUR, V$SYSSTAT CON, V$SYSSTAT PHY 
WHERE CUR.NAME = 'db block gets' 
and con.name  = 'consistent gets' 
and phy.name = 'physical reads'
/
SELECT TRUNC(100-(SUM(GETMISSES)/SUM(GETS))) FROM V$ROWCACHE
/
SELECT TRUNC(GETHITRATIO*100) FROM V$LIBRARYCACHE
WHERE NAMESPACE = 'SQL AREA'
/
SELECT COUNT(*)  
FROM V$SESSION  
WHERE USERNAME NOT IN ('SYS','SYSTEM','NULL')  
/
select trunc(months_between(sysdate,startup_time)*2592000) from v$instance
/



SELECT TRUNC( SUM(VALUE)/1024/1024)  FROM V$SGA
/
select trunc(months_between(sysdate,startup_time)*2592000) from v$instance
/

select round (((1 - (sum(decode(name, 'physical reads', value, 0)) / 
                    (sum(decode(name, 'db block gets', value, 0)) +
                     sum(decode(name, 'consistent gets', value, 0))))) * 100), 2) "Buffer Hit Ratio"
from v$sysstat
/
select round (((1 - (sum(getmisses)/(sum(gets) + 
                     sum(getmisses)))) * 100), 2)  "Data Dictionary Hit Ratio"
from v$rowcache
/
select round (((sum(pinhits)/sum(pins)) * 100), 2) "Pin Hit Ratio",
       round (((sum(pins)/(sum(pins) + sum(reloads))) * 100), 2) "Rel Hit Ratio"
from v$librarycache
/
SELECT COUNT(*)  
FROM V$SESSION  
WHERE USERNAME NOT IN ('SYS','SYSTEM','NULL')  
/


