REM *******************************************************************************************
REM **** EXPLAIN PLAN *****
REM * Criando a tabela

@C:\oracle\ora92\rdbms\admin\utlxplan.sql

REM **** EXPLAIN PLAN DE UM OBJETO *****

explain plan
set statement_id = 'demo' for
select * from  dba_objects 
where owner = 'SYS';


REM **** MOSTRANDO o PLANO DE EXECUÇÃO *****
 select id,
        lpad (' ',2*level)||operation
        ||decode(id,0,' Cost = ' ||position)
        ||' '||options
        ||' '||object_name as "Query Plan"
 from    plan_table
 where   statement_id = 'demo'
 connect by prior id = parent_id
 start   with id = 0
 /

