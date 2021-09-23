-------------------------------------------------------------------------------
--
-- Script:	latch_where.sql
-- Purpose:	shows the distribution of latch sleeps by code locations
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set recsep off
column name format a30 heading "LATCH TYPE"
column location format a40 heading "CODE LOCATION and [LABEL]"
column kslsleep format 999999 heading "SLEEPS"
break on name

select
  l.name,
  rpad(lw.ksllwnam, 40) ||
  decode(lw.ksllwlbl, null, null, '[' || lw.ksllwlbl || ']') location,
  wsc.kslsleep
from
  sys.x_$kslwsc wsc,
  sys.x_$ksllw lw,
  sys.v_$latch  l
where
  wsc.kslsleep > 0 and
  lw.indx = wsc.indx and
  l.name = wsc.ksllasnam
order by
  l.sleeps desc,
  wsc.kslsleep desc
/

@restore_sqlplus_settings
