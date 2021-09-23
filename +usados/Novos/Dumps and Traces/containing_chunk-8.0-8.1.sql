-------------------------------------------------------------------------------
--
-- Script:	containing_chunk.sql
-- Purpose:	to find the X$KSMSP chunk that contains a particular address
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set verify off

select
  x.ksmchcom  chunk_contents,
  x.ksmchcls  chunk_class,
  x.ksmchsiz  chunk_size,
  &Addr - rawtonum(x.ksmchptr)  offset_to_addr
from
  sys.x_$ksmsp  x
where
  x.inst_id = userenv('Instance') and
  &Addr >= rawtonum(x.ksmchptr) and
  &Addr <  rawtonum(x.ksmchptr) + x.ksmchsiz
/

@restore_sqlplus_settings
