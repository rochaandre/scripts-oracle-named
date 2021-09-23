-- consultar objetos bloqueados por usuario
SELECT    LO.SESSION_ID, LO.PROCESS, LO.ORACLE_USERNAME, O.OWNER, O.OBJECT_NAME
FROM      V$LOCKED_OBJECT LO
JOIN      DBA_OBJECTS O
  ON      O.OBJECT_ID = LO.OBJECT_ID;

-- consultar locks que estao bloqueando outras sessoes
SELECT  L.SESSION_ID, L.LOCK_TYPE, L.MODE_HELD, L.LOCK_ID1, L.LOCK_ID2, L.BLOCKING_OTHERS
FROM    DBA_LOCKS L
WHERE   L.BLOCKING_OTHERS <> 'Not Blocking';

-- consultar sessoes bloqueadoras
select * from dba_blockers;

-- consultar sessoes bloqueadas
select * from dba_waiters;


select      /*+ ALL_ROWS */
            b.sid, 
            c.username, 
            c.osuser, 
            c.terminal, 
            c.status, 
            a.owner, 
            decode (NVL (b.id2, 0), 0, a.object_name, 'Trans-'||to_char(b.id1)) object_name, 
            b.type,
            decode (NVL (b.lmode, 0), 0, '--Waiting--',
                              1, 'Null',
                              2, 'Row Share',
                              3, 'Row Excl',
                              4, 'Share',
                              5, 'Sha Row Exc',
                              6, 'Exclusive',
                              'Other') "Lock Mode",
            decode(NVL (b.request, 0), 0, ' - ',
                              1, 'Null',
                              2, 'Row Share',
                              3, 'Row Excl',
                              4, 'Share',
                              5, 'Sha Row Exc',
                              6, 'Exclusive',
                              'Other') "Req Mode"
from          dba_objects a
right join    v$lock b
    on        a.object_id = b.id1
inner join    v$session c
    on        b.sid = c.sid
where         c.username is not null;
-- order by b.sid, b.id2 


 select distinct process,sid,serial# 
 from gv$session where blocking_session is not null;

 select process,sid, blocking_session from gv$session where blocking_session is not null;

 SQL>  select distinct process,sid,serial# 
 from gv$session where blocking_session is not null;

  2  
PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234				582	  1740
1234			       1151	 17354
1234			       2007	 35063
1234				680	 50520
1234				957	 65004
1234			       1528	  1487
1234			       1628	 37451
1234			       2006	  8287
1234			       2381	 41217
1234				102	 35667
1234				200	 51047

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       2289	 22321
1234			       2395	 17026
1234				587	 35599
1234			       1436	 14616
1234			       1437	 24706
1234			       1530	 45517
1234			       1624	 63264
1234			       2301	 54259
1234			       2287	 55326
1234			       2578	 33022
1234			       2582	 63565

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       2200	 34164
1234			       2290	 44999
1234			       2673	 20055
1234				585	 17051
1234			       1249	 36991
1234			       2016	 25911
1234			       2489	 58891
1234			       2579	  3573
1234			       1153	 59160
1234			       1242	 20610
1234			       1539	 45904

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       1825	 59344
1234			       2571	 49498
1234				871	 49498
1234			       1062	 29839
1234			       1244	 41911
1234			       1345	 59172
1234			       2096	 11274
1234			       2669	 52322
1234			       2680	  2428
1234			       2769	 13077
1234				967	 35071

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       2675	 42139
1234				294	 19030
1234			       1155	 19591
1234			       1916	 25396
1234			       2584	 27088
1234			       2587	  6610
1234			       2665	 44193
1234			       1435	  9817
1234			       2671	 55980
1234				581	  3388
1234				588	 50821

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       1159	  2672
1234			       1257	 38301
1234			       1344	 54099
1234			       1724	 44254
1234			       1724	 32772
1234			       2475	  2928
1234				109	  8702
1234				869	 64318
1234			       1065	 34388
1234			       1069	  8260
1234			       1160	 52695

66 rows selected.

SQL> SQL> 
SQL> /

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234				680	 50520
1234				957	 65004
1234				965	 45833
1234			       1528	  1487
1234			       1628	 37451
1234			       2006	  8287
1234			       2381	 41217
1234				582	  1740
1234			       1151	 17354
1234			       2007	 35063
1234				587	 35599

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       1436	 14616
1234			       1437	 24706
1234			       1530	 45517
1234			       1624	 63264
1234			       2301	 54259
1234				102	 35667
1234				200	 51047
1234			       2289	 22321
1234			       2395	 17026
1234			       2200	 34164
1234			       2290	 44999

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       2673	 20055
1234			       2287	 55326
1234			       2578	 33022
1234			       2582	 63565
1234			       1249	 36991
1234			       2016	 25911
1234			       2489	 58891
1234			       2579	  3573
1234				585	 17051
1234				871	 49498
1234			       1062	 29839

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       1244	 41911
1234			       1345	 59172
1234			       2096	 11274
1234			       2669	 52322
1234			       2680	  2428
1234			       2769	 13077
1234			       1153	 59160
1234			       1242	 20610
1234			       1539	 45904
1234			       1825	 59344
1234			       2571	 49498

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234				294	 19030
1234			       1155	 19591
1234			       1916	 25396
1234			       2584	 27088
1234			       2587	  6610
1234			       2665	 44193
1234				967	 35071
1234			       2675	 42139
1234				581	  3388
1234				588	 50821
1234			       1159	  2672

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       1257	 38301
1234			       1344	 54099
1234			       1724	 44254
1234			       1435	  9817
1234			       2671	 55980
1234				109	  8702
1234				869	 64318
1234			       1065	 34388
1234			       1069	  8260
1234			       1160	 52695
1234			       1724	 32772

PROCESS 			SID    SERIAL#
------------------------ ---------- ----------
1234			       2475	  2928

67 rows selected.

