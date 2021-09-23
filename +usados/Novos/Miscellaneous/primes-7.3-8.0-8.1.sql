-------------------------------------------------------------------------------
--
-- Script:	primes.sql
-- Purpose:	to list prime numbers within a range
--
-- Copyright:	(c) Ixora Pty Ltd
-- Author:	Steve Adams
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

@accept Low  "Lower bound" 2
@accept High "Upper bound" 100

set serveroutput on 

declare
  non boolean;
begin 
  for p in &Low .. &High loop
    non := false;
    for f in 2..floor(sqrt(p)) loop
      non := (mod(p, f) = 0);
      exit when non;
    end loop;
    if (not non) then 
      sys.dbms_output.put_line(to_char(p)); 
    end if; 
  end loop; 
end; 
/ 

undefine Low
undefine High
@restore_sqlplus_settings
