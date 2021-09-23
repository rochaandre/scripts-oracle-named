select 
a.TABLESPACE_NAME,
a.total,nvl(b.used,0) USED,
nvl((b.used/a.total)*100,0) PCT_USED
from
(select TABLESPACE_NAME,
sum(bytes)/(1024*1024) total
from sys.dba_data_files
group by TABLESPACE_NAME) a,
(select TABLESPACE_NAME,bytes/(1024*1024) used 
from sys.SM$TS_USED) b
where a.TABLESPACE_NAME=b.TABLESPACE_NAME(+)
/
