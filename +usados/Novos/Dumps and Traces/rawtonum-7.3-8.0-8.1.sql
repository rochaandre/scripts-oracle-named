-------------------------------------------------------------------------------
--
-- Script:	rawtonum.sql
-- Purpose:	to convert a raw (address) to a number
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-- Note:	Unless you have an alternative local convention, persistent
--		database objects used for database administration should go
--		into the SYSTEM schema. That's what it is for.
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Owner "Schema to own the function" SYSTEM

set feedback on

create or replace function
  &Owner .rawtonum(
    raw_value in raw
  )
return number deterministic is
  hex_value  char(8);
  num_value  number := 0;
  i          number;
  n          number(2);
begin
  hex_value := rawtohex(raw_value);
  for i in 1..8 loop
    n := ascii(substr(hex_value, i, 1)) - 48;
    if n > 9 then
      n := n - 7;
    end if;
    num_value := num_value + n * power(16, 8 - i);
  end loop;
  return num_value;
end;
/
set termout off
create public synonym rawtonum for &Owner .rawtonum
/
@as &Owner 'grant execute on rawtonum to public'

@restore_sqlplus_settings
