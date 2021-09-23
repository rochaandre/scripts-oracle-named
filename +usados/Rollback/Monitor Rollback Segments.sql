set pages 200 verify off
col user0 form a15
col comm0 form a15
col name0 form a10
col extents0 form 999 Heading "Extents"
col shrinks0 form 999 Heading "Shrinks"
col waits form 9999 heading "Wraps"

spool monroll.lst

select 
       rn.name    name0,
       s.username user0,
       r.rssize ,
       r.waits,
       r.extents  extents0, 
       r.shrinks shrinks0,
	 r.optsize,
       decode (s.command,
                 0,'No Command',
                 1,'Create Table',
                 2,'Insert',
                 3,'Select',
                 6,'Update',
                 7,'Delete',
                 9,'Create Index',
                15,'Alter Table',
                21,'Create View',
                23,'Validate Index',
                26,'Lock Table',
                35,'Alter Database',
                39,'Create Tablespace',
                41,'Drop Tablespace',
                40,'Alter Tablespace',
                44,'Commit',
                45,'Rollback',
                46,'Savepoint', 
                48,'Set Transaction', 
                53,'Drop User',
                62,'Analyze Table',
                63,'Analyze Index',
                'lookup '||to_char(s.command)) comm0
from v$session s, v$transaction t, v$rollstat r, v$rollname rn
where s.taddr (+) = t.addr 
and t.xidusn (+) = r.usn 
and rn.usn = r.usn 
order by rn.name
/

SELECT   rn.name name0
	 , p.pid
         ,p.spid 
         , NVL (p.username, 'NO TRANSACTION') user0
         , p.terminal
FROM v$lock l, v$process p, v$rollname rn
WHERE    l.sid = p.pid(+)
AND      TRUNC (l.id1(+)/65536) = rn.usn
AND      l.type(+) = 'TX'
AND      l.lmode(+) = 6
ORDER BY rn.name;

prompt  
prompt If the ratio of waits to gets is more than 1% or 2%, consider  
prompt creating more rollback segments  
prompt  

col Name  Format A30         Heading 'RollBack Segment'
col Gets  Format 999,999,999 Heading 'Number of|Activities'
col Waits Format 999,999,999 Heading 'Number|of Waits'
col Pct   Format 990.99      Heading 'Pct of|Gets'
 
select 'The average of waits/gets is '||  
   round((sum(waits) / sum(gets)) * 100,2)||'%'  
From    v$rollstat  
/  

prompt Another way to gauge rollback contention is:  
prompt  
  
column xn1 format 9999999  
column xv1 new_value xxv1 noprint  
 
set head on  

select 'Total requests = '||sum(count) xn1, sum(count) xv1  
from    v$waitstat  
/  
 
select class, count  
from   v$waitstat  
where  class in ('system undo header', 'system undo block', 
                 'undo header',        'undo block'          )  
/  

select 'Contention for '||class||' = '||  
       (round(count/(&xxv1+0.00000000001),4)) * 100||'%'  
from    v$waitstat  
/  

PROMPT
PROMPT  Time since last WRAP
PROMPT
select n.name
       , round( 
           24*((sysdate-startup_time) - trunc(sysdate-startup_time)) /  
                          (s.writes/s.rssize),1) "Hours" 
from v$instance ,v$rollname n,v$rollstat s 
where n.usn = s.usn 
and s.status = 'ONLINE'
