-------------------------------------------------------------------------------
--
-- Script:	create_v$my_event.sql
-- Purpose:	to create a view to select the current sessions wait events
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings
set feedback on

create or replace view sys.v_$my_event as
select * from v$session_event where sid = (select /*+ no_merge */ sid from sys.v_$mystat where rownum = 1)
/
set termout off
drop public synonym v$my_event
/
set termout on
create public synonym v$my_event for sys.v_$my_event
/
set termout off
@as sys 'grant select on v_$my_event to public'

@restore_sqlplus_settings
