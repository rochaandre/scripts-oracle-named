REM #############################################################
REM ###### DIAGNOSTICANDO CONTEÇÃO HEADER SEGMENTO ROLLBACK #####
REM #############################################################
REM ###### NOTA: A RELAÇÃO DA SOMATÓRIA D E  "WAITS"  PELA  #####
REM ###### SOMATÓRIA DE GETS DEVE SER MENOR QUE 1%. O IDEAL #####
REM ###### É "0" SENÃO, CRIE MAIS SEGMENTOS DE ROLLBACK.    #####     
REM #############################################################

SELECT SUM(WAITS) * 100 / SUM(GETS) "RATIO",
SUM(WAITS) "WAITS", SUM(GETS) GETS
FROM V$ROLLSTAT
/
