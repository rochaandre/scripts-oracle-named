-------------------------------------------------------------------------------
--
-- Script:	missing_fk_indexes.sql
-- Purpose:	to check for locking problems with missing foriegn key indexes
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column constraint_name noprint
column table_name format a48
break on constraint_name skip 1 on table_name

select /*+ ordered */
  n.name  constraint_name,
  u.name ||'.'|| o.name  table_name,
  c.name  column_name
from
  (
    select /*+ ordered */ distinct
      cd.con#,
      cc.obj#
    from
      sys.cdef$  cd,
      sys.ccol$  cc,
      sys.tab$  t
    where
      cd.type# = 4 and			-- foriegn key
      cc.con# = cd.con# and
      t.obj# = cc.obj# and
      bitand(t.flags, 6) = 0 and	-- table locks enabled
      not exists (			-- column not indexed
	select
	  null
	from
	  sys.icol$  ic,
          sys.ind$  i
	where
	  ic.bo# = cc.obj# and
	  ic.intcol# = cc.intcol# and
	  ic.pos# = cc.pos# and
          i.obj# = ic.obj# and
          bitand(i.flags, 1049) = 0	-- index must be valid
      )
  )  fk,
  sys.obj$  o,
  sys.user$  u,
  sys.ccol$  cc,
  sys.col$  c,
  sys.con$  n
where
  o.obj# = fk.obj# and
  o.owner# != 0 and			-- ignore SYS
  u.user# = o.owner# and
  cc.con# = fk.con# and
  c.obj# = cc.obj# and
  c.intcol# = cc.intcol# and
  n.con# = fk.con#
order by
  2, 1, 3
/

@restore_sqlplus_settings
