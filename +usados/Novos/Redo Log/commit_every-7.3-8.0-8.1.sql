-------------------------------------------------------------------------------
--
-- Script:	commit_every.sql
-- Purpose:	a packaged to commit periodically based on elapsed time
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------

create or replace package
  commit_every
as
  procedure minute;
  procedure second;
  procedure few_seconds(seconds IN number);
end;
/

create or replace package body
  commit_every
as
  last_commit pls_integer default 0;

  procedure minute
  is
  begin
    commit_every.few_seconds(60);
  end;

  procedure second
  is
  begin
    commit_every.few_seconds(1);
  end;

  procedure few_seconds(seconds IN number)
  is
    current_time pls_integer;
  begin
    current_time := sys.dbms_utility.get_time();
    if current_time - last_commit > 100 * seconds then
      if last_commit <> 0 then
        commit;
      end if;
      last_commit := current_time;
    end if;
  end;
end;
/
