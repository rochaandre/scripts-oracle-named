-------------------------------------------------------------------------------
--
-- Script:	prevent_1555_setup.sql
-- Purpose:	to setup the cluster table needed by prevent_1555.sql
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

create cluster system.prevent_1555
(
  segment_name varchar2(30)
)
  hashkeys 29
/

create table system.protected_rollback_seg
(
  segment_name		varchar2(30),
  protection_expires	date
)
  cluster system.prevent_1555(segment_name)
/

