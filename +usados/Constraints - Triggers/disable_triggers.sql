set linesize 100 pagesize 0  feedback off
spool disable_triggers.out

select ' alter table '||owner||'.'||table_name||' disable all triggers;'
from dba_triggers
where owner in ('ESS','OEBS');
spool off
