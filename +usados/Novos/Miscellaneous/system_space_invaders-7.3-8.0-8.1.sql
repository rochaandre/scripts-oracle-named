-------------------------------------------------------------------------------
--
-- Script:	system_space_invaders.sql
-- Purpose:	who has SYSTEM has their default tablespaces
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

column username heading "USER"
column guilty heading "USES SYSTEM FOR"

select
  username,
  decode(
    default_tablespace,
    'SYSTEM',
    decode(
      temporary_tablespace,
      'SYSTEM',
      'DEFAULT AND TEMPORARY TABLESPACES',
      'DEFAULT TABLESPACE'),
    'TEMPORARY TABLESPACE'
  )  guilty
from
  sys.dba_users
where
  default_tablespace = 'SYSTEM' or
  temporary_tablespace = 'SYSTEM'
/

@restore_sqlplus_settings
