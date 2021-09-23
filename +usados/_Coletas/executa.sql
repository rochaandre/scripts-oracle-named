accept vusuario prompt 'Informe o usuário: '
accept vsenha   prompt 'Informe a senha: ' hide
clear scre
spool c:\coleta.txt

prompt DEV - 172.16.48.12 - SPOUX02	
connect &vusuario/&vsenha@DEV
@c:\docs\scripts\+usados\comandos

prompt BWD - 172.16.48.14 - SPOUX18	
connect &vusuario/&vsenha@BWD
@c:\docs\scripts\+usados\comandos

prompt STG - 172.16.48.15 - SPOUX17	
connect &vusuario/&vsenha@STG
@c:\docs\scripts\+usados\comandos

prompt CRD - 172.16.48.23 - SPOUX13	
connect &vusuario/&vsenha@CRD
@c:\docs\scripts\+usados\comandos

prompt CRP - 172.16.48.24 - SPOUX14	
connect &vusuario/&vsenha@CRP
@c:\docs\scripts\+usados\comandos

prompt PARALELA - 172.16.48.28 - SPOUXRH	
connect &vusuario/&vsenha@PARALELA
@c:\docs\scripts\+usados\comandos

prompt BWP - 172.16.48.34 - SPOUXBW	
connect &vusuario/&vsenha@BWP
@c:\docs\scripts\+usados\comandos

prompt TSTPRD - 172.16.48.36 - SPOUXTST 	
connect &vusuario/&vsenha@TSTPRD
@c:\docs\scripts\+usados\comandos

prompt PRD - 172.16.48.36 - SPOUX00	
connect &vusuario/&vsenha@PRD
@c:\docs\scripts\+usados\comandos

prompt PJC - 172.16.48.71 - SPOUX29	
connect &vusuario/&vsenha@PJC
@c:\docs\scripts\+usados\comandos

prompt BWQ - 172.16.48.74 - SPOUX19	
connect &vusuario/&vsenha@BWQ
@c:\docs\scripts\+usados\comandos

prompt APO - 172.16.48.79 - SPOUX42	
connect &vusuario/&vsenha@APO
@c:\docs\scripts\+usados\comandos

prompt APQ - 172.16.48.80 - SPOUX43	
connect &vusuario/&vsenha@APQ
@c:\docs\scripts\+usados\comandos

--prompt PJR - 172.16.48.81 - SPOUX31	
--connect &vusuario/&vsenha@PJR
--@c:\docs\scripts\+usados\comandos

prompt LF - 172.16.49.10 - SPO12	
connect &vusuario/&vsenha@LF
@c:\docs\scripts\+usados\comandos

prompt GED - 172.16.49.12 - SPO25	
connect &vusuario/&vsenha@GED
@c:\docs\scripts\+usados\comandos

--prompt KMD - 172.16.49.174 - SPO70	
--connect &vusuario/&vsenha@KMD
--@c:\docs\scripts\+usados\comandos

prompt RHQA - 	172.16.49.216 - SPO39 	
connect &vusuario/&vsenha@RHQA
@c:\docs\scripts\+usados\comandos

prompt RHPRD - 172.16.49.225 - SPO55 	
connect &vusuario/&vsenha@RHPRD
@c:\docs\scripts\+usados\comandos

prompt INTPRD - 172.16.49.233 - SPO63 	
connect &vusuario/&vsenha@INTPRD
@c:\docs\scripts\+usados\comandos

prompt COOPCRED - 172.16.49.4 - SPONT12	
connect &vusuario/&vsenha@COOPCRED
@c:\docs\scripts\+usados\comandos

prompt NOVAINTRANET - 172.16.49.5 - SPONT10 	
connect &vusuario/&vsenha@NOVAINTRANET
@c:\docs\scripts\+usados\comandos

--prompt NETP - 172.16.49.8 - SPONT9 	
--connect &vusuario/&vsenha@NETP
--@c:\docs\scripts\+usados\comandos

prompt BINT - 172.16.49.85 - SPO85 	
connect &vusuario/&vsenha@BINT
@c:\docs\scripts\+usados\comandos

--prompt CPA - 172.16.50.3 - SPO20 	
--connect &vusuario/&vsenha@CPA
--@c:\docs\scripts\+usados\comandos

prompt IDS - 172.16.50.3 - SPO20 	
connect &vusuario/&vsenha@IDS
@c:\docs\scripts\+usados\comandos

--prompt RHDEV - 172.16.53.183 - SPO67 	
--connect &vusuario/&vsenha@RHDEV
--@c:\docs\scripts\+usados\comandos

--prompt PENDURA - 172.18.4.176 - CPZ155652 	
--connect &vusuario/&vsenha@PENDURA
--@c:\docs\scripts\+usados\comandos

--prompt VISAO - 172.18.4.177 - CPZ155653	
--connect &vusuario/&vsenha@VISAO
--@c:\docs\scripts\+usados\comandos


spool off
disconnect