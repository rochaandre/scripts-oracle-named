insert into crescimento_database (TABLESPACE_NAME,DATAFILE_NAME, BYTES,FREE_BYTES)
select TABLESPACE_NAME,DATAFILE_NAME, BYTES,FREE_BYTES
from crescimento_database
where time like '%22-AUG-03%'


update crescimento_database set time='29-AUG-03'
where time is null



select distinct time from crescimento_database;

select ''''||rowid||''',',to_char(time,'dd/mm/yyyy - hh24:mi:ss') from crescimento_database
 where to_char(time,'dd/mm/yy') = '15/04/05';