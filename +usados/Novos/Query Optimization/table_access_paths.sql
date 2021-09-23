--------------------------------------------------------------------------------
--
-- Script:	table_access_paths.sql
-- Purpose:	to consider table access paths when tuning a problem query
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
--------------------------------------------------------------------------------
@save_sqlplus_settings
set pagesize 1001

--------------------------------------------------------------------------------
-- get the owner and table names
--
-- first find the table responsible for the most disk reads as the default
-- we also need to get the block size, and the freelists limit
--
set termout off

column owner_name new_value OwnerName
column table_name new_value TableName

select
  owner_name,
  table_name  
from
  (
    select /*+ ordered use_hash(d) use_hash(c) */
      o.kglnaown  owner_name,
      o.kglnaobj  table_name
    from
      sys.x_$kglob  o,
      sys.x_$kgldp  d,
      sys.x_$kglcursor  c
    where
      c.inst_id = userenv('Instance') and
      d.inst_id = userenv('Instance') and
      o.inst_id = userenv('Instance') and
      o.kglhdnsp = 1 and			-- table/procedure namespace
      o.kglobtyp = 2 and			-- tables
      o.kglnaown != 'SYS' and 
      d.kglrfhdl = o.kglhdadr and
      c.kglhdadr = d.kglhdadr
    group by
      o.kglnaown,
      o.kglnaobj
    order by
      sum(c.kglobt13) desc			-- disk reads
  )
where
  rownum = 1
/

column value new_value BlkSz
column maxfl new_value MaxFL

select
  value,
  decode(value, 2048, 19, 4096, 47, 97)  maxfl
from
  sys.v_$parameter
where
  name = 'db_block_size'
/

clear columns

set termout on

@accept OwnerName "Owner Name" &OwnerName
@accept TableName "Table Name" &TableName

--------------------------------------------------------------------------------
-- show the number of rows and average row length
--
-- this query also joins to SEG$ and V$BUFFER_POOL to get values needed later
--
prompt
prompt -
************************************ TABLE *************************************
					
column table_storage format a29
column statistics    format a30
column num_rows      format a8

column iotbit     new_value IotBit       noprint
column cachebit   new_value CacheBit     noprint
column blockspace new_value BlockSpace   noprint
column rowspace   new_value RowSpace     noprint
column rpb        new_value RowsPerBlock noprint
column obj#       new_value ObjNo        noprint
column dataobj#   new_value DataObjNo    noprint
column groups     new_value FlGroups     noprint
column lists      new_value FreeLists    noprint
column pool       new_value Pool         noprint
column realpool   new_value RealPool     noprint
column buffers    new_value PoolSize     noprint
column max_row    new_value MaxRow       noprint

select /*+ ordered */
  decode(bitand(t.property, 32), 32, 'PARTITIONED ') ||
  decode(
    bitand(t.property, 64),
    64,
    decode(t.bobj#, null, 'IOT', 'IOT with OVERFLOW'),
    decode(t.tab#, null, 'HEAP', 'CLUSTERED')
  )  table_storage,
  to_char(trunc(24 * (sysdate - t.analyzetime))) || ' hours old'  statistics,
  apt_format(t.rowcnt, '9999999k')  num_rows,
  t.avgrln  row_length,
  decode(bitand(t.property, 64), 64, 'YES', 'NO')  iotbit,
  decode(bitand(t.flags, 8), 8, 'YES', 'NO')  cachebit,
  nvl(&BlkSz - 66 - 24 * t.initrans, 0)  blockspace,
  nvl(greatest(t.avgrln + 2, 11), 0)  rowspace,
  nvl(floor((&BlkSz - 66 - t.initrans * 24) / greatest(t.avgrln + 2, 11)), 1)
    rpb,
  o.obj#,
  o.dataobj#,
  nvl(s.groups, 0)  groups,
  nvl(s.lists, 1)  lists,
  decode(p1.buffers, 0, '! ') ||		-- prepend ! if the desired pool
    p1.name  pool,				--   is not configured
  p2.name  realpool,
  nvl(p2.buffers, 1)  buffers,
  ( select
      decode(min(length), 0, 0, sum(length))	-- 0 if any LONG columns
    from
      sys.col$
    where
      obj# = t.obj#
  )  max_row
from
  sys.user$  u,
  sys.obj$  o,
  sys.tab$  t,
  sys.seg$  s,
  sys.v_$buffer_pool  p1,
  sys.v_$buffer_pool  p2
where
  u.name = upper('&OwnerName') and
  o.owner# = u.user# and
  o.name = upper('&TableName') and
  t.obj# = o.obj# and
  s.ts# (+) = t.ts# and
  s.file# (+) = t.file# and
  s.block# (+) = t.block# and
  p1.name (+) = decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE') and
  p2.name (+) = decode(p1.buffers, 0, 'DEFAULT', p1.name)
/

--------------------------------------------------------------------------------
-- for heap tables, show the data denisty and suggest storage parameter changes
--
column data_size     format a9
column hwm_size      format a10 justify right
column data_density  format a12
column row_migration format a13
column pct_free      format a10 justify right
column pct_used      format a10 justify right
column free_lists    format a10

select
  apt_format(
    (1 + &FlGroups + ceil(t.rowcnt / &RowsPerBlock)) * &BlkSz,
    '99999999K'
  )  data_size,
  apt_format((1 + &FlGroups + t.blkcnt) * &BlkSz, '999999999K')  hwm_size,
  apt_format(t.rowcnt / &RowsPerBlock / t.blkcnt, '99999999999%')
    data_density,
  decode(
    t.chncnt,
    0,
    '          nil',
    apt_format(t.chncnt / t.rowcnt, '999999999999%')
  )  row_migration,
  to_char(t.pctfree$, '999') ||
    ' ->'||
    decode(
      t.chncnt * decode(sign(&MaxRow - &RowSpace), 1, 0, &MaxRow),
      0,
      to_char(ceil(100 * &RowSpace / &BlockSpace), '99'),
      greatest(
        least(100, t.pctfree$ + 1),
        to_char(ceil(100 * &RowSpace / &BlockSpace), '99')
      )
    )  pct_free,
  to_char(t.pctused$, '999') ||
    ' ->'||
    to_char(100 - 2 * ceil(100 * &RowSpace / &BlockSpace), '99')  pct_used,
  to_char(decode(&FreeLists, 0, 1, &FreeLists), '999') ||
    ' ->'||
    to_char(
      least(
        &MaxFL,
        next_prime(
          floor(
            (
              &BlkSz - 66 - t.avgspc -
              greatest(t.avgrln + 1.5, 11) * t.rowcnt / t.blkcnt
            ) /
            24
          )
        )
      ),
      '99'
    )  free_lists
from
  sys.tab$  t
where
  t.obj# = &ObjNo and
  t.tab# is null and
  '&IotBit' = 'NO' and
  t.rowcnt is not null
/

--------------------------------------------------------------------------------
-- for clustered tables, show cluster name, type and data density statistics
--
-- first we need to know the number of clustered tables, and their total size
--
set termout off

column clu_tabs new_value Tables
column clu_size new_value CluSize
define CluSize = 1
define Tables  = 1

select
  count(*)  clu_tabs,
  sum(greatest(t2.avgrln + 2, 11) * (t2.rowcnt + t2.blkcnt)) +
    t1.blkcnt * (66 + 24 * c.initrans + 4 * count(*))  clu_size
from
  sys.tab$  t1,
  sys.tab$  t2,
  sys.clu$  c
where
  t1.obj# = &ObjNo and
  c.obj# = t1.bobj# and
  t2.bobj# = c.obj#
group by
  t1.blkcnt,
  c.initrans
/

clear columns

set termout on

column cluster_name format a29
column hwm_size     format a8
column data_size    format a9
column table_size   format a10
column density      format a7
column ctype        heading " TYPE"

column cachebit     new_value CacheBit     noprint
column kpb          new_value KeysPerBlock noprint
define KeysPerBlock = 1

select
  o.name  cluster_name,
  lpad(decode(bitand(c.flags, 65536), 65536, 'SINGLE', &Tables), 6)  tables,
  decode(c.hashkeys, 0, 'INDEX', ' HASH')  ctype,
  apt_format((1 + &FlGroups + t.blkcnt) * &BlkSz, '9999999K')  hwm_size,
  apt_format(
    decode(
      &Tables,
      1,
      (1 + &FlGroups + ceil(t.rowcnt / &RowsPerBlock)) * &BlkSz,
      &CluSize
    ),
    '99999999K'
  )  data_size,
  apt_format(
    (1 + &FlGroups + ceil(t.rowcnt / &RowsPerBlock)) * &BlkSz,
    '999999999K'
  )  table_size,
  apt_format(t.rowcnt / &RowsPerBlock / t.blkcnt, '999999%')  density,
  decode(bitand(c.flags, 8), 8, 'YES', 'NO')  cachebit,
  nvl(greatest(floor((&BlkSz - 66 - 24 * c.initrans) / c.size$), 1), 1)  kpb
from
  sys.tab$  t,
  sys.obj$  o,
  sys.clu$  c
where
  t.obj# = &ObjNo and
  o.obj# = t.bobj# and
  c.obj# = t.bobj#
/

--------------------------------------------------------------------------------
-- for clustered tables, also identify possible block chaining problems
--
-- the first query is for hash clusters; the second is for index clusters
--
column hashkeys         format 9999999
column bytes_per_key    format a13
column rebuild_hashkeys format 999999999999999

select
  c.hashkeys,
  lpad(nvl(to_char(c.size$), 'null'), 13)  bytes_per_key,
  &KeysPerBlock  keys_per_block,
  ceil(c.hashkeys / &KeysPerBlock)  key_blocks,
  t.blkcnt - ceil(c.hashkeys / &KeysPerBlock)  chained_blocks,
  next_prime(t.blkcnt * &KeysPerBlock)  rebuild_hashkeys
from
  sys.tab$  t,
  sys.clu$  c
where
  t.obj# = &ObjNo and
  c.obj# = t.bobj# and
  c.hashkeys > 0 and
  t.blkcnt > ceil(c.hashkeys / &KeysPerBlock)
/

select
  i.distkey cluster_keys,
  lpad(nvl(to_char(c.size$), 'null'), 13)  bytes_per_key,
  &KeysPerBlock  keys_per_block,
  ceil(i.distkey / &KeysPerBlock)  key_blocks,
  t.blkcnt - ceil(i.distkey / &KeysPerBlock)  chained_blocks,
  ceil((&BlkSz - 66 - 24 * c.initrans - 4 * &Tables) /
    (i.distkey/t.blkcnt))  rebuild_size
from
  sys.tab$  t,
  sys.clu$  c,
  sys.ind$  i
where
  t.obj# = &ObjNo and
  c.obj# = t.bobj# and
  c.hashkeys = 0 and
  i.bo# = c.obj# and
  t.blkcnt > ceil(i.distkey / &KeysPerBlock)
/

--------------------------------------------------------------------------------
-- now some information about the caching of the segment
--
-- first we count the currently cached blocks
-- we also need some parameters to say how multiblock reads will be treated
--
set termout off

column cached_blocks new_value CachedBlocks
define CachedBlocks = 0

select
  count(distinct file# ||'.'|| dbablk)  cached_blocks
from
  sys.x_$bh
where
  obj = &DataObjNo
/

column kspftctxvl new_value Parameter
define Parameter = 1

select
  y.kspftctxvl
from
  sys.x_$ksppi  x,
  sys.x_$ksppcv2  y
where
  x.inst_id = userenv('Instance') and
  y.inst_id = userenv('Instance') and
  x.indx+1 = y.kspftctxpn and
  (
    (
      '&RealPool' = 'KEEP' and
      x.ksppinm = '_db_percent_hot_keep'
    )
  or
    (
      '&RealPool' = 'DEFAULT' and
      '&CacheBit' = 'YES' and
      x.ksppinm = '_db_percent_hot_default'
    )
  or
    (
      '&RealPool' = 'RECYCLE' and
      '&CacheBit' = 'YES' and
      x.ksppinm = '_db_percent_hot_recycle'
    )
  or
    (
      '&RealPool' != 'KEEP' and
      '&CacheBit' = 'NO' and
      x.ksppinm = '_small_table_threshold'
    )
  )
/

clear columns

set termout on

column blocks           format a8 justify right
column buffer_pool      format a11
column pool_size        format a9
column cache            format a5
column parallel_degree  format a15
column full_table_scans format a16

select
  apt_format(t.blkcnt, '9999999k')  blocks,
  lpad('&Pool', 11)  buffer_pool,
  apt_format(&PoolSize, '999999999')  pool_size,
  lpad('&CacheBit', 5)  cache,
  lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree, 1)), 15)
    parallel_degree,
  decode(
    nvl(t.degree, 1),
    1,
    decode(
      '&RealPool',
      'KEEP',		    -- KEEP => up to complement of _db_percent_hot_keep
      decode(
        sign(t.blkcnt - &PoolSize * (1 - &Parameter / 100)),
        1,
        '   PARTLY CACHED',
        '   BLOCKS CACHED'
      ),
      decode('&CacheBit',
        'YES',		    -- CACHE => up to complement of _db_percent_hot_*
        decode(
          sign(t.blkcnt - &PoolSize * (1 - &Parameter / 100)),
          1,
          '   PARTLY CACHED',
          '   BLOCKS CACHED'
        ),
        decode(		    -- otherwise, up to _small_table_threshold
          sign(t.blkcnt - &Parameter),
          1,
          '   BLOCKS REUSED',
          decode(	    -- unless that is bigger than the buffer pool
            sign(t.blkcnt - &PoolSize),
            1,
            '   PARTLY CACHED',
            '   BLOCKS CACHED'
          )
        )
      )
    ),
    '   DIRECT READS'
  )  full_table_scans,
  &CachedBlocks  cached_now
from
  sys.tab$  t
where
  t.obj# = &ObjNo and
  '&IotBit' = 'NO'
/

--------------------------------------------------------------------------------
-- for each column, show the percentage of nulls (or absolute number if small),
-- the selectivity of equality predicates, and the possible access paths
--
prompt
prompt
prompt -
*********************************** COLUMNS ************************************

column nulls        format a7 justify right
column selectivity  format a11
column bytes        format 9999
column access_paths format a29 justify right

select
  column_name,
  decode(
    sign(null_cnt - few_rows),
    null,
    null,
    -1,
    lpad(rtrim(to_char(null_cnt, 'FM99B')) ||
      decode(null_cnt, 0, '', 1, '  row', ' rows'), 7),
    apt_format(null_pct, '999999%')
  )  nulls,
  decode(
    sign(rows_per_key - few_rows),
    null,
    null,
    -1,
    lpad(to_char(rows_per_key, '999') ||
      decode(rows_per_key, 1, '  row', ' rows'), 11),
    apt_format(pct_per_key, '9999999999%')
  )  selectivity,
  lpad(
    nvl(
      rtrim(
        decode(hash_key, null, null, hash_key || ', ') ||
        decode(cluster_key, null, null, cluster_key || ', ') ||
        decode(index_key, null, null, index_key),
        ', '
      ),
      'full scan'
    ),
    29
  )  access_paths
from
  ( select
      least(100, greatest(t.rowcnt/100, 10))  few_rows,
      tc.name  column_name,
      h.null_cnt,
      decode(t.rowcnt, 0, null, h.null_cnt / t.rowcnt)  null_pct,
      decode(h.distcnt, 0, null, ceil((t.rowcnt - h.null_cnt) / h.distcnt))
        rows_per_key,
      decode(
        h.distcnt * t.rowcnt,
        0, null,
        (t.rowcnt - h.null_cnt) / h.distcnt / t.rowcnt
      )  pct_per_key,
      ( select
          decode(
            count(*),
            1,
            decode(max(c.cols), 1, 'HASH KEY', 'part of hash key')
          )
        from
          sys.clu$  c,
          sys.col$  cc
        where
          c.obj# = t.bobj# and
          c.hashkeys > 0 and
          cc.obj# = c.obj# and
          cc.segcol# = tc.segcol#
      )  hash_key,
      ( select
          decode(
            count(*),
            1,
            'CLUSTER KEY' ||
              decode(
                max(c.cols),
                1,
                null,
                decode(max(ic.pos#), 1, ' - head', ' - part')
              )
          )
        from
          sys.clu$  c,
          sys.col$  cc,
          sys.icol$  ic
        where
          c.obj# = t.bobj# and
          cc.obj# = c.obj# and
          cc.segcol# = tc.segcol# and
          ic.bo# = c.obj# and
          ic.intcol# = cc.intcol#
      )  cluster_key,
      ( select
          decode(
            min(ic.pos#),
            null,
            null,
            1,
            'INDEXED',
            ltrim(to_char(to_date(min(ic.pos#), 'J'), 'Jth'), '0') ||
              ' index key'
          )
        from
          sys.icol$  ic,
          sys.ind$  i
        where
          ic.bo# = t.obj# and
          ic.intcol# = tc.intcol# and
          i.obj# = ic.obj#
      )  index_key
    from
      sys.tab$  t,
      sys.col$  tc,
      sys.hist_head$  h
    where
      t.obj# = &ObjNo and
      tc.obj# = t.obj# and
      bitand(tc.property, 32) = 0 and 		-- not a hidden column
      h.obj#(+) = tc.obj# and
      h.intcol#(+) = tc.intcol#
  )
/

--------------------------------------------------------------------------------
-- time to look at the indexes
--
prompt
prompt
prompt -
*********************************** INDEXES ************************************

set pagesize 0
set termout off

spool table_access_paths.tmp
select
  '@index_access_paths '||i.obj#
from
  sys.ind$  i
where
  i.bo# = &ObjNo
/
spool off

set termout on
set pagesize 1001
@table_access_paths.tmp

set termout off
host rm -f table_access_paths.tmp	-- for Unix
host del table_access_paths.tmp		-- for others
set termout on
@restore_sqlplus_settings

--------------------------------------------------------------------------------
--
-- To Do:	Stats on IOT overflow segments
--		Stats on cluster indexes
--		Identify storage problems on individual partitions
--		Consider reporting the datatype of the columns?
--		If bitmaps, suggest a "minimise records per block" setting
--
--------------------------------------------------------------------------------
