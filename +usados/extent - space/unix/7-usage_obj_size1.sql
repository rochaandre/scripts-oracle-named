 /*
 *
 *  Segment utilization report
 *
 *
 */

set linesize 120 pagesize 60 feedback off heading on
clear breaks
clear computes

col segment_type format a5 justify c heading 'Type'
col owner format a10 justify c heading 'Owner'
col segment_name  format         a26 justify c heading 'Name'
col extents format 999 justify c heading '#Ext'
col totsize format 999,999,999 justify c heading 'Total|(KB)'
col init    format 9,999,999 justify c heading 'Initial|(KB)'
col next    format 999,999 justify c heading 'Next|(KB)'
col incr    format 99 justify c heading '%Incr'

spool c:\usage_obj_size1.log
column name noprint new_value dbname
select name from v$database;

ttitle left "Database: "dbname" - All segment utilization Report" skip 2 

select segment_name, segment_type, extents,
bytes/1024 totsize, initial_extent/1024 init, next_extent/1024 next,
pct_increase incr
from dba_segments
where owner not in ('SYS','SYSTEM')
order by totsize desc;

ttitle off
spool off
