//Description
//Script reports most a number of space related information

//Parameters
//None

//SQL Source
//REM Copyright (C) Think Forward.com 1998, 2003. All rights reserved. 

set     heading    off
set     pagesize   23
set     verify     off
set     feedback   off
set     worksize   2000
set     maxdata    4000
set     arraysize  1
rem
COLUMN  act_blocks   FORMAT 99,999,999   HEADING "Used|Blocks";
column  admin_option format a15
column  archived     format a8
column  avg_space    format 9,999     Heading "Free|Bytes"
column  avg_row_len  format 9,999     Heading "Avg. Row|Length"
COLUMN  blocks       FORMAT 99,999,999   HEADING "Blocks|Alloctd";
column  bytes        format 9,999,999,999 heading "Bytes Grabbed"
column  chain_cnt    format 99,999 heading "Chained Rows"
column  clustering_factor format 999,999 heading "Indx Clustr|Factor"
column  db_link      format a20
column  dts          format a10
column  default_role format a20
column  default_ts   format a15
column  description  format a35
column  distinct_keys format 9,999,999 heading "Distinct|Keys"
column  empty_blocks format 999,999 heading "Blocks|Empty"
column  executions   format 9,999,999  heading "Execs"
COLUMN  extents      FORMAT 999    HEADING "Xtent";
column  ext          format 999
column  file_name    format a29 heading "File Name"
column  file_id      format 999 heading "FileId"
column  file#        format 999 heading "File#"
column  free         format 9,999,999,999
column  global_name  format a50
column  grantable    format a10 heading "with Admin"
column  grantor      format a10 heading "Granted By"
column  grantee      format a17 heading "Granted To"
column  granted_role format a20
column  host         format a20
column  index_name   format a23
column  largest      format 999,999,999
column  last_number  format 999,999,999
column  leaf_blocks  format 999,999 heading "Leaf|Blocks"
column  limit        format a10
column  loads        format 99999 heading "Loads"
column  name         format a30
column  network      format a25
column  num_rows     format 99,999,999 heading "Num. of|Rows"
column  object_name  format a33
column  objects      format a20
column  object_type  format a15
column  osuser       format a10
column  owner        format a08
column  pct_busy     format 999.99 heading "%Busy"
column  pct_used     format 999.99 heading "%Used"
COLUMN  pct_block    FORMAT 999.99 HEADING "%Used|Blocks";
column  privilege    format a12
column  profile      format a10
column  resource_name format a40
column  role         format a10
column  rowcnt       format 999,999,999
COLUMN  rows_num     FORMAT 999,999,999 HEADING "Num.|of Rows";
column  segment_name format a15 heading "Segment Name"
column  sharable_mem format 999,999  heading "Memory"
COLUMN  s_id         NOPRINT new_value s_id;
column  status       format a6  heading "Status"
column  synonym_name format a25
column  table_name   format a33 heading "Table|Name"
column  table_owner  format a08
column  temp_ts      format a15
column  trigger_name format a20 heading "Trigger|Name"
column  trigger_type format a20 heading "Trigger|Type"
column  ttype        format a06 heading "TType"
column  ts           format a14
column  tablespace_name format a15 heading "Tablespace "
column  tts          format a10
column  type         format a12
column  type_name    format a25
COLUMN  t_date NOPRINT new_value t_date;
column  username     format a15
column  user_id      format 999 heading "UsrId"
column  used         format 9,999,999,999
column  value        format a45
column  value1       format 9,999,999
column  a  format  a17       heading  'Cache'
column  b  format  99999990  heading  'Gets'
column  e  format  9990      heading  'Usage'
column  f  format  99990     heading  'Count'
column  g  format  990       heading  '%Usage'

SELECT value s_id from v$parameter
 where name='db_name';
/
spool space.lis

set heading off;
select  'v7dba  Report generated on '||
        to_char(sysdate,'DD-MON-YY HH24:MI:SS')||' by '||
        user
from    sys.dual
/
set heading on
prompt
prompt *********************************************************************
prompt *    Key Oracle components and their version numbers
prompt *********************************************************************

select * from v$version
  order by banner
/
prompt
prompt *********************************************************************
prompt *   The Date and Time when the database was installed
prompt *********************************************************************
prompt
select name, created, log_mode  from v$database
/
prompt
prompt *********************************************************************
prompt *    Database Tablespaces to OS File Mappings
prompt *********************************************************************
column  status       format a7  heading "Status"
compute sum of bytes blocks on report
break on report
set heading on
select  file_name, tablespace_name, bytes, blocks, substr(status,1,5) status
from    sys.dba_data_files
order by file_name, file_id
/
clear computes
prompt
prompt *********************************************************************
prompt *    Database Rollback Segments to OS File Mappings
prompt *********************************************************************
column  status       format a7  heading "Status"
set heading on
select  os.file_name, rbs.tablespace_name,
	rbs.owner||'.'||rbs.segment_name segment_name, rbs.status
from    sys.dba_rollback_segs rbs, sys.dba_data_files os
where   os.file_id = rbs.file_id
order by 1
/
prompt *********************************************************************
prompt *    Rollback Segments Statistics
prompt *********************************************************************
col name format a7
select name, rssize, optsize, shrinks, wraps, extends, aveshrink
from v$rollname, v$rollstat
where v$rollname.usn = v$rollstat.usn
/
prompt
prompt *********************************************************************
prompt *    Datafile Information
prompt *********************************************************************
column  name         format a33
column  status       format a7  heading "Status"
compute sum of bytes on report
set heading on
select  name, file#, bytes, status
from    v$datafile
order by name
/
clear computes
prompt
prompt *********************************************************************
prompt *    Tablespace Storage Allocation and Percent of space used
prompt *********************************************************************

compute sum of bytes used free on report
break on report

select  a.tablespace_name ts,
	a.file_id,
	sum(b.bytes)/count(*) bytes,
	sum(b.bytes)/count(*) - sum(a.bytes) used,
	sum(a.bytes) free,
	nvl(100-(sum(nvl(a.bytes,0))/(sum(nvl(b.bytes,0))/count(*)))*100,0) pct_used
from    sys.dba_free_space a,
	sys.dba_data_files b
where   a.tablespace_name = b.tablespace_name and
	a.file_id = b.file_id
group   by a.tablespace_name, a.file_id
/
clear computes
prompt
prompt
prompt *********************************************************************
prompt *    Table/Indexes Bytes and extents
prompt *********************************************************************
column  name         format a33
set     heading on
compute sum of bytes on report
break on OWNER  skip 1 on segment_type skip 2
select  owner,
	extents,
	bytes,
	segment_type  TYPE,
	segment_name  NAME
from    sys.dba_segments
where   owner <> 'SYS' and owner <> 'SYSTEM'
order by owner, segment_type, segment_name
/
clear computes
prompt
prompt
prompt *********************************************************************
prompt *    Tables with extents > 10  do something if u must.......
prompt *********************************************************************
column  name         format a33
set     heading on

break on OWNER  skip 1 on segment_type
select  owner,
	extents,
	bytes,
	segment_type  TYPE,
	segment_name  NAME
from    sys.dba_segments
where   owner <> 'SYS' and owner <> 'SYSTEM'
and extents > 10
order by owner, segment_type, segment_name
/
prompt
prompt *********************************************************************
prompt *    Tables by Tablespaces
prompt *********************************************************************

column  tablespace_name format a25 heading "Tablespace Name"
break on OWNER  skip 1

select  owner, tablespace_name, table_name
from    sys.dba_tables
where   owner <> 'SYS' and owner <> 'SYSTEM'
order by owner, tablespace_name, table_name
/
prompt
prompt
prompt *********************************************************************
prompt *    Tables which contain chained rows
prompt *
prompt ****NOTE: you will only get stats if you have run the ANALYZE command
prompt *         against the tables
prompt *********************************************************************
set heading on
column table_name   format a33

break on OWNER  skip 1
select owner, table_name, num_rows, chain_cnt
  from sys.dba_tables
  where chain_cnt > 0   and
	owner <> 'SYS' and owner <> 'SYSTEM'
order by owner, table_name
/
set heading off
prompt
	select  'End of Report for SID=&s_id '||
	to_char(sysdate,'DD-MON-YY HH24:MI:SS')||' by '||
	user
from    sys.dual
/
spool off
set head on


