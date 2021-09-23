SQL> -- Create table
SQL> create table t4a (c1 int) tablespace ts4;

Table created.

SQL> -- Populate table
SQL> begin
  2    for i in 1..1000 loop
  3      insert into t4a values(i);
  4    end loop;
  5    commit;
  6  end;
  7  /

PL/SQL procedure successfully completed.

