-------------------------------------------------------------------------------
--
-- Script:	dd_initial_extents.sql
-- Purpose:	to get initial extent sizes for dd segments when rebuilding
-- For:		7.3 to 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column segment_name format a30
column suggest1 format a17 heading "SUGGESTED INITIAL"
column suggest2 format a14 heading "SUGGESTED NEXT"

select
  s.segment_name,
  s.bytes / 1024 || 'K'  suggest1,
  ceil(s.bytes / (10 * p.value)) * (p.value / 1024) || 'K'  suggest2
from
  sys.dba_segments  s,
  sys.v_$parameter  p
where
  s.tablespace_name = 'SYSTEM' and
  s.extents > 1 and
  s.segment_name != 'SYSTEM' and
  p.name = 'db_block_size'
/

@restore_sqlplus_settings
