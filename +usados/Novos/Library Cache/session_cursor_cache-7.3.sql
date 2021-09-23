-------------------------------------------------------------------------------
--
-- Script:	session_cursor_cache.sql
-- Purpose:	to check if the session cursor cache is constrained 
-- For:		7.3
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description:	If 'session cursor cache count' = session_cached_cursors, then
--		session_cached_cursors should be increased.
--		If 'opened cursors current' + 'session cursor cache count' =
--		open_cursors, then open_cursors should be increased.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  'session_cached_cursors'  parameter,
  lpad(value, 5)  value,
  decode(value, 0, '  n/a', to_char(100 * used / value, '990') || '%')  usage
from
  ( select
      max(s.value)  used
    from
      sys.v_$statname  n,
      sys.v_$sesstat  s
    where
      n.name = 'session cursor cache count' and
      s.statistic# = n.statistic#
  ),
  ( select
      value
    from
      sys.v_$parameter
    where
      name = 'session_cached_cursors'
  )
union all
select
  'open_cursors',
  lpad(value, 5),
  to_char(100 * used / value,  '990') || '%'
from
  ( select
      max(sum(s.value))  used
    from
      sys.v_$statname  n,
      sys.v_$sesstat  s
    where
      n.name in ('opened cursors current', 'session cursor cache count') and
      s.statistic# = n.statistic#
    group by
      s.sid
  ),
  ( select
      value
    from
      sys.v_$parameter
    where
      name = 'open_cursors'
  )
/

@restore_sqlplus_settings
