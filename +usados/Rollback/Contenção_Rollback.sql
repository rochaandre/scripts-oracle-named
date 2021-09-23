SPOOL c:\rb_segm
SET space 3 verify OFF feedback OFF
PROMPT Examining Contention for Rollback Segment...
PROMPT ---------------------------------------------

COLUMN v1 NEW_VALUE suh
COLUMN v2 NEW_VALUE sub
COLUMN v3 NEW_VALUE uh
COLUMN v4 NEW_VALUE ub

SET heading OFF
SELECT class, count v1 FROM v$waitstat WHERE class = 'system undo header';
SELECT class, count v2 FROM v$waitstat WHERE class = 'system undo block';
SELECT class, count v3 FROM v$waitstat WHERE class = 'undo header';
SELECT class, count v4 FROM v$waitstat WHERE class = 'undo block';
SET heading ON
COLUMN req FORMAT 9999999999 HEADING 'REQUEST QUAN for data' NEW_VALUE sv
SELECT Sum(value) req FROM v$sysstat
WHERE name IN ('db block gets', 'consistent gets');

COLUMN p1 HEADING 'Ratio1 in %'
COLUMN p2 HEADING 'Ratio2 in %'
COLUMN p3 HEADING 'Ratio3 in %'
COLUMN p4 HEADING 'Ratio4 in %'
PROMPT
PROMPT
SELECT &&suh/&&sv * 100 p1, &&sub/&&sv * 100 p2, &&uh/&&sv * 100 p3, 
&&ub/&&sv * 100 p4 FROM dual;

PROMPT
PROMPT NB! If any ratio is > 1% then create more
PROMPT NB! Rollback Segments to reduce contention

SET space 1 feedback ON
SPOOL OFF
