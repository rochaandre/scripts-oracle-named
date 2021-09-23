-------------------------------------------------------------------------------
--
-- Script:	all_parameters.sql
-- Purpose:	to show all parameter values (including hidden ones)
-- For:		7.3
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
  y.ksppstvl  value,
  y.ksppstdf  isdefault,
  decode(bitand(y.ksppstvf,7),1,'MODIFIED',4,'SYSTEM_MOD','FALSE')  ismod, 
  decode(bitand(y.ksppstvf,2),2,'TRUE','FALSE')  isadj 
from 
  sys.x_$ksppi x, 
  sys.x_$ksppcv y 
where 
  x.indx = y.indx 
order by
  translate(x.ksppinm, ' _', ' ')
/

@restore_sqlplus_settings
