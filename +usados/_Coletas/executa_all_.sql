accept vusuario prompt 'Informe o usuário: '
accept vsenha   prompt 'Informe a senha: ' hide
clear scre
spool c:\coleta_all.txt

prompt ****************************************************************************************
prompt VESPER20 - 10.11.255.20 
connect &vusuario/&vsenha@VESPER20
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSD20 - 10.11.255.20
connect &vusuario/&vsenha@MDSD20
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt CCBS - 10.11.255.21 
connect &vusuario/&vsenha@CCBS
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VESPER22 - 10.11.255.22 
connect &vusuario/&vsenha@VESPER22
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSDEV28 - 10.11.255.28 
connect &vusuario/&vsenha@MDSDEV28
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt SAM - 10.11.255.33 
connect &vusuario/&vsenha@SAM
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt SPGISDEV - 10.11.255.35 
connect &vusuario/&vsenha@SPGISDEV
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt RJGIS - 10.11.255.35 
connect &vusuario/&vsenha@RJGIS
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt HMVESP02 - 10.11.255.61 
connect &vusuario/&vsenha@hmvesp02
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBVPRDEV - 10.11.255.61 
connect &vusuario/&vsenha@DBVPRDEV
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DSVESP01 - 10.11.255.61 
connect &vusuario/&vsenha@dsvesp01
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt HMCOLL - 10.11.255.61 
connect &vusuario/&vsenha@HMCOLL
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBPD001 - 10.11.255.64 
connect &vusuario/&vsenha@DBPD001
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DSP - 10.11.255.65 
connect &vusuario/&vsenha@DSP
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VTEST - 10.11.255.66 
connect &vusuario/&vsenha@VTEST
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBMIS - 10.11.255.96 
connect &vusuario/&vsenha@DBMIS
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBPDCOLL - 10.11.255.97 
connect &vusuario/&vsenha@DBPDCOLL
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt PSP - 10.11.255.114 
connect &vusuario/&vsenha@PSP
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VSPICS - 10.11.255.100 
connect &vusuario/&vsenha@VSPICS
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt CCBSDEV - 10.11.255.147 
connect &vusuario/&vsenha@CCBSDEV
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MSPR - 10.21.25.53 
connect &vusuario/&vsenha@MSPR
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt PRJ - 10.21.25.55 
connect &vusuario/&vsenha@PRJ
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt COLL - 10.21.25.59 
connect &vusuario/&vsenha@COLL
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBMSA - 10.21.25.61 
connect &vusuario/&vsenha@DBMSA
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDDB - 10.21.42.159 
connect &vusuario/&vsenha@MDDB.WORLD
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSD160 - 10.21.42.160 
connect &vusuario/&vsenha@MDSD.WORLD
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBVESP_P - 10.24.2.85 
connect &vusuario/&vsenha@DBVESP_P
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************

spool off
disconnect