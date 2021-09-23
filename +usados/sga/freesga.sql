--Free shared pool 
/* SGA Info:v$sgastat 
      How the memory has been divided among SGA activities
      free memory,library cache,dictionary cache,sql area,db buffers,log buffers,
      processes,enqueues,fixed SGA size etc. */

-- Free DB Buffers
/* Free DB Buffers , find whether Set too high. Connect as sys */

set feedback off linesize 80

select pool,name,bytes/(1024*1024) "Free mem(M)" from v$sgastat
where name = 'free memory';

select decode(state,0,'Free',
                    1,'Read and Modified',
                    2,'Read and Not Modified',
                    3,'Currently Being Read','Other') DB_Buffers,count(*)
from x$bh
group by decode(state,0,'Free',
                    1,'Read and Modified',
                    2,'Read and Not Modified',
                    3,'Currently Being Read','Other');
