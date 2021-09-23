-------------------------------------------------------------------------------
--
-- Script:	row_migration.sql
-- Purpose:	to find the degree of row migration in analyzed tables
-- For:		7.3 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Note:	! THIS SCRIPT IS ONLY AS GOOD AS YOUR OPTIMIZER STATISTICS !
--
-- Description:	This reports the degree of row migration as a percentage of
--		the number of rows. Tables with LONGs or possible row lengths
--		greater than the block size are ignored, as it is not easy
--		to distinguish row migration from chaining for such tables.
--
--		The new PCTFREE is calculated as the free space left by one
--		less than the number of average rows that can fit in a block.
--
--		The new PCTUSED allows for a little more than one row between
--		PCTFREE and PCTUSED - this may not be enough for tables with
--		very high insert and delete activity.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column table_name format a37
column mrows format 9999999 heading "MIGRATED|ROWS"
column migration heading "DEGREE OF|MIGRATION"
column new_free format 99 heading "SUGGEST|PCTFREE"
column new_used format 99 heading "SUGGEST|PCTUSED"
column minimize format 999999 heading "SUGGEST|MAXROWS"

select
  u.name ||'.'|| o.name  table_name,
  t.chncnt mrows,
  to_char(100 * t.chncnt / t.rowcnt, '9999.00') || '%'  migration,
  1 + greatest(
    t.pctfree$,
    ceil(
      ( 100 * ( p.value - 66 - t.initrans * 24 -
            greatest(
              floor(
                (p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11)
              ) - 1,
              1
            ) * greatest(t.avgrln + 2, 11)
        )
        /
        (p.value - 66 - t.initrans * 24)
      )
    )
  )  new_free,
  98 - greatest(
    t.pctfree$,
    ceil(
      ( 100 * ( p.value - 66 - t.initrans * 24 -
            greatest(
              floor(
                (p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11)
              ) - 2,
              1
            ) * greatest(t.avgrln + 2, 11)
        )
        /
        (p.value - 66 - t.initrans * 24)
      )
    )
  )  new_used,
  floor((p.value - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11))  minimize
from
  sys.tab$  t,
  ( select
      obj#,
      sum(length)  max_row
    from
      sys.col$
    group by
      obj#
    having
      min(length) > 0		-- don't worry about tables with LONGs
  )  c,
  ( select
      kvisval  value
    from
      sys.x_$kvis
    where
      kvistag = 'kcbbkl'
  )  p,
  sys.obj$  o,
  sys.user$  u
where
  t.tab# is null and
  t.chncnt > 0 and
  t.rowcnt > 0 and
  c.obj# = t.obj# and
  c.max_row < p.value - (71 + t.initrans * 24) and
  o.obj# = t.obj# and
  o.owner# != 0 and
  u.user# = o.owner#
order by
  2 desc
/

@restore_sqlplus_settings
