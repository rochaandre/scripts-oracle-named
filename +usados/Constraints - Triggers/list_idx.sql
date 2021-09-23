-- Generates list of indexes

set pagesize 60  linesize 200 heading on feedback off
clear breaks
clear computes
col IdxOwner format a10 
col tablespace format a15
col tab   format    a15
col indx   format    a20
col column_name  format    a15

ttitle left "  List of Indexes " skip 2 
break on idxowner on tab on indx on tablespace on uniqueness
spool list_idx.out

select a.owner IdxOwner,a.table_name Tab,a.index_name Indx,
   a.tablespace_name Tablespace,
   a.uniqueness,b.column_name,b.column_position Pos
from dba_indexes a,dba_ind_columns b
where a.owner in ('ESS','OEBS')
and a.index_name=b.index_name
order by owner;

ttitle off
spool off
