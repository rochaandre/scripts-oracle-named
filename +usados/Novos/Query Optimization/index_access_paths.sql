--------------------------------------------------------------------------------
--
-- Script:	index_access_paths.sql
-- Purpose:	*** called from table_access_paths.sql ***
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
--------------------------------------------------------------------------------

column blocks         format a6
column density        format a7
column key_values     format a10
column entries        format a8 justify right
column table_ordering format a14

select /*+ ordered */
  o.name  index_name,
  apt_format(i.leafcnt, '99999k')  blocks,
  apt_format(
    least(
      1,
      (
	select
	  (
	    sum(
	      decode(sign(ic.pos# - nvl(i.spare2, 0)), 1, h.avgcln + 0.5, 0)
	    ) + 11
          ) * i.rowcnt +
	  (
	    sum(
	      decode(sign(nvl(i.spare2, 0) - ic.pos#), 1, h.avgcln + 0.5, 0)
	    ) + 11
	  ) * i.leafcnt
	from
	  sys.icol$  ic,
	  sys.hist_head$  h
	where
	  ic.obj# = i.obj# and
	  h.obj# (+) = ic.bo# and
	  h.intcol# (+) = ic.intcol#
      ) / (i.leafcnt * (&BlkSz - 108 - i.initrans * 24))
    ),
    '999999%'
  )  density,
  apt_format(i.distkey, '999999999k')  key_values,
  apt_format(i.rowcnt, '9999999k')  entries,
  decode(
    '&IotBit',
    'YES',
    '           n/a',
    apt_format(
      1 - (i.clufac - i.rowcnt / &RowsPerBlock + 1) /
        i.rowcnt / (1 - 1 / &RowsPerBlock),
      '9999999999999%'
    )
  )  table_ordering
from
  sys.obj$  o,
  sys.ind$  i
where
  o.obj# = &1 and
  i.obj# = o.obj#
/

column storage         format a10
column bytes           format 99999 justify right
column buckets         format 999999
column popular         format a7
column non_pop_density format a15

select
  tc.name  column_name,
  decode(sign(ic.pos# - nvl(i.spare2, 0)), 1, 'NORMAL', 'COMPRESSED')  storage,
  h.avgcln  bytes,
  h.bucket_cnt  buckets,
  decode(
    h.bucket_cnt,
    1,
    null,
    decode(
      1 + h.bucket_cnt - h.row_cnt,
      0,
      '    nil',
      apt_format((1 + h.bucket_cnt - h.row_cnt) / h.bucket_cnt, '999999%')
    )
  )  popular,
  decode(
    sign(h.density * i.rowcnt - least(100, greatest(i.rowcnt/100, 10))),
    -1,
    lpad(to_char(h.density * i.rowcnt, '999') ||
      decode(round(h.density * i.rowcnt), 1, '  row', ' rows'), 15),
    apt_format(h.density, '99999999999999%')
  )  non_pop_density	    -- this is the median selectivity, not the average
from
  sys.ind$  i,
  sys.icol$  ic,
  sys.col$  tc,
  sys.hist_head$  h
where
  i.obj# = &1 and
  ic.obj# = i.obj# and
  tc.obj# = ic.bo# and
  tc.intcol# = ic.intcol# and
  h.obj# (+) = tc.obj# and
  h.intcol# (+) = tc.intcol#
order by
  ic.pos#
/

--------------------------------------------------------------------------------
--
-- To Do:	Buffer pool and degree of index caching
--		Indexes in UNUSABLE state
--		Say if the index is partitioned and how
--		Identify storage problems on individual partitions
--		Bitmaped indexes
--		Uniqueness and potential uniqueness
--
--------------------------------------------------------------------------------
