accept vusuario prompt 'Informe o usuário: '
accept vsenha   prompt 'Informe a senha: ' hide
clear scre
spool c:\coleta_all.txt

VESPER20 10.11.255.20 VESPER	
MDSD20 10.11.255.20	
CCBS 10.11.255.21 CCBS	
VESPER22 10.11.255.22 VESPER	
MDSDEV28 10.11.255.28 MDSDEV	
SAM 10.11.255.33 SAM	
SPGISDEV 10.11.255.35 SPGISDEV	
RJGIS 10.11.255.35 RJGIS	
HMVESP02 10.11.255.61 hmvesp02	
DBVPRDEV 10.11.255.61 DBVPRDEV	
DSVESP01 10.11.255.61 dsvesp01	
HMCOLL =10.11.255.61 HMCOLL	
DBPD001 10.11.255.64 DBPD001	
DSP 10.11.255.65 DSP	
DRJ 10.11.255.65 DRJ	
QSP 10.11.255.65 QSP	
QRJ 10.11.255.65 QRJ	
VTEST 10.11.255.66 VTEST	
DBMIS 10.11.255.96 DBMIS	
DBPDCOLL 10.11.255.97 DBPDCOLL	
PSP 10.11.255.114 PSP	
VSPICS 10.11.255.100 VSPICS	
CCBSDEV 10.11.255.147 CCBSDEV	
MSPR 10.21.25.53 MSPR	
PRJ 10.21.25.55 PRJ	
COLL 10.21.25.59 COLL	
DBMSA 10.21.25.61 DBMSA	
MDDB 10.21.42.159 MDDB.WORLD	
MDSD160 10.21.42.160 MDSD.WORLD	
DBVESP_P 10.24.2.85 DBVESP_P	

prompt ****************************************************************************************
prompt HMCOLL - 10.11.255.61
connect &vusuario/&vsenha@hmcoll
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt QSP - 10.11.255.65
connect &vusuario/&vsenha@qsp
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DSP - 10.11.255.65
connect &vusuario/&vsenha@dsp
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt SPGISDEV - 10.11.255.32
connect &vusuario/&vsenha@spgisdev
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VESPER22 - 10.11.255.22
connect &vusuario/&vsenha@vesper22
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VESPER20 - 10.11.255.20
connect &vusuario/&vsenha@vesper20
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSD160 - 10.21.42.160
connect &vusuario/&vsenha@mdsd160
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBBSC61 - 10.21.25.61
connect &vusuario/&vsenha@dbbsc61
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBVPRDEV - 10.11.255.61
connect &vusuario/&vsenha@dbvprdev
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSD - 10.11.255.20
connect &vusuario/&vsenha@mdsd
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDRDEV - 10.11.255.24
connect &vusuario/&vsenha@mdrdev
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt QRJ - 10.11.255.65
connect &vusuario/&vsenha@qrj
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt VTEST - 10.11.255.66
connect &vusuario/&vsenha@vtest
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSDEV28 - 10.11.255.28
connect &vusuario/&vsenha@mdsdev28
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DRJ - 10.11.255.65
connect &vusuario/&vsenha@drj
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSDEV24 - 10.11.255.24
connect &vusuario/&vsenha@mdsdev24
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDSD_VES0501 - VES0501
connect &vusuario/&vsenha@mdsd_ves0501
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBECHG - 10.11.255.58
connect &vusuario/&vsenha@dbechg
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBBSC55 - 10.11.255.55
connect &vusuario/&vsenha@dbbsc55
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DSVESP01 - 10.11.255.61
connect &vusuario/&vsenha@dsvesp01
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt HMVESP02 - 10.11.255.61
connect &vusuario/&vsenha@hmvesp02
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt MDDB - 10.21.42.159
connect &vusuario/&vsenha@mddb
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt RJGIS - 10.11.255.32
connect &vusuario/&vsenha@rjgis
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt PSP - 10.11.255.114
connect &vusuario/&vsenha@psp
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt CCBSDEV - 10.11.255.147
connect &vusuario/&vsenha@ccbsdev
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt COLL - 10.21.25.59
connect &vusuario/&vsenha@coll
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt SAM - 10.11.255.33
connect &vusuario/&vsenha@sam
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBBSC_BRSBVPA2 - BRSBVPA2
connect &vusuario/&vsenha@dbbsc_brsbvpa2
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************
prompt DBMSA - 10.21.25.61
connect &vusuario/&vsenha@dbmsa
@C:\Barcelos\Oracle\Scripts\+usados\comandos
prompt ****************************************************************************************

spool off
disconnect