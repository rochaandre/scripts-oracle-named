CREATE OR REPLACE  PROCEDURE 
    "DBADMIN"."SP_GERA_RELATORIO_CRESCIMENTO"               
    "SP_GERA_RELATORIO_CRESCIMENTO" (
v_data_rel in date,
v_data_ini in date,
v_data_fim in date)
is

intHandle     utl_file.file_type;

/* Variaveis para o cabecalho do relatorio */
v_data_emissao		date;
v_nomeDB		varchar2(10);


/* Variaveis para o relatorio por Tablespace */
a_tablespace_name	varchar2(30);
a_bytes			number;
a_bytes_free		number;
a_bytes_free_pct	number;
a_bytes_used		number;
a_bytes_used_pct	number;


/* Variaveis para o relatorio por Datafile */
b_datafile_name		varchar2(257);
b_tablespace_name	varchar2(30);
b_bytes			number;
b_bytes_free		number;
b_bytes_free_pct	number;
b_bytes_used		number;
b_bytes_used_pct	number;


/* Variaveis para relatorio crescimento por Tablespace */
c_tablespace_name	varchar2(30);
c_bytes			number;


/* Variaveis para relatorio crescimento por Datafile */
d_datafile_name	        varchar2(257);
d_bytes			number;


cursor cs_tablespace is
select tablespace_name,						/* Nome da Tablespace                */
       sum(bytes)/1024 /1024,					/* Total de Bytes da Tablespace      */
       sum(free_bytes)/1024 /1024,				/* Total de Bytes Free da Tablespace */
       (sum(free_bytes)/sum(bytes))*100,			/* % Free da Tablespace              */
       ((sum(bytes)-sum(free_bytes)))/1024 /1024,		/* Total de Bytes Used da Tablespace */
       ((sum(bytes)-sum(free_bytes))/sum(bytes))*100		/* % Used da Tablespace              */
from crescimento_database
where trunc(time) = v_data_rel
group by trunc(time),tablespace_name
order by tablespace_name;


cursor cs_datafile is
select datafile_name,						/* Nome do Datafile                  */
       tablespace_name,						/* Nome da Tablespace                */
       bytes/1024 /1024,				        /* Total de Bytes do Datafile        */
       free_bytes/1024 /1024,                                   /* Total de Bytes Free do Datafile   */
       (free_bytes/bytes)*100,                                  /* % Free do Datafile                */
       (bytes-free_bytes)/1024 /1024,                           /* Total de Bytes Used do Datafile   */
       ((bytes-free_bytes)/bytes)*100                           /* % Used do Datafile                */
from crescimento_database
where trunc(time) = v_data_rel
order by datafile_name;


cursor cs_cres_tablespace is
select a.tablespace_name,                                        /* Nome da Tablespace                     */
       sum(b.bytes)-sum(a.bytes)                                 /* Diferenca entre Data Inicio e Data Fim */
from crescimento_database a, crescimento_database b
where a.tablespace_name = b.tablespace_name
and trunc(a.time) = v_data_ini
and trunc(b.time) = v_data_fim
group by a.tablespace_name
order by a.tablespace_name;


cursor cs_cres_datafile is
select a.datafile_name,                                          /* Nome do Datafile                       */
       b.bytes-a.bytes                                           /* Diferenca entre Data Inicio e Data Fim */
from crescimento_database a, crescimento_database b
where a.datafile_name = b.datafile_name
and trunc(a.time) = v_data_ini
and trunc(b.time) = v_data_fim
order by a.datafile_name;


