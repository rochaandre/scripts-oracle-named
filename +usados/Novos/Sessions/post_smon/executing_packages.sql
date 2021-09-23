-------------------------------------------------------------------------------
--
-- Script:	executing_packages.sql
-- Purpose:	to list the sessions that are currently executing stored code
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column type format a9
column owner format a25
column name format a30
column sid format 9999
column serial format 999999

select
  decode(o.kglobtyp,
    7, 'PROCEDURE',
    8, 'FUNCTION',
    9, 'PACKAGE',
    12, 'TRIGGER',
    13, 'CLASS'
  )  "TYPE",
  o.kglnaown  "OWNER",
  o.kglnaobj  "NAME",
  s.indx  "SID",
  s.ksuseser  "SERIAL"
from
  sys.x_$kglob  o,
  sys.x_$kglpn  p,
  sys.x_$ksuse  s
where
  o.inst_id = userenv('Instance') and
  p.inst_id = userenv('Instance') and
  s.inst_id = userenv('Instance') and
  o.kglhdpmd = 2 and
  o.kglobtyp in (7, 8, 9, 12, 13) and
  p.kglpnhdl = o.kglhdadr and
  s.addr = p.kglpnses
order by 1, 2, 3
/

@restore_sqlplus_settings
