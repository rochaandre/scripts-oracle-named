-------------------------------------------------------------------------------
--
-- Script:	cached_blocks.sql
-- Purpose:	to the number of blocks cached for each segment
-- For:		8.0
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column segment_name format a40

select
  e.owner||'.'||e.segment_name  segment_name,
  sum(cur)  cur_buffers,
  sum(cr)  cr_buffers
from
  ( select
      min(file#||'.'||dbablk)  fb,
      sum(decode(state, 1, 1, 0))  cur,
      sum(decode(state, 3, 1, 0))  cr
    from
      sys.x_$bh
    where
      inst_id = userenv('Instance') and
      state in (1, 3)
    group by
      obj,
      class
  )  b,
  sys.apt_extents  e
where
  e.file_id = substr(b.fb, 1, instr(b.fb, '.') - 1) and
  substr(b.fb, instr(b.fb, '.') + 1) between e.block_id and e.block_id + e.blocks - 1
group by
  e.owner||'.'||e.segment_name
order by
  2
/

@restore_sqlplus_settings
