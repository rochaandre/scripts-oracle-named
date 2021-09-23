-------------------------------------------------------------------------------
--
-- Script:	archival_headroom.sql
-- Purpose:	to show how much headroom the tightest archival has had
-- For:		8.0 and later
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	Compares the time taken for each archival with the time to the
--		log switch that reused the file and reports the least headroom.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  substr(to_char(100 * headroom, '999999999.0'), 2) || '%'  min_headroom,
  round(arch_time * 24 * 60, 2)  archival_minutes,
  round(arch_window * 24 * 60, 2)  archival_window
from
  ( select
      b.next_time - a.next_time        arch_window,
      a.completion_time - a.next_time  arch_time,
      (b.next_time - a.next_time) / (a.completion_time - a.next_time) - 1
        headroom
    from
      sys.v_$thread  t,
      sys.v_$archived_log  a,
      sys.v_$archived_log  b
    where
      a.completion_time > a.next_time and
      b.sequence# = a.sequence# + t.groups - 1
    order by
      3
  )
where
  rownum = 1
/

@restore_sqlplus_settings
