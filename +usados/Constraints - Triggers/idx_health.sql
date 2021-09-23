-- Index leaf block fragmentation
-- if the pct_del is more than 30% you should rebuild the indexes

set echo off feedback off  linesize 100
clear breaks
clear computes
spool ./log/idx_health.log

col owner format a10
col index_name format a15

select a.owner,a.index_name, b.blocks, b.pct_used, b.distinct_keys leaf_rows,
       b.del_lf_rows, (b.del_lf_rows/b.lf_rows)*100 pct_del
from dba_indexes a, index_stats b
where a.owner not in ('SYS')
  and a.index_name=b.name
order by 7;

spool off