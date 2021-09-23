CREATE OR REPLACE FUNCTION FNC_IS_NUMBER
  (  P_VALOR VARCHAR2)
  RETURN Boolean IS 
    V_VALOR NUMBER;      
BEGIN 
    V_VALOR := P_VALOR;
    REturn True;
    Exception
    When Others Then
        Return False;
END;
/
