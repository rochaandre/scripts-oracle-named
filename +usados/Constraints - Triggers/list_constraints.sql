/* You may wonder why not use group by clause instead of
break function. when you do group by you have to group by
all colummns in the query except columns with grouping 
functions, like count(*) on so on.

And also you can't include a column in order by clause
without selecting in the select clause */


set linesize 120 pagesize 60 feedback off
col owner format a10
col tab format a25
col cons_name format a20
col col_name format a20
ttitle skip center "List of constraints" skip 2

break on owner on tab on cons_name on status on constraint_type
spool list_constraints.out

select distinct a.owner owner,a.table_name    tab,
                       a.constraint_name cons_name,
                       a.status,
                       a.constraint_type,
                       b.column_name col_name,
                       b.position
  from dba_constraints a, dba_cons_columns b
  where a.table_name = b.table_name
    and   a.constraint_name = b.constraint_name
   and a.owner in ('ESS','OEBS')
   order by a.owner,a.table_name,a.constraint_type,a.constraint_name,b.position;

ttitle off
spool off

