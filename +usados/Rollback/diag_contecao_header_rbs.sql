REM #############################################################
REM ###### DIAGNOSTICANDO CONTE��O HEADER SEGMENTO ROLLBACK #####
REM #############################################################
REM ###### NOTA: A RELA��O DA SOMAT�RIA D E  "WAITS"  PELA  #####
REM ###### SOMAT�RIA DE GETS DEVE SER MENOR QUE 1%. O IDEAL #####
REM ###### � "0" SEN�O, CRIE MAIS SEGMENTOS DE ROLLBACK.    #####     
REM #############################################################

SELECT SUM(WAITS) * 100 / SUM(GETS) "RATIO",
SUM(WAITS) "WAITS", SUM(GETS) GETS
FROM V$ROLLSTAT
/
