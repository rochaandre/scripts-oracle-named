/* Dimensionando Transação de Dados para Rollback
-- Deletes são caros
-- Inserts usam espaço mínimo de rollback
-- updates usam espaço de rollback dependendo do número de colunas
-- Manutenção de índices adiona rollback
*/

SELECT S.USERNAME, T.USED_UBLK,T.START_TIME
FROM V$TRANSACTION T, V$SESSION S
WHERE T.ADDR= S.TADDR
/
