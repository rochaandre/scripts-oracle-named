-------------------------------------------------------------------------------
--
-- Script:	version_count.sql
-- Purpose:	to check for high version counts
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column version_count format a20

select
  to_char(min(v)) ||
  decode(
    max(v) - min(v),
    0, null,
    ' to ' || to_char(max(v))
  )  version_count,
  count(*)  cursors
from
  (
    select
      count(*)  v
    from
      sys.x_$kglcursor
    where
      kglhdadr != kglhdpar
    group by
      kglhdpar,
      kglnahsh
  )
group by
  trunc(round(log(2, v), 37))
/

@restore_sqlplus_settings
