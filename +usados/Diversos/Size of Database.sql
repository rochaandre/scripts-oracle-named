REM OCUPADO
select 'Sum of all Segments (Objects) to be owned by this User: '|| round(sum(bytes)/1024/1024,3)|| ' MB' 
from dba_segments 
where owner=upper('&&user'); 

REM LIVRE
select sum(bytes/1024/1024)
from dba_Free_space;