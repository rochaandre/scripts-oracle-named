-------------------------------------------------------------------------------
--
-- Script:	all_parameters.sql
-- Purpose:	to show all parameter values (including hidden ones)
-- For:		8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set linesize 132

column name format a42
column value format a64

select
  x.ksppinm  name,
  y.kspftctxvl  value,
  y.kspftctxdf  isdefault,
  decode(bitand(y.kspftctxvf,7),1,'MODIFIED',4,'SYSTEM_MOD','FALSE')  ismod,
  decode(bitand(y.kspftctxvf,2),2,'TRUE','FALSE')  isadj
from
  sys.x_$ksppi  x,
  sys.x_$ksppcv2  y
where
  x.inst_id = userenv('Instance') and
  y.inst_id = userenv('Instance') and
  x.indx+1 = y.kspftctxpn
order by
  translate(x.ksppinm, ' _', ' ')
/

@restore_sqlplus_settings
