-------------------------------------------------------------------------------
--
-- Script:	log_block_size.sql
-- Purpose:	to find the platform specific log block size
-- For:		8.0 and 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  max(l.lebsz)  log_block_size
from
  sys.x_$kccle  l
where
  l.inst_id = userenv('Instance')
/

@restore_sqlplus_settings
