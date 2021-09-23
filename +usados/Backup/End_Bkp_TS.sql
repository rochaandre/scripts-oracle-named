select 'alter tablespace '|| a.tablespace_name || ' end backup;'
from dba_Data_files a, v$backup b
where a.file_id=b.file#
and b.status = 'ACTIVE';
/