SELECT JOB,
SUBSTR(WHAT,1,35),
NEXT_DATE,
NEXT_SEC,
BROKEN
FROM DBA_JOBS

pause