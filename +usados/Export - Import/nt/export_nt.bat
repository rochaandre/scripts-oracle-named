@echo off
REM #####################################################################
REM PROGRAM NAME:	export_nt.bat                                  
REM PURPOSE: 		This utility performs a full export of     
REM 		                  database on Windows NT
REM USAGE:		export_nt.bat   SID 
REM #####################################################################

REM ::::::::::::::::::: Begin Declare Variables Section 

 set ORA_HOME=c:\oracle\ora81\bin
 set ORACLE_SID=%1
 set CONNECT_USER=system/manager
 set BACKUP_DIR=c:\backup\%ORACLE_SID%\export

 set TOOLS=c:\oracomn\admin\my_dba
 set LOGDIR=%TOOLS%\localog
 set LOGFILE=%LOGDIR%\%ORACLE_SID%.log

REM :::::::::::::::::::: End Declare Variables Section 

REM :::::::::::::::::::: Begin Parameter Checking Section 

if  "%1" == ""  goto usage

REM Create backup directories if already not exist 
if not exist %BACKUP_DIR%   mkdir %BACKUP_DIR%
if not exist %LOGDIR%       mkdir %LOGDIR%


REM Check to see that there were no create errors 
if not exist %BACKUP_DIR%  goto backupdir

REM  Deletes previous backup. Make sure you have it on tape.
del/q   %BACKUP_DIR%\*

REM :::::::::::::::::::: End Parameter Checking Section 

REM :::::::::::::::::::: Begin Export Section 

%ORA_HOME%\exp  %CONNECT_USER%  parfile=export_par.txt
(echo Export Completed Successfully  & date/T & time/T) >> %LOGFILE%
goto end

REM :::::::::::::::::::: End Export Section 


REM :::::::::::::::::::::::::::: Begin Error handling section

:usage
  echo Error, Usage: coldbackup_nt.bat  SID
  goto end

:backupdir
 echo Error creating Backup directory structure
  (echo EXPORT_FAIL:Error creating Backup directory structure  & date/T & time/T) >> %LOGFILE%

REM :::::::::::::::::::::::::::: End Error handling section


REM ::::::::::::::::::::::::::: Cleanup Section
:end
set ORA_HOME=
set ORACLE_SID=
set CONNECT_USER=
set BACKUP_DIR=






