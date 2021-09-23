 select a.TS1 tablespace_name,
        (1-(NVL(b.SUM_B2,0)/a.SUM_B1))*100 b4x,
        a.SUM_B1 B1,
        a.SUM_B1 - NVL(b.SUM_B2,0) b3,
        NVL(b.SUM_B2,0) B2,
        NVL(b.MAX_B2,0) b6,
        NVL(b.CNT_B2,0) b7,
        a.CNT_B1 C_B1,
        (NVL(b.SUM_B2,0)/a.SUM_B1)*100 b5
   FROM (select tablespace_name TS1,
                sum(bytes) SUM_B1,
                count(bytes) CNT_B1
           from dba_data_files
          group by tablespace_name) a,
        (select tablespace_name TS2,
                sum(bytes) SUM_B2,
                max(bytes) MAX_B2,
                count(bytes) CNT_B2
           from dba_free_space
          group by tablespace_name) b
  WHERE a.TS1 = b.TS2(+)
 order by 1 DESC;