-------------------------------------------------------------------------------
--
-- Script:	whence_invalidations.sql
-- Purpose:	to trace cursor invalidations to the changed dependencies
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@restore_sqlplus_settings

column object_owner format a12
column object_name format a25

select /*+ ordered use_hash(d) use_hash(o) */
  o.kglnaown  object_owner,
  o.kglnaobj  object_name,
  sum(o.kglhdldc - decode(o.kglhdobj, hextoraw('00'), 0, 1))  unloads,
  sum(decode(bad_deps, 1, invalids, 0))  invalidations,
  sum(decode(bad_deps, 1, 0, invalids))  and_maybe
from
  (
    select /*+ ordered use_hash(d) use_hash(o) */
      c.kglhdadr,
      sum(c.kglhdivc)  invalids,
      count(*)  bad_deps
    from
      sys.x_$kglcursor  c,
      sys.x_$kgldp  d,
      sys.x_$kglob  o
    where
      c.inst_id = userenv('Instance') and
      d.inst_id = userenv('Instance') and
      o.inst_id = userenv('Instance') and
      c.kglhdivc > 0 and
      d.kglhdadr = c.kglhdadr and
      o.kglhdadr = d.kglrfhdl and
      o.kglhdnsp = 1 and
      (
        o.kglhdldc > 1 or
        o.kglhdobj = hextoraw('00')
      )
    group by
      c.kglhdadr
  )  c,
  sys.x_$kgldp  d,
  sys.x_$kglob  o
where
  d.inst_id = userenv('Instance') and
  o.inst_id = userenv('Instance') and
  d.kglhdadr = c.kglhdadr and
  o.kglhdadr = d.kglrfhdl and
  o.kglhdnsp = 1 and
  (
    o.kglhdldc > 1 or
    o.kglhdobj = hextoraw('00')
  )
group by
  o.kglnaown,
  o.kglnaobj
order by
  sum(invalids / bad_deps)
/

@restore_sqlplus_settings