begin

  intHandle := utl_file.fopen('/tmp', 'Growth_Database.htm', 'w');
  select name into v_nomeDB from v$database;
  select sysdate into v_data_emissao from dual;

  utl_file.put_line(intHandle,'<html>');
  utl_file.put_line(intHandle,'');
  utl_file.put_line(intHandle,'<head>');
  utl_file.put_line(intHandle,'<meta http-equiv="Content-Language" content="en-us">');
  utl_file.put_line(intHandle,'<meta name="GENERATOR" content="Microsoft FrontPage 5.0">');
  utl_file.put_line(intHandle,'<meta name="ProgId" content="FrontPage.Editor.Document">');
  utl_file.put_line(intHandle,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
  utl_file.put_line(intHandle,'<title>Nova pagina 2</title>');
  utl_file.put_line(intHandle,'</head>');
  utl_file.put_line(intHandle,'');
  utl_file.put_line(intHandle,'<body>');
  utl_file.put_line(intHandle,'');
  utl_file.put_line(intHandle,'<H2>;</H2>');
  utl_file.put_line(intHandle,'<p><font size="7"><b>Growth of Database</b> </font><font size="4">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; </font><font size="6">;</font> Date: ' || to_char(v_data_emissao,'MON-DD-yyyy') || ' </H2>');
  utl_file.put_line(intHandle,'<hr>');
  utl_file.put_line(intHandle,'<H2>Target:</H2>');
  utl_file.put_line(intHandle,'<p>;;;;<B>' || v_nomeDB || '</B></p>');
  utl_file.put_line(intHandle,'<p><BR>');
  utl_file.put_line(intHandle,'</p>');
  utl_file.put_line(intHandle,'<H1>Table of Contents</H1>');
  utl_file.put_line(intHandle,'<p>;;;;<a href="#2">Tablespace</a><BR>');
  utl_file.put_line(intHandle,';;;;<a href="#3">Datafile</a><BR>');
  utl_file.put_line(intHandle,';;;;<a href="#4">Growth per Tablespace</a><BR>');
  utl_file.put_line(intHandle,';;;;<a href="#5">Growth per Datafile</a><BR>');
  utl_file.put_line(intHandle,'<BR></p>');
  utl_file.put_line(intHandle,'<H2>Tablespace</H2><TABLE BORDER="1" SUMMARY="Tablespace"><TR>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>TABLESPACE</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>SIZE(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>FREE(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>FREE(%)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>USED(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>USED(%)</FONT></B></TH>');
  utl_file.put_line(intHandle,'</TR>');
  Open cs_tablespace;
  Loop
  Fetch cs_tablespace into a_tablespace_name,a_bytes,a_bytes_free,a_bytes_free_pct,a_bytes_used,a_bytes_used_pct;
    Exit when cs_tablespace%NOTFOUND;
    utl_file.put_line(intHandle,'<TR>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="left"><FONT FACE="SANSSERIF" SIZE=2>' || a_tablespace_name         || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(a_bytes,0)          || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(a_bytes_free,0)     || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(a_bytes_free_pct,2) || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(a_bytes_used,0)     || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(a_bytes_used_pct,2) || '</FONT></TD>');
    utl_file.put_line(intHandle,'</TR>');
  end loop;
  utl_file.put_line(intHandle,'</TABLE>');
  utl_file.put_line(intHandle,'<A NAME="3"></A>');
  utl_file.put_line(intHandle,'<H2>Datafile</H2><TABLE BORDER="1" SUMMARY="Datafile"><TR>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>DATAFILE</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>TABLESPACE</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>SIZE(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>FREE(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>FREE(%)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>USED(Mb)</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>USED(%)</FONT></B></TH>');
  utl_file.put_line(intHandle,'</TR>');
  Open cs_datafile;
  Loop
  Fetch cs_datafile into b_datafile_name,b_tablespace_name,b_bytes,b_bytes_free,b_bytes_free_pct,b_bytes_used,b_bytes_used_pct;
    Exit when cs_datafile%NOTFOUND;
    utl_file.put_line(intHandle,'');
    utl_file.put_line(intHandle,'<TR>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="left"><FONT FACE="SANSSERIF" SIZE=2>' || b_datafile_name           || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="left"><FONT FACE="SANSSERIF" SIZE=2>' || b_tablespace_name         || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(b_bytes,0)          || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(b_bytes_free,0)     || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(b_bytes_free_pct,2) || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(b_bytes_used,0)     || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(b_bytes_used_pct,2) || '</FONT></TD>');
    utl_file.put_line(intHandle,'</TR>');
    utl_file.put_line(intHandle,'');
  end loop;
  utl_file.put_line(intHandle,'</TABLE>');
  utl_file.put_line(intHandle,'<A NAME="4"></A>');
  utl_file.put_line(intHandle,'<H2>Growth per Tablespace</H2><TABLE BORDER="1" SUMMARY="Growth per Tablespace"><TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>TABLESPACE_NAME</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>Size(Bytes)</FONT></B></TH>');
  utl_file.put_line(intHandle,'');
  Open cs_cres_tablespace;
  Loop
  Fetch cs_cres_tablespace into c_tablespace_name,c_bytes;
    Exit when cs_cres_tablespace%NOTFOUND;
    utl_file.put_line(intHandle,'<TR>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="left"><FONT FACE="SANSSERIF" SIZE=2>' || c_tablespace_name || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(c_bytes,2)  || '</FONT></TD>');
    utl_file.put_line(intHandle,'</TR>');
    utl_file.put_line(intHandle,'');
  end loop;
  utl_file.put_line(intHandle,'</TABLE>');
  utl_file.put_line(intHandle,'<A NAME="5"></A>');
  utl_file.put_line(intHandle,'<H2>Growth per Datafile</H2><TABLE BORDER="1" SUMMARY="Growth per Datafile"><TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>DATAFILE_NAME</FONT></B></TH>');
  utl_file.put_line(intHandle,'<TH scope="col" BGCOLOR=#cccc99><B><FONT FACE="SANSSERIF" COLOR="#336699" SIZE=2>Size(Bytes)</FONT></B></TH>');
  utl_file.put_line(intHandle,'');
  Open cs_cres_datafile;
  Loop
  Fetch cs_cres_datafile into d_datafile_name,d_bytes;
    Exit when cs_cres_datafile%NOTFOUND;
    utl_file.put_line(intHandle,'<TR>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="left"><FONT FACE="SANSSERIF" SIZE=2>' || d_datafile_name || '</FONT></TD>');
    utl_file.put_line(intHandle,'<TD BGCOLOR=#f7f7e7><p align="right"><FONT FACE="SANSSERIF" SIZE=2>' || round(d_bytes,2)|| '</FONT></TD>');
    utl_file.put_line(intHandle,'</TR>');
    utl_file.put_line(intHandle,'');
  end loop;
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'<P>');
  utl_file.put_line(intHandle,'</table>');
  utl_file.put_line(intHandle,'<p align="right">end of report</p> ');
  utl_file.put_line(intHandle,'<hr> ');
  utl_file.put_line(intHandle,'<p align="left" style="margin-bottom: -18">Sérgio A. Goulart</p> ');
  utl_file.put_line(intHandle,'<p align="left" style="margin-bottom: -18">Oracle DBA</p> ');
  utl_file.put_line(intHandle,'</body>');


  utl_file.fclose(intHandle);
end sp_gera_relatorio_crescimento;