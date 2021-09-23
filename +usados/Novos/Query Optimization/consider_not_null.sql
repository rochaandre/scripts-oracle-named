-------------------------------------------------------------------------------
--
-- Script:	consider_not_null.sql
-- Purpose:	find columns that maybe should be NOT NULL
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column owner		format a18
column table_name       format a30
column column_name      format a30
break on owner on table_name

select
  u.name  owner,
  o.name  table_name,
  tc.name  column_name
from
  sys.col$  tc,
  sys.hist_head$  h,
  sys.obj$  o,
  sys.user$  u
where
  tc.null$ = 0 and				-- nullable
  bitand(tc.property, 32) = 0 and 		-- not a hidden column
  h.obj# = tc.obj# and
  h.intcol# = tc.intcol# and
  h.null_cnt = 0 and				-- no nulls
  o.obj# = h.obj# and
  u.user# = o.owner#
order by 1, 2, tc.col#
/

@restore_sqlplus_settings
