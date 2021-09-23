
/* Lists all constraints which are based on column CUST_UID.
  This helps findout any referential constraints pointing to 
  this column. You can also give constraint_type = R. So it
  lists only Referential constraints for that column.  

  In order to disable a primary constraint first you have to
  disable all referential constraints pointing to that. It becomes
  difficult to trace which constraints are pointing to this especially
  if it involves constraints from different tables. This script helps
  in identifying them.
*/


set linesize 120
col owner format a10
col tab format a25
col cons_name format a20
col col_name format a20
break on tab
spool list_constraints.out

select distinct a.owner owner,a.table_name    tab,
                       a.constraint_name cons_name,
                       a.constraint_type,
                       b.column_name col_name
  from dba_constraints a, dba_cons_columns b
  where a.table_name = b.table_name
   and   a.constraint_name = b.constraint_name
   and a.owner in ('ESS','OEBS')
   and b.column_name = 'CUST_UID'
   order by a.owner,a.table_name,  a.constraint_type,  a.constraint_name;
spool off

