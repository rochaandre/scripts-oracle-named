-------------------------------------------------------------------------------
--
-- Script:	reserved_pool_summary.sql
-- Purpose:	to get an overview of chunks in the reserved pool
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  ksmchcom  contents,
  count(*)  chunks,
  sum(decode(ksmchcls, 'R-recr', ksmchsiz))  recreatable,
  sum(decode(ksmchcls, 'R-freea', ksmchsiz))  freeable,
  sum(ksmchsiz)  total
from
  sys.x_$ksmspr
group by
  ksmchcom
/

@restore_sqlplus_settings
