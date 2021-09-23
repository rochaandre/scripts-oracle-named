select tablespace_name TS_NAME	,			/* Nome da Tablespace                */		
       sum(bytes)/1024 /1024	SIZE_MB	,		/* Total de Bytes da Tablespace      */
       round(sum(free_bytes)/1024 /1024,2) FREE_MB ,		/* Total de Bytes Free da Tablespace */	
       round((sum(free_bytes)/sum(bytes))*100,2) FREE_PERCENT,	/* % Free da Tablespace              */
       round(((sum(bytes)-sum(free_bytes)))/1024 /1024,2) USED_MB,	/* Total de Bytes Used da Tablespace */
       round(((sum(bytes)-sum(free_bytes))/sum(bytes))*100,2) USED_PERCENT/* % Used da Tablespace              */
from crescimento_database
where to_char(time,'dd/mm/yy') = '03/10/03'
group by trunc(time),tablespace_name


select datafile_name DF,					/* Nome do Datafile                  */
       tablespace_name TS,						/* Nome da Tablespace                */
       round(bytes/1024 /1024) SIZE_MB ,				         /* Total de Bytes do Datafile        */
       round(free_bytes/1024 /1024) USED_MB,                         /* Total de Bytes Free do Datafile   */
       round((free_bytes/bytes)*100,2) FREE_PERCENT,                    /* % Free do Datafile                */
       round((bytes-free_bytes)/1024 /1024) FRE_MB,           /* Total de Bytes Used do Datafile   */
       round(((bytes-free_bytes)/bytes)*100,2) USED_PERCENT                       /* % Used do Datafile                */
from crescimento_database
where to_char(time,'dd/mm/yy') = '26/09/03'
order by datafile_name


select distinct time
from crescimento_database
where to_char(time,'dd/mm/yy') like '%19/09/03%'

delete crescimento_Database
where to_char(time,'dd/mm/yy hh:mi:ss') like '%4:53:12%'

commit