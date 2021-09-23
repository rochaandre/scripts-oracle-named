-- Tablespace framgentation Report.
--Note: You need to connect as SYS or 
--      need direct grants on dba_data_files to run this report.



comp sum of nfrags totsize freesize on report
break on report

set numformat 999,999,990

col sname    justify l        format      a15 
col tbs                       format      a15 
col nfrags                heading 'Free|Frags'
col maxfrag  justify c    heading 'Largest|Frag (KB)'
col maxnext  justify c    heading 'Largest|Next Extent (KB)'
col totsize               heading 'Total|(KB)'
col freesize              heading 'Available|(KB)'
col pctused               heading 'Pct|Used'

column name noprint new_value dbname
select name from v$database;

create or replace view aps_data_files as
  select  tablespace_name, sum(bytes) bytes
  from    dba_data_files
  group by tablespace_name;

spool c:\freespace_frag.log
ttitle left "Database: "dbname" - Tablespace Fragmentation Report" skip 2

select  t.tablespace_name                        tbs,      
        count(f.bytes)                           nfrags,
        nvl(max(f.bytes)/1024,0)                 maxfrag,
        t.bytes/1024                             totsize,
        nvl(sum(f.bytes)/1024,0)                 freesize,
        (1-nvl(sum(f.bytes),0)/t.bytes)*100      pctused
from  aps_data_files  t, dba_free_space  f
where t.tablespace_name = f.tablespace_name(+)
group by t.tablespace_name, t.bytes;

select fs.tablespace_name tbs, max(s.next_extent)/1024 maxnext,
       max(fs.bytes)/1024 maxfrag, max(segment_name) sname
from dba_free_space fs, dba_segments s
where fs.tablespace_name=s.tablespace_name
group by fs.tablespace_name
having max(s.next_extent) > max(fs.bytes);


ttitle off
spool off
-- drop view aps_data_files;

