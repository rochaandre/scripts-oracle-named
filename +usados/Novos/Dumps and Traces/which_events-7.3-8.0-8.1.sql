-------------------------------------------------------------------------------
--
-- Script:	which_events.sql
-- Purpose:	to show which events are set
--
-------------------------------------------------------------------------------
@save_sqlplus_settings

set feedback off
set serveroutput on 

declare 
  event_level number; 
begin 
  for event_number in 10000..10999 loop 
    sys.dbms_system.read_ev(event_number, event_level); 
    if (event_level > 0) then 
      sys.dbms_output.put_line(
	'Event ' ||
	to_char(event_number) ||
	' is set at level ' || 
	to_char(event_level)
      ); 
    end if; 
  end loop; 
end; 
/ 

@restore_sqlplus_settings
