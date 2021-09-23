@echo off
REM ##############################################################
REM PROGRAM NAME:	coldbackup_nt.bat                                  
REM PURPOSE: 		This utility performs cold backup of    
REM 		                  the database on Windows NT
REM USAGE:		coldbackup_nt.bat  SID 
REM INPUT PARAMETERS:
REM ###############################################################

REM ::::::::::::::::::: Begin Declare Variables Section

 set ORA_HOME=d:\oracle\ora81\bin
 set CONNECT_USER="/ as sysdba"
 set ORACLE_SID=%1
 set BACKUP_DIR=c:\backup\%ORACLE_SID%\cold
 set INIT_FILE=d:\oracle\admin\orcl\pfile\initorcl.ora

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log

 set CFILE=%BACKUP_DIR%\log\coldbackup.sql
 set ERR_FILE=%BACKUP_DIR%\log\cerrors.log
 set LOG_FILE=%BACKUP_DIR%\log\cbackup.log
 set BKP_DIR=%BACKUP_DIR%

REM :::::::::::::::::::: End Declare Variables Section

REM :::::::::::::::::::: Begin Parameter Checking Section 

if  "%1" == ""  goto usage

REM Create backup directories if already not exist 
if not exist %BACKUP_DIR%\data      mkdir %BACKUP_DIR%\data
if not exist %BACKUP_DIR%\control   mkdir %BACKUP_DIR%\control
if not exist %BACKUP_DIR%\redo      mkdir %BACKUP_DIR%\redo
if not exist %BACKUP_DIR%\log       mkdir %BACKUP_DIR%\log
if not exist %LOGDIR%               mkdir %LOGDIR%

REM Check to see that there were no create errors 
if not exist %BACKUP_DIR%\data  goto backupdir
if not exist %BACKUP_DIR%\control  goto backupdir
if not exist %BACKUP_DIR%\redo  goto backupdir
if not exist %BACKUP_DIR%\log  goto backupdir

REM  Deletes previous backup. Make sure you have it on tape.
del/q   %BACKUP_DIR%\data\*  
del/q   %BACKUP_DIR%\control\*
del/q   %BACKUP_DIR%\redo\*  
del/q   %BACKUP_DIR%\log\*

echo. > %ERR_FILE%
echo. > %LOG_FILE%
(echo Cold Backup started  & date/T & time/T) >> %LOG_FILE%

echo Parameter Checking Completed  >> %LOG_FILE%
REM :::::::::::::::::::: End Parameter Checking Section 

REM :::::::::::::::::::: Begin Create Dynamic files Section 
echo.									>%CFILE%
echo set termout off   heading off    feedback off 			>>%CFILE%
echo set  linesize 300  pagesize 0					>>%CFILE%
echo set serveroutput on size 1000000					>>%CFILE%
echo.									>>%CFILE%
echo spool  %BACKUP_DIR%\log\coldbackup_list.bat			>>%CFILE%
echo.									>>%CFILE%
echo  exec dbms_output.put_line('@echo off' );				>>%CFILE%
echo.									>>%CFILE%
echo      exec dbms_output.put_line('REM  ******Data files' );		>>%CFILE%
echo      select 'copy  '^|^| file_name^|^| '   %BKP_DIR%\data '	>>%CFILE%
echo      from dba_data_files  order by tablespace_name;		>>%CFILE%
echo.									>>%CFILE%
echo      exec dbms_output.put_line('REM  ******Control files' );	>>%CFILE%
echo      select 'copy  '^|^| name^|^| '   %BKP_DIR%\control '	 	>>%CFILE%
echo      from v$controlfile  order by name;				>>%CFILE%
echo.									>>%CFILE%
echo     exec  dbms_output.put_line('REM  ******Init.ora file ' );	>>%CFILE%
echo     select ' copy   %INIT_FILE%    %BKP_DIR%\control '		>>%CFILE%
echo     from dual;							>>%CFILE%
echo exec  dbms_output.put_line('exit;');				>>%CFILE%
echo spool off								>>%CFILE%
echo exit								>>%CFILE%

echo Dynamic files Section Completed >> %LOG_FILE%
REM :::::::::::::::::::: End Create Dynamic files Section 


REM :::::::::::::::::::: Begin ColdBackup Section 

 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @%CFILE%
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @shutdown_i_nt.sql
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @startup_r_nt.sql
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @shutdown_n_nt.sql

REM  Copy the files to backup location
 start/b  %BACKUP_DIR%\log\coldbackup_list.bat  1>> %LOG_FILE% 2>> %ERR_FILE%
 %ORA_HOME%\sqlplus -s  %CONNECT_USER%  @startup_n_nt.sql

(echo ColdBackup Completed Successfully  & date/T & time/T) >> %LOG_FILE%
(echo ColdBackup Completed Successfully  & date/T & time/T) >> %LOGFILE%
goto end

REM :::::::::::::::::::: End ColdBackup Section 


REM :::::::::::::::::::::::::::: Begin Error handling section

:usage
  echo Error, Usage: coldbackup_nt.bat  SID 
  goto end

:backupdir
  echo Error creating Backup directory structure >> %ERR_FILE%
  (echo COLDBACKUP_FAIL:Error creating Backup directory structure  & date/T & time/T) >> %LOGFILE%
REM :::::::::::::::::::::::::::: End Error handling section

REM ::::::::::::::::::::::::::: Cleanup  Section
:end
set ORA_HOME=
set ORACLE_SID=
set CONNECT_USER=
set BACKUP_DIR=
set INIT_FILE=
set CFILE=
set ERR_FILE=
set LOG_FILE=
set BKP_DIR=
