DECLARE
  vReturnCursorShow SYS_REFCURSOR;
  vId CARGOSITE.ID%TYPE;
  vName CARGOSITE.NAME%TYPE;
  vOccupancyRate NUMBER;
  vNumberOfLeavingContainers NUMBER;
BEGIN
  Get_OccupancyRate_EstimatedContainersLeaving_CargoSite(vReturnCursorShow);

  DBMS_OUTPUT.PUT_LINE('ID  ' || ' | '  || 'Ocup Rate' || ' | ' || 'Nº Cont' || ' | ' || 'Name');

  LOOP
    FETCH vReturnCursorShow INTO vId, vName, vOccupancyRate, vNumberOfLeavingContainers;
    EXIT WHEN vReturnCursorShow%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(LPAD(TO_CHAR(vId),4)  || ' | '  || LPAD(TO_CHAR(vOccupancyRate),8) ||  '% | ' || RPAD(TO_CHAR(vNumberOfLeavingContainers),7) || ' | ' || vName);
  END LOOP;

  CLOSE vReturnCursorShow;
END;