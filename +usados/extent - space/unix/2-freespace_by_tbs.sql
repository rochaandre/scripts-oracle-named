-- Tablespace Summary report
--Note: You need to connect as SYS or 
--need direct grants on dba_data_files to run this report.



Set linesize 120 pagesize 60 feedback off heading on
ttitle skip center "Space usage report by Tablespace" skip 2
col Tablespace format a15
set numformat 999999.9
clear breaks
clear computes


create or replace view dbadmin.temprpt_free as select tablespace_name,sum(bytes) free
from sys.dba_free_space
group by tablespace_name;

create or replace view dbadmin.temprpt_bytes as
select tablespace_name,sum(bytes) bytes
from sys.dba_data_files
group by tablespace_name;

create or replace view dbadmin.temprpt_status as
select a.tablespace_name,free,bytes
from temprpt_bytes a,temprpt_free b
where a.tablespace_name=b.tablespace_name(+);

spool c:\freespace_by_tbs.log

select  tablespace_name        "Tablesapce",
        round(bytes/(1024*1024),1)                   "Size_Mb",
        round(nvl(bytes-free,bytes)/(1024*1024),1)   "Used_Mb",
        round(nvl(free,0)/(1024*1024),1)             "Free_Mb",
        round(nvl(100*(bytes-free)/bytes,100),1)     "Used_%"
from temprpt_status
order by 5 desc;

ttitle off

select rpad('Total',30,'.')                    " ",
        round(sum(bytes)/(1024*1024),1)                 " ",
        round(sum(nvl(bytes-free,bytes))/(1024*1024),1)             " ",
        round(sum(nvl(free,0))/(1024*1024),1)                       " ",
        round((100*(sum(bytes)-sum(free))/sum(bytes)),1) " "
from temprpt_status;


--drop view temprpt_bytes;
--drop view temprpt_free;
--drop view temprpt_status;

spool off



select  a.tablespace_name        		     "Tablesapce",
        round(sum(a.bytes)/(1024*1024),1)                   "Size_Mb",
        round(nvl(sum(a.bytes)-sum(b.bytes),sum(b.bytes))/(1024*1024),1)   "Used_Mb",
        round(nvl(sum(b.bytes),0)/(1024*1024),1)             "Free_Mb",
        round(nvl(100*(sum(a.bytes)-sum(b.bytes))/sum(a.bytes),100),1)     "Used_%"
from dba_data_files a, dba_free_space b
group by a.tablespace_name
order by 5 desc
/


select a.tablespace_name, sum(b.bytes) free, sum(a.bytes) bytes
from dba_data_files a, dba_free_space b
where a.tablespace_name=b.tablespace_name(+)
group by a.tablespace_name

/