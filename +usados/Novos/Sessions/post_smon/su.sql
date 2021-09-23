-------------------------------------------------------------------------------
--
-- Script:	su.sql
-- Purpose:	to connect as another user without knowing their password
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept User "User" SYS

spool su.tmp
set termout off
set echo off
set pagesize 0
set linesize 61
column line1 format a60
column line2 format a60
column line3 format a60

select
  'alter user &User identified by sesame;'  line1,
  'connect &User/sesame'  line2,
  'alter user &User identified by values ''' || password || ''';'  line3
from
  sys.dba_users
where
  username = upper('&User')
/
spool off

@restore_sqlplus_settings
set termout off
@su.tmp
host rm -f su.tmp	-- for Unix
host del su.tmp		-- for others
@set_prompt
set termout on
show user

undefine User
@restore_sqlplus_settings
