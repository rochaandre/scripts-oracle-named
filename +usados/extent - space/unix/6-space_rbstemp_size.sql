/*
 *   Rollback and Temp space utilization Report.
 *
 */

set pagesize 60  linesize 120  heading on feedback off

clear breaks
clear computes

col segment_type format a5 justify c heading 'Type'
col owner format a10 justify c heading 'Owner'
col segment_name  format         a26 justify c heading 'Name'
col tablespace_name  format      a20 justify c heading 'Tablespace'
col extents format 999 justify c heading '#Ext'
col max_extents format 999 justify c heading 'MaxExt'
col totsize format 999,999,999 justify c heading 'Total|(KB)'
col init    format 9,999,999 justify c heading 'Initial|(KB)'
col next    format 999,999 justify c heading 'Next|(KB)'
col "#rows" format 9,999,999  

spool c:\space_rbstemp_size.log

column name noprint new_value dbname
select name from v$database;

ttitle left "Database: "dbname" - Rollback  Temp segment utilization Report" skip 2 

select a.owner owner,a.tablespace_name,a.segment_name,a.max_extents,a.extents,
a.bytes/1024 totsize, a.initial_extent/1024 init, a.next_extent/1024 next
from dba_segments a
where a.segment_type in ('ROLLBACK','TEMP')
order by totsize desc;

ttitle off
spool off
