-- Generates script and recompiles invalid objects 

Set linesize 100 pagesize 60 feedback off heading off
ttitle off
spool ./log/recompile_obj_invalid.out

select 'Alter '||decode(object_type,'PACKAGE BODY','PACKAGE',object_type)||' '||owner||'.'||object_name||' compile '||decode (object_type,'PACKAGE BODY',' body;',';') 
from dba_objects
where status = 'INVALID'
and owner != 'SYS';

spool off
@./log/recompile_obj_invalid.out