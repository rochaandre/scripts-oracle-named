-------------------------------------------------------------------------------
--
-- Script:	keep_sequences.sql
-- Purpose:	to mark all cached sequences for keeping in the pool
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@restore_sqlplus_settings
set feedback on

declare
  cursor cached_sequences is
    select
      sequence_owner,
      sequence_name
    from
      sys.dba_sequences
    where
      cache_size > 0;
  sequence_owner varchar2(30);
  sequence_name varchar2(30);
begin
  open cached_sequences;
  loop
    fetch cached_sequences into sequence_owner, sequence_name;
    exit when cached_sequences%notfound;   
    sys.dbms_shared_pool.keep(sequence_owner || '.' || sequence_name, 'Q');
  end loop;
end;   
/

@restore_sqlplus_settings
