-------------------------------------------------------------------------------
--
-- Script:	lock_element_lwm.sql
-- Purpose:	to find the low-water mark of the lock element free list
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

select
  l.inst_id, l.lwm
from
  sys.x_$kclfx  l
/

@restore_sqlplus_settings
