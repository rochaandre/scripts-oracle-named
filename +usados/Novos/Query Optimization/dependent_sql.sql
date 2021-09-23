-------------------------------------------------------------------------------
--
-- Script:	dependent_sql.sql
-- Purpose:	to find the SQL dependent on a particular object
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

accept OwnerName prompt "Owner Name: "
accept TableName prompt "Table Name: "

column sql_text format a58 word_wrapped

select /*+ ordered use_hash(d) use_hash(c) */
  sum(c.kglobt13)  disk_reads,
  sum(c.kglhdexc)  executions,
  c.kglnaobj  sql_text
from
  sys.x_$kglob  o,
  sys.x_$kgldp  d,
  sys.x_$kglcursor  c
where
  o.inst_id = userenv('Instance') and
  d.inst_id = userenv('Instance') and
  c.inst_id = userenv('Instance') and
  o.kglnaown = upper('&OwnerName') and
  o.kglnaobj = upper('&TableName') and
  d.kglrfhdl = o.kglhdadr and
  c.kglhdadr = d.kglhdadr
group by
  c.kglnaobj
order by
  1 desc
/

@restore_sqlplus_settings
