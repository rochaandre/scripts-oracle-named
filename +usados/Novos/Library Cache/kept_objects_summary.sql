-------------------------------------------------------------------------------
--
-- Script:	kept_objects_summary.sql
-- Purpose:	to report how many objects of each type are kept
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  type,
  count(*)  objects,
  sum(decode(kept, 'YES', 1, 0))  kept,
  sum(loads) - count(*)  reloads,
  count(distinct owner)  owners
from
  sys.v_$db_object_cache
where
  type != 'NOT LOADED'
group by
  type
order by
  2 desc
/

@restore_sqlplus_settings
