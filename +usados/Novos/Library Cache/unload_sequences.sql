-------------------------------------------------------------------------------
--
-- Script:	unload_sequences.sql
-- Purpose:	to unload cached sequence numbers from the shared pool
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set pagesize 0
set termout off
set echo off

spool unload_sequences.tmp
prompt set echo on
select
  'alter sequence ' || sequence_owner || '.' || sequence_name || ' nocache;'
from
  sys.dba_sequences
where
  cache_size > 0
/
select
  'alter sequence ' || sequence_owner || '.' || sequence_name || ' cache ' ||
  cache_size || ';'
from
  sys.dba_sequences
where
  cache_size > 0
/
spool off

@restore_sqlplus_settings
@unload_sequences.tmp

set termout off
host rm -f unload_sequences.tmp	-- for Unix
host del unload_sequences.tmp	-- for others

@restore_sqlplus_settings
