select 'ALTER ' || OBJECT_TYPE || ' ' ||  OWNER || '.' || OBJECT_NAME || ' COMPILE;'
from dba_objects
where status = 'INVALID'
and object_type in ('PACKAGE','PACKAGE BODY','FUNCTION','PROCEDURE','TRIGGER')
/



select
    decode( OBJECT_TYPE, 'PACKAGE BODY',
    'alter package ' || OWNER||'.'||OBJECT_NAME || ' compile body;',
    'alter ' || OBJECT_TYPE || ' ' || OWNER||'.'||OBJECT_NAME || ' compile;' )
from 
   dba_objects 
where 
   STATUS = 'INVALID' and OBJECT_TYPE in 
   ( 'PACKAGE BODY', 'PACKAGE', 'FUNCTION', 'PROCEDURE', 'TRIGGER', 'VIEW' ) 
order by OWNER, OBJECT_TYPE, OBJECT_NAME ;


@/$ORACLE_HOME/rdbms/admin/utlrp -> compila TODOS os objetos inválidos