-------------------------------------------------------------------------------
--
-- Script:	package_sql_executions.sql
-- Purpose:	to maybe get some indication of stored code usage and load 
-- For:		8.0 and higher
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This scripts sums the number of times that the SQL statements
--		used within each stored code object have been executed.
--		Of course some stored code objects do not execute any SQL 
--		directly, and the SQL statements may have been executed
--		other than from the stored code object, so the results should
--		only be regarded as indicative.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column stored_object format a61

select /*+ ordered use_hash(d) use_hash(c) */
  o.kglnaown||'.'||o.kglnaobj  stored_object,
  sum(c.kglhdexc)  sql_executions
from
  sys.x_$kglob  o,
  sys.x_$kglrd  d,
  sys.x_$kglcursor  c
where
  o.inst_id = userenv('Instance') and
  d.inst_id = userenv('Instance') and
  c.inst_id = userenv('Instance') and
  o.kglobtyp in (7, 8, 9, 11, 12) and
  d.kglhdcdr = o.kglhdadr and
  c.kglhdpar = d.kglrdhdl
group by
  o.kglnaown,
  o.kglnaobj
/

@restore_sqlplus_settings
