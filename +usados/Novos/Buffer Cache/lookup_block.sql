-------------------------------------------------------------------------------
--
-- Script:	lookup_block.sql
-- Purpose:	to find out which object a particular block belongs
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept FileNo "File Number" 1
@accept BlockNo "Block Number" 2

column segment_name format a40

select /*+ ordered */
  e.owner ||'.'|| e.segment_name  segment_name,
  e.extent_id  extent#,
  &BlockNo - e.block_id + 1  block#
from
  sys.dba_extents  e
where
  e.file_id = &FileNo and
  &BlockNo between e.block_id and e.block_id + e.blocks - 1
/

undefine BlockNo
undefine FileNo
@restore_sqlplus_settings
