CREATE OR REPLACE VIEW SAPR3.Z3015 
(MANDT,WERKS,DTPRO,MATNR,EMATN,AUFNR,CHARG,LGORT,PSMNG,DTEMB)
AS select 
MANDT,WERKS,DTPRO,MATNR,EMATN,AUFNR,CHARG,LGORT,PSMNG,DTEMB
from sapr3.z3015@bint.world


CREATE OR REPLACE VIEW SAPR3.Z3015 
(MANDT,WERKS,DTPRO,MATNR,EMATN,AUFNR,CHARG,LGORT,PSMNG,DTEMB) 
AS select  
MANDT,WERKS,DTPRO,MATNR,EMATN,AUFNR,CHARG,LGORT,PSMNG,DTEMB 
from sapr3.z3015@sap.world




spouxrh
========
exp system/sysnovo file=teste.dmp owner=sapr3 grants=y rows=y compress=y

exp system/sysnovo file=z3015.dmp tables=sapr3.z3015 grants=y rows=y compress=y



spo8
====
ftp spouxrh ===> Setar para modo binario: bin
imp system/karina10@bint fromuser=sapr3 touser=sapr3 tables=z3015 file=z3015.dmp log=c:\z3015.log

