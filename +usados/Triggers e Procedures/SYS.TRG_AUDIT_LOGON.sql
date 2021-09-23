CREATE OR REPLACE TRIGGER "SYS"."TRG_AUDIT_LOGON" AFTER
LOGON ON DATABASE begin
  declare
	v_username		audit_logon.USERNAME%TYPE;
	v_terminal		audit_logon.TERMINAL%TYPE;
	v_program		audit_logon.PROGRAM%TYPE;
	v_module		audit_logon.MODULE%TYPE;
	v_osuser		audit_logon.OSUSER%TYPE;
	v_MysessionID	NUMBER;

	cursor cs_Rec is
	select OSUSER,PROGRAM,MODULE
	from v$session
	where AUDSID= (v_MysessionID);

  begin
	select NVL(USER,'INTERNAL')         into v_username from dual;
	select USERENV('TERMINAL')          into v_terminal from dual;
	select NVL(USERENV('SESSIONID'),0)  into v_MysessionID from dual;

	If not (cs_Rec%ISOPEN) then
	  open cs_Rec;
	end if;
	fetch cs_Rec into v_osuser,v_program,v_module;

	if v_username = 'INTERNAL'  or v_MYsessionID = 0 then
	  v_program := 'INTERNAL';
	end if;

	if

	   (v_username     in ('SYS','SYSTEM','INTERNAL','DBSNMP','SCHED','DBADMIN','QUEST','FOGLIGHT') and
	    v_terminal not in ('ORAXP','VLL27877','VLL20572','VLL20568'))

	    or

	    v_osuser not in ('iaserver','sgoulart','Administrator','abarcelos','wwai')

	   then

	   insert into SYS.AUDIT_LOGON(USERNAME,TERMINAL,PROGRAM,MODULE,LOGON_TIME,OSUSER)
	   values (v_username,v_terminal,v_program,v_module,sysdate,v_osuser);

	end if;
	close cs_Rec;
	end;
  end;