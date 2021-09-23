-------------------------------------------------------------------------------
--
-- Script:	dump_logfile.sql
-- Purpose:	to assist with dumping the contents of a log file
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column member format a15
column path new_value Path noprint

select
--  l.thread#,
  l.sequence#,
  l.status,
  to_char(l.first_time, 'DD-MON HH24:MI:SS') first_time,
  substr(f.member, instr(translate(f.member, '\', '/'), '/', -1) + 1)
    member,
  f.member  path
from
  sys.v_$log l,
  sys.v_$logfile f
where
  l.group# = f.group#
order by
  1,
  2
/

prompt
@accept Path "Logfile" &Path
@accept Options "Options" "?"

set pagesize 0
set termout off
set echo off

spool dump_logfile.tmp
select
  decode(rownum,
   2, 'prompt rba min <thread#> . <block#>',
   3, 'prompt rba max <thread#> . <block#>',
   4, 'prompt dba min <file#> . <block#>',
   5, 'prompt dba max <file#> . <block#>',
   6, 'prompt time min <redotime>',
   7, 'prompt time max <redotime>',
   8, 'prompt layer <layer#>',
   9, 'prompt opcode <opcode#>',
  11, '@accept Options "Options" ""',
  'prompt'
  )
from
  sys.v_$mystat
where
  '&Options' = '?' and
  rownum <= 11
/
spool off

@restore_sqlplus_settings
@dump_logfile.tmp

set termout off
host rm -f dump_logfile.tmp	-- for Unix
host del dump_logfile.tmp	-- for others

alter session set max_dump_file_size = unlimited
/
set termout on
set feedback on
set verify off

prompt
prompt alter system dump logfile '&Path' &Options
alter system dump logfile '&Path' &Options;

undefine Path
undefine Options

@restore_sqlplus_settings
