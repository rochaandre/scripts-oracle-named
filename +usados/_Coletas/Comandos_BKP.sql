select distinct a.tablespace_name, b.status
from dba_data_files a , v$backup b
where a.file_id =b.file#
and b.status = 'ACTIVE'
/