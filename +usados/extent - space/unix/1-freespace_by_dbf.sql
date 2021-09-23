-- Space usage report by datafile 


Set linesize 120 pagesize 60 feedback off heading on
ttitle skip center "Space usage report by datafile" skip 2
col tablespace format a15
col file format a35
set numformat 99999.9

clear breaks
clear computes
break on Tablespace skip 1  on report skip 2


compute sum  of Total(M) on tablespace 
compute sum  of Used(M)  on tablespace
compute sum  of Free(M)  on tablespace
compute avg  of %_Free  on tablespace
compute sum  of Total(M) on report
compute sum  of Used(M)  on report
compute sum  of Free(M)  on report

spool c:\freespace_by_dbf.log
select b.file_name "File",
       b.tablespace_name "Tablespace",
       b.bytes/(1024*1024) "Total(M)",
       round((b.bytes - sum(nvl(a.bytes,0)))/(1024*1024),1) "Used(M)",
       round(sum(nvl(a.bytes,0))/(1024*1024),1) "Free(M)",
       round((sum(nvl(a.bytes,0))/(b.bytes))*100,1) "%_Free"
from   sys.dba_free_space a,sys.dba_data_files b
where  a.file_id(+) = b.file_id
group by b.tablespace_name, b.file_name, b.bytes
order by b.tablespace_name;

ttitle off
spool off


