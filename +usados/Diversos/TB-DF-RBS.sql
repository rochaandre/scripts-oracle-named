//Description:    The script generates a report of tablesapces, data files, roll back segments, control files, log files, objects (user wise, valid and invalid) 

set long 132
set serveroutput on
declare
cursor tablespaces is
select t.tablespace_name, round(sum(bytes/(1024*1024)),0) ts_size
from dba_tablespaces t, dba_data_files d
where t.tablespace_name = d.tablespace_name
group by t.tablespace_name;
cursor datafiles is
select tablespace_name, file_id, file_name,
round(bytes/(1024*1024),0) total_space
from dba_data_files
order by tablespace_name;

cursor rollbacksegments is
select segment_name, 
tablespace_name, r.status, 
(initial_extent/1024) InitialExtent,
(next_extent/1024) NextExtent, 
max_extents, v.curext CurExtent
From dba_rollback_segs r, v$rollstat v
Where r.segment_id = v.usn(+)
order by segment_name ;

cursor controlfiles is select name from v$controlfile;

cursor logfiles is select member from v$logfile;

cursor objects is select owner, object_type, status, count(*) count# from all_objects group by owner, object_type, status;

DBName VarChar2(20);
ToDate VarChar2(20);
Grand_Total_Space Integer;
Grand_Free_Space Integer;
TmpOwner VarChar2(50);
TmpObjectType VarChar2(50);
free_space Integer;
Ruler Char(90);
Remarks VarChar2(80);
Star Char(90);
Version VarChar2(80); 
Log_Mode VarChar2(32);
Created VarChar2(20);
ValidCount Integer;
InValidCount Integer;
TotValidCount Integer;
TotInValidCount Integer;
GrandValidCount Integer;
GrandInValidCount Integer;
Is_It_First_Record Integer;
begin
dbms_output.enable;

ruler :=
'---------------------------------------------------------------------------
-----';
Star :=
'***************************************************************************
*****';
Grand_Total_Space := 0;
Grand_Free_Space := 0;

Select Substr(Global_Name,1,4) , To_Char(sysdate,'DD-MON-YYYY
HH24:MI:SS')
Into DBName, ToDate 
From Global_Name;

Select version
Into Version
FROM Product_component_version
Where SUBSTR(PRODUCT,1,6)='Oracle';

Select Created, Log_Mode
Into Created, Log_Mode
From V$Database;

--
-- Database
--
dbms_output.put_line(Star);
dbms_output.put_line('Date : ' || ToDate);
dbms_output.put_line('Database : ' || DBName);
dbms_output.put_line('Created : ' || Created);
dbms_output.put_line('Version : ' || Version);
dbms_output.put_line('Log Mode : ' || Log_Mode);
dbms_output.put_line(Star);

--
-- Tablespaces
--
dbms_output.put_line('TABLESPACES (' || DBName || ')');
dbms_output.put_line(Ruler);
dbms_output.put_line( rpad('TABLESPACE',60,' ') ||
rpad('TOTAL(M)',10,' ') || rpad('FREE(M)',10,' '));
dbms_output.put_line(Ruler);
Grand_Total_Space := 0;
Grand_Free_Space := 0;

for tablespace in tablespaces loop
free_space := 0;

Begin
select sum(bytes/(1024*1024)) 
into free_space
from dba_free_space
where tablespace_name = tablespace.tablespace_name
group by tablespace_name;
Exception
When No_Data_Found Then Free_Space := 0;
End;

remarks := null;
If free_space <= (tablespace.ts_size * .1) then
remarks := ' ***';
End If;

dbms_output.put_line (rpad(tablespace.tablespace_name,60,'
') 
|| rpad(to_char(tablespace.ts_size)
,10,' ')
|| rpad(to_char(free_space) ,6,' ' )
|| remarks
);
Grand_Total_Space := Grand_Total_Space + tablespace.ts_size;
Grand_Free_Space := Grand_Free_Space + free_space;
end loop;
dbms_output.put_line('-----');
dbms_output.put_line (rpad('Total ',60,' ') ||
rpad(Grand_Total_Space,10,' ') || rpad(Grand_Free_Space,10,' '));
dbms_output.put_line('-----');

--
-- Data Files
--
dbms_output.put_line(Ruler);
dbms_output.put_line('DATA FILES (' || DBName || ')');
dbms_output.put_line(Ruler);
dbms_output.put_line( rpad('TABLESPACE',15,' ') || rpad('DATA
FILE',45,' ') || rpad('TOTAL(M)',10,' ') || rpad('FREE(M)',10,' '));
dbms_output.put_line(Ruler);
Grand_Total_Space := 0;
Grand_Free_Space := 0;

for datafile in datafiles loop
free_space := 0;

Begin
select sum(bytes/(1024*1024)) 
into free_space
from dba_free_space
where tablespace_name =
datafile.tablespace_name
and file_id = datafile.file_id
group by tablespace_name, file_id;
Exception
When No_Data_Found Then Free_Space := 0;
End;

remarks := null;
If free_space <= (datafile.total_space * .1) then
remarks := ' ***';
End If;

dbms_output.put_line (rpad(datafile.tablespace_name,15,' ') 
|| rpad(datafile.file_name,45,' ') 
||
rpad(to_char(datafile.total_space) ,10,' ')
|| rpad(to_char(free_space) ,6,' ')
|| remarks
);
Grand_Total_Space := Grand_Total_Space +
datafile.total_space;
Grand_Free_Space := Grand_Free_Space + free_space;
end loop;
dbms_output.put_line('-----');
dbms_output.put_line (rpad('Total ',60,' ') ||
rpad(Grand_Total_Space,10,' ') || rpad(Grand_Free_Space,10,' '));
dbms_output.put_line('-----');

--
-- RollBack Segments
--
dbms_output.put_line(Ruler);
dbms_output.put_line('ROLLBACK SEGMENTS (' || DBName || ')');
dbms_output.put_line(Ruler);
dbms_output.put_line( rpad('RBS NAME', 15, ' ') || 
rpad('TABLESPACE', 20, ' ') || 
rpad('STATUS', 8, ' ') || 
rpad('INITIAL(K)', 10, ' ') || 
rpad('NEXT(K)', 10, ' ') ||
rpad('MAX(NO)', 8, ' ') ||
rpad('CURR.(NO)', 9, ' ') 
);
dbms_output.put_line(Ruler);

for RBS in rollbacksegments loop
remarks := null;
If Rbs.Max_Extents - Rbs.CurExtent <= 10 then
remarks := ' ***';
End If;

dbms_output.put_line( rpad(rbs.segment_name,15,' ') || 
rpad(rbs.tablespace_name,20,' ') || 
rpad(rbs.status,8,' ') || 
rpad(rbs.initialextent,10,' ') || 
rpad(rbs.nextextent,10,' ') ||
rpad(rbs.Max_Extents,10,' ') ||
rpad(rbs.curextent,10,' ') 
);

end loop;

--
-- Control Files
--
dbms_output.put_line(Ruler);
dbms_output.put_line('CONTROL FILES (' || DBName || ')');
dbms_output.put_line(Ruler);

for controlfile in controlfiles loop
dbms_output.put_line( rpad(controlfile.name,50,' '));
end loop;

--
-- Log Files
--
dbms_output.put_line(Ruler);
dbms_output.put_line('LOG FILES (' || DBName || ')');
dbms_output.put_line(Ruler);

for logfile in logfiles loop
dbms_output.put_line( rpad(logfile.member,50,' '));
end loop;
dbms_output.put_line(Ruler);
end;
/
