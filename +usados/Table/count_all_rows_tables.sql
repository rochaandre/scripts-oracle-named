declare
 --
 --  Anonymous pl/sql code to count rows in tables of interest for v8.1+
 --
 --  basic logic
 --    create list of target tables (cursor)
 --    while more tables in list
 --      dynamically generate select count
 --      print or store results
 -- ---------------------------------------------------------------------
 --
 -- 20010807  Mark D Powell   Skeleton for capturing table counts
 --
 v_ct       number        := 0 ;
 v_sqlcode  number        := 0 ;
 v_stmt     varchar2(120)       ;

 --
 --         modify cursor select for tables of interest, order by.
 --

 cursor c_tbl is
   select owner, table_name
   from   sys.dba_tables
   where  owner = 'LF'
   and    rownum >= 0;
--
r_tbl      c_tbl%rowtype;
 --
 begin
 open c_tbl;
 loop
   fetch c_tbl into r_tbl;
   exit when c_tbl%notfound;
   v_stmt := 'select /*+ full(tabela) parallel (tabela,4) */ count(*) from '||r_tbl.owner||'.'||r_tbl.table_name || ' tabela' ;
   execute immediate v_stmt into v_ct;
   v_sqlcode := SQLCODE;
     insert into dbadmin.tb1 values
     (r_tbl.owner,r_tbl.table_name,v_ct);
     commit;


---   if v_sqlcode = 0
---        An insert into a row count history table should probably be here
---      then dbms_output.put_line('Table '||r_tbl.owner||'.'||
---                                 rpad(r_tbl.table_name,30)||
---                                ' count is '||to_char(v_ct,'999999999990')
---                              );
---      else dbms_output.put_line('Bad return code'||v_sqlcode||
---                                ' on select of '||r_tbl.owner||
---                                '.'||r_tbl.table_name
---                               );
---   end if;
 end loop;
 close c_tbl;
 end;
/