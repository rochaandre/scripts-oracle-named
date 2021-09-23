select time,count(*)
from dbadmin.crescimento_database
group by time
having to_char(time,'dd/mm/yy')like '%/06/05'
/