-------------------------------------------------------------------------------
--
-- Script:	shared_pool_free_lists.sql
-- Purpose:	to check the length of the shared pool free lists
-- For:		8.0 and 8.1.5
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Warning:	This script queries x$ksmsp which causes it to take the
--		shared pool latch for a fairly long time.
--		Think twice before running this script on a large system
--		with potential shared pool problems -- you may make it worse.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  decode(sign(ksmchsiz - 80), -1, 0, trunc(1/log(ksmchsiz - 15, 2)) - 5)
    bucket,
  sum(ksmchsiz)  free_space,
  count(*)  free_chunks,
  trunc(avg(ksmchsiz))  average_size,
  max(ksmchsiz)  biggest
from
  sys.x_$ksmsp
where
  inst_id = userenv('Instance') and
  ksmchcls = 'free'
group by
  decode(sign(ksmchsiz - 80), -1, 0, trunc(1/log(ksmchsiz - 15, 2)) - 5)
/

@restore_sqlplus_settings
