@echo off
REM #####################################################################
REM PROGRAM NAME:	hotbackup_nt.bat                                  
REM AUTHOR: 		Raj Gutta                                     
REM PURPOSE: 		This utility performs hot backup of    
REM 		                  the database on Windows NT
REM USAGE:		hotbackup_nt.bat  SID 
REM #####################################################################

REM ::::::::::::::::::: Begin Declare Variables Section 

 set ORA_HOME=d:\oracle\ora81\bin
 set CONNECT_USER="/ as sysdba"
 set ORACLE_SID=%1
 set BACKUP_DIR=c:\backup\%ORACLE_SID%\hot
 set  INIT_FILE=d:\oracle\admin\orcl\pfile\initorcl.ora
 set  ARC_DEST=d:\oracle\oradata\orcl\archive

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log

 set HFILE=%BACKUP_DIR%\log\hotbackup.sql
 set ERR_FILE=%BACKUP_DIR%\log\herrors.log
 set LOG_FILE=%BACKUP_DIR%\log\hbackup.log
 set BKP_DIR=%BACKUP_DIR%
REM :::::::::::::::::::: End Declare Variables Section 

REM :::::::::::::::::::: Begin Parameter Checking Section 

if  "%1" == ""  goto usage

REM     Create backup directories if already not exist 
if not exist %BACKUP_DIR%\data      mkdir %BACKUP_DIR%\data
if not exist %BACKUP_DIR%\control   mkdir %BACKUP_DIR%\control
if not exist %BACKUP_DIR%\arch      mkdir %BACKUP_DIR%\arch
if not exist %BACKUP_DIR%\log       mkdir %BACKUP_DIR%\log
if not exist %LOGDIR%               mkdir %LOGDIR%

REM    Check to see that there were no create errors 
if not exist %BACKUP_DIR%\data  goto backupdir
if not exist %BACKUP_DIR%\control  goto backupdir
if not exist %BACKUP_DIR%\arch  goto backupdir
if not exist %BACKUP_DIR%\log  goto backupdir

REM  Deletes previous backup. Make sure you have it on tape.
del/q   %BACKUP_DIR%\data\*
del/q   %BACKUP_DIR%\control\*
del/q   %BACKUP_DIR%\arch\*
del/q   %BACKUP_DIR%\log\*

echo. > %ERR_FILE%
echo. > %LOG_FILE%
(echo Hot Backup started  & date/T & time/T) >> %LOG_FILE%
echo Parameter Checking Completed  >> %LOG_FILE%
REM :::::::::::::::::::: End Parameter Checking Section 

REM :::::::::::::::::::: Begin Create Dynamic files Section 
echo.										>%HFILE%
echo set termout off   heading off    feedback off				>>%HFILE%
echo set  linesize 250  pagesize 0						>>%HFILE%
echo set serveroutput on size 1000000						>>%HFILE%
echo spool  %BACKUP_DIR%\log\hotbackup_list.sql					>>%HFILE%

echo Declare									>>%HFILE%
echo    cursor c1  is  select distinct tablespace_name from dba_data_files	>>%HFILE%
echo       order by tablespace_name;						>>%HFILE%
echo    cursor c2(ptbs varchar2) is  select file_name from dba_data_files	>>%HFILE%
echo       where tablespace_name = ptbs order by file_name;			>>%HFILE%
echo Begin									>>%HFILE%
echo     dbms_output.put_line('set termout off heading off feedback off');	>>%HFILE%

echo.										>>%HFILE%
echo     dbms_output.put_line(chr(10)  );					>>%HFILE%
echo     dbms_output.put_line('host  REM  ******Data files' );			>>%HFILE%
echo     for tbs in c1 loop							>>%HFILE%
echo       dbms_output.put_line('alter tablespace '^|^| tbs.tablespace_name ^|^|' begin backup;');					>>%HFILE%
echo         for dbf in c2(tbs.tablespace_name) loop											>>%HFILE%
echo           dbms_output.put_line('host copy  '^|^|dbf.file_name^|^|'    %BKP_DIR%\data      1^>^> %LOG_FILE%   2^>^> %ERR_FILE%');	>>%HFILE%
echo         end loop;															>>%HFILE%
echo       dbms_output.put_line('alter tablespace '^|^|tbs.tablespace_name ^|^|' end backup;');					>>%HFILE%
echo     end loop;								>>%HFILE%

echo.										>>%HFILE%
echo     dbms_output.put_line(chr(10)  );					>>%HFILE%
echo     dbms_output.put_line('host  REM  ******Control files ' );		>>%HFILE%
echo     dbms_output.put_line('alter database backup controlfile to '^|^| ''''^|^|'%BKP_DIR%\control\coltrol_file.ctl'^|^|''''^|^|';');	>>%HFILE%
echo     dbms_output.put_line('alter database backup controlfile to trace;');  >>%HFILE%

echo.										>>%HFILE%
echo     dbms_output.put_line(chr(10)  );					>>%HFILE%
echo     dbms_output.put_line('host  REM  ******Init.ora file ' );		>>%HFILE%
echo     dbms_output.put_line('host copy  %INIT_FILE%   %BKP_DIR%\control      1^>^> %LOG_FILE%   2^>^> %ERR_FILE%');			>>%HFILE%

echo.										>>%HFILE%
echo     dbms_output.put_line(chr(10)  ); 					>>%HFILE%
echo     dbms_output.put_line('host  REM  ******Archivelog files' );		>>%HFILE%
echo     dbms_output.put_line('alter system switch logfile;');   		>>%HFILE% 
echo     dbms_output.put_line('alter system archive log stop;');   		>>%HFILE%
echo     dbms_output.put_line('host move  %ARC_DEST%\*    %BKP_DIR%\arch      1^>^> %LOG_FILE%   2^>^> %ERR_FILE%' );    		>>%HFILE%
echo     dbms_output.put_line('alter system archive log start;');  	  	>>%HFILE%


echo     dbms_output.put_line('exit;');						>>%HFILE%
echo End;									>>%HFILE%
echo /										>>%HFILE%
echo spool off									>>%HFILE%
echo exit;									>>%HFILE%

echo Dynamic files Section Completed >> %LOG_FILE%
REM :::::::::::::::::::: End Create Dynamic files Section 

REM :::::::::::::::::::: Begin HotBackup Section 

%ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%HFILE%
REM  Copy the files to backup location
%ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%BACKUP_DIR%\log\hotbackup_list.sql
(echo HotBackup Completed Successfully  & date/T & time/T) >> %LOG_FILE%
(echo HotBackup Completed Successfully  & date/T & time/T) >> %LOGFILE%
goto end

REM :::::::::::::::::::: End HotBackup Section 


REM :::::::::::::::::::::::::::: Begin Error handling section

:usage
  echo Error, Usage: hotbackup_nt.bat  SID
  goto end

:backupdir
  echo Error creating Backup directory structure >> %ERR_FILE%
  (echo HOTBACKUP_FAIL:Error creating Backup directory structure  & date/T & time/T) >> %LOGFILE%
REM :::::::::::::::::::::::::::: End Error handling section

REM ::::::::::::::::::::::::::::  Cleanup Section
:end
set ORA_HOME=
set ORACLE_SID=
set CONNECT_USER=
set BACKUP_DIR=
set  INIT_FILE=
set ARC_DEST=
set HFILE=
set ERR_FILE=
set LOG_FILE=
set BKP_DIR=