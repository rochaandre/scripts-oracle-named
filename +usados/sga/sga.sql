set serveroutput on
set feedback off linesize 120

declare
Buffer_Hit_Ratio  	  number := null;
Data_Dictionary_Hit_Ratio number := null;
Pin_Hit_Ratio 		  number := null;
Rel_Hit_Ratio 		  number := null;

begin

select round (((1 - (sum(decode(name, 'physical reads', value, 0)) / 
(sum(decode(name, 'db block gets', value, 0)) +
sum(decode(name, 'consistent gets', value, 0))))) *
100), 2) into Buffer_Hit_Ratio
from v$sysstat;

select round (((1 - (sum(getmisses)/(sum(gets) + 
sum(getmisses)))) * 100), 2) into Data_Dictionary_Hit_Ratio
from v$rowcache;

select round (((sum(pinhits)/sum(pins)) * 100), 2) into Pin_Hit_Ratio
from v$librarycache;

select round (((sum(pins)/(sum(pins) + sum(reloads))) * 100), 2) into Rel_Hit_Ratio
from v$librarycache;


dbms_output.put_line('---------------- Estatisticas SGA -----------------');
dbms_output.put_line('------- Pct. de acerto da busta em Memória --------');
dbms_output.put_line('.');
dbms_output.put_line('.     Buffer        Dicionário de Dados   Objeto Pl/SQL (Memória Pin)   Objetos Pl/SQL (Memória Reload) ');
dbms_output.put_line('. 95% ou superior        95% a 99%              95% ou superior                99% ou superior          ');
dbms_output.put_line('.--------------------------------------------------------------------------------------------------------');
dbms_output.put_line('.      '||lpad(Buffer_Hit_Ratio,5)||lpad(Data_Dictionary_Hit_Ratio,20)||lpad(Pin_Hit_Ratio,26)||lpad(Rel_Hit_Ratio,32));
dbms_application_info.set_action('teste');
end;
/

