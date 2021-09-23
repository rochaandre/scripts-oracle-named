-------------------------------------------------------------------------------
--
-- Script:	instance_variables.sql
-- Purpose:	to list the values of the instance variables
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column variable format a8
column description format a53
break on struct

select
  'X$KVII' struct,
  kviitag  variable,
  kviidsc  description,
  kviival  value
from
  sys.x_$kvii
union all
select
  'X$KVIT',
  kvittag,
  kvitdsc,
  kvitval
from
  sys.x_$kvit
union all
select
  'X$KVIS',
  kvistag,
  kvisdsc,
  kvisval
from
  sys.x_$kvis
/

@restore_sqlplus_settings
