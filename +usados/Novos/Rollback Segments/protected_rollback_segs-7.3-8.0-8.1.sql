-------------------------------------------------------------------------------
--
-- Script:	protected_rollback_segs.sql
-- Purpose:	to prevent extent reuse in a rollback segment for a period
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	This script may be used to monitor rollback segment status
--		when a critical report or program has been protected from
--		ORA-1555 errors using the prevent_1555.sql script.
--		Please see that script for more details.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  substr(d.segment_name, 1, 14)  "SEGMENT NAME",
  v.extents,
  v.rssize  bytes,
  v.optsize  "OPTIMAL",
  v.xacts  transactions,
  substr(to_char(p.protection_expires, 'HH24:MI:SS DD/MM/YY'), 1, 18)
    "PROTECTED UNTIL"
from
  sys.dba_rollback_segs  d,
  sys.v_$rollstat  v,
  system.protected_rollback_seg  p
where
  d.segment_id = v.usn and
  d.segment_name = p.segment_name (+) and
  sysdate < p.protection_expires (+)
/

@restore_sqlplus_settings
