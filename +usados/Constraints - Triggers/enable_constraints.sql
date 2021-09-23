/* Before enabling referential constraints, primary key
 constraints must be enabled. */


set linesize 100
set pagesize 0
set feedback off
spool enable_constraints.out

prompt ---- Check Constraints

select ' alter table '||owner||'.'||table_name||' enable novalidate constraint '||constraint_name||';'
from dba_constraints
where owner in ('ESS','OEBS')
and constraint_type='C'
and status != 'ENABLED';

prompt ---- Unique Constraints

select ' alter table '||owner||'.'||table_name||' enable novalidate constraint '||constraint_name||';'
from dba_constraints
where owner in ('ESS','OEBS')
and constraint_type='U'
and status != 'ENABLED'; 

prompt ---- Primary Constraints

select ' alter table '||owner||'.'||table_name||' enable novalidate constraint '||constraint_name||';'
from dba_constraints
where owner in ('ESS','OEBS')
and constraint_type='P'
and status != 'ENABLED';

prompt ---- Referential Constraints

select ' alter table '||owner||'.'||table_name||' enable novalidate constraint '||constraint_name||';'
from dba_constraints
where owner in ('ESS','OEBS')
and constraint_type='R'
and status != 'ENABLED';

spool off

