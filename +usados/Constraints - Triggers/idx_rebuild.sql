-- Generates script to rebuild indexes

set linesize 120
set pagesize 60
set feedback off
spool idx_rebuild.out

select table_name||' alter index '||rtrim(owner)||'.'||index_name||' rebuild tablespace indx unrecoverable;'
from sys.dba_indexes
where table_owner in ('ESS','OEBS')
order by owner,index_name;

spool off

