-------------------------------------------------------------------------------
--
-- Script:	enqueue_stats.sql
-- Purpose:	to display enqueue statistics
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  q.ksqsttyp type,
  q.ksqstget gets,
  q.ksqstwat waits
from
  sys.x_$ksqst  q
where
  q.inst_id = userenv('Instance') and
  q.ksqstget > 0
/

@restore_sqlplus_settings
