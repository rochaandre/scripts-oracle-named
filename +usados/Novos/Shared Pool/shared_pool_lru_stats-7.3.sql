-------------------------------------------------------------------------------
--
-- Script:	shared_pool_lru_stats.sql
-- Purpose:	to check the shared pool lru stats
-- For:		up to 7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column kghlurcr heading "RECURRENT|CHUNKS"
column kghlutrn heading "TRANSIENT|CHUNKS"
column kghlufsh heading "FLUSHED|CHUNKS"
column kghluops heading "PINS AND|RELEASES"
column kghlunfu heading "ORA-4031|ERRORS"
column kghlunfs heading "LAST ERROR|SIZE"

select
  kghlurcr,
  kghlutrn,
  kghlufsh,
  kghluops,
  kghlunfu,
  kghlunfs
from
  sys.x_$kghlu
/

@restore_sqlplus_settings
