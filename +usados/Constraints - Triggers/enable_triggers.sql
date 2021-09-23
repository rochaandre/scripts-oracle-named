-- Generates script to enable triggers

set linesize 100  pagesize 0  feedback off
spool enable_triggers.out

select ' alter table '||owner||'.'||table_name||' enable all triggers;'
from dba_triggers
where owner in ('ESS','OEBS');
spool off
