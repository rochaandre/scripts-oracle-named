-- Displays tables with chained rows
-- Analyze tables before running this script
spool C:\list_chained_rows.log

execute dbms_stats.gather_schema_stats('SCOTT',cascade=>true);

select table_name,num_rows,chain_cnt, avg_row_len, pct_free, pct_used
from dba_tables
where chain_cnt > 0
order by chain_cnt desc;

spool off

