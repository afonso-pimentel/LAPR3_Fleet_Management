DECLARE
  vReturnCursorShow SYS_REFCURSOR;
  vAction CARGOMANIFESTTYPE.DESCRIPTION%TYPE;
  vOperationLocal CARGOSITE.NAME%TYPE;
  vOperationDate CARGOMANIFEST.DATEFINISH%TYPE;
  vTranportType TRANSPORTTYPE.DESCRIPTION%TYPE;
BEGIN
  Get_Container_Route(1,1, vReturnCursorShow);

  DBMS_OUTPUT.PUT_LINE('TranportType' || ' | ' ||'Action' || ' | '  || RPAD('OperationDate',19) || ' | ' || 'OperationLocal');

  LOOP
    FETCH vReturnCursorShow INTO vAction, vOperationLocal, vOperationDate, vTranportType;
    EXIT WHEN vReturnCursorShow%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(RPAD(vTranportType,12) || ' | ' || RPAD(vAction,6) || ' | '  || TO_CHAR(vOperationDate, 'MM/DD/YYYY HH24:MI:SS') ||  ' | ' || vOperationLocal );
  END LOOP;

  CLOSE vReturnCursorShow;
END;