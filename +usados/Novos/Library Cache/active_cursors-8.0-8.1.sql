-------------------------------------------------------------------------------
--
-- Script:	active_cursors.sql
-- Purpose:	to show all active cursor for each session
-- For:		8.0 and 8.1
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Description: This script is needed to associate top level cursors, such as
--		anonymous PL/SQL blocks with the sessions executing them.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column sid format 999
column sql_text format a75 word_wrapped

select
  s.sid,
  c.kglnaobj  sql_text
from
  sys.x_$kglpn  p,
  sys.x_$kglcursor  c,
  sys.v_$session  s
where
  p.inst_id = userenv('Instance') and
  c.inst_id = userenv('Instance') and
  p.kglpnhdl = c.kglhdadr and
  c.kglhdadr != c.kglhdpar and
  p.kglpnses = s.saddr
order by
  s.sid
/

@restore_sqlplus_settings
