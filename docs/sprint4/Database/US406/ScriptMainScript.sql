-- MAIN PROCEDURE FOR US406
CREATE OR REPLACE FUNCTION US406 RETURN SYS_REFCURSOR
IS
RETURN_CURSOR  SYS_REFCURSOR;
SQL_INSERT_INTO_TEMPORARY_TABLE_STATEMENT varchar2(200) := 'INSERT INTO oraptt_tmp VALUES(:mmsi, :destination, :departure, :startdate, :enddate, :occupancyrate)';
SQL_SELECT_TEMPORARY_TABLE_STATEMENT VARCHAR2(1000) := 'SELECT * FROM oraptt_tmp';
SQL_CREATE_TEMPORARY_TABLE_STATEMENT VARCHAR2(1000) := 'CREATE GLOBAL TEMPORARY TABLE oraptt_tmp (SHIP_MMSI NUMBER, DESTINATION_CARGOSITE VARCHAR2(50), DEPARTURE_CARGOSITE VARCHAR2(50), DATE_START DATE, DATE_FINISH DATE, OCCUPANCY_RATE DECIMAL)';
SQL_DELETE_TEMPORARY_TABLE_DATA_STATEMENT VARCHAR2(200) := 'DELETE FROM oraptt_tmp WHERE 1 = 1';
CARGOMANIFESTS_CURSOR  SYS_REFCURSOR;
SHIP_MMSI SHIP.MMSI%type;
DESTINATION_CARGOSITE CARGOSITE.NAME%type;
DEPARTURE_CARGOSITE CARGOSITE.NAME%type;
DATE_START CARGOMANIFEST.DATESTART%type;
DATE_FINISH CARGOMANIFEST.DATEFINISH%type;
AVERAGE_OCCUPANCY_RATE DECIMAL;
MIN_DATE DATE := TO_DATE('01/01/1900', 'DD/MM/YYYY');
BEGIN
     -- CREATE A TEMPORARY TABLE TO HOLD DATA FOR US406 IF IT DOES NOT EXISTS
    IF NOT VERIFY_GLOBAL_TEMPORARY_TABLE_EXISTS('ORAPTT_TMP')  THEN
        EXECUTE IMMEDIATE SQL_CREATE_TEMPORARY_TABLE_STATEMENT;
    ELSE
        EXECUTE IMMEDIATE SQL_DELETE_TEMPORARY_TABLE_DATA_STATEMENT;
    END IF;


     -- GET ALL THE CARGOMANIFEST'S FOR ALL FINISHED TRIP'S
    CARGOMANIFESTS_CURSOR := GET_ALL_FINISHEDTRIPS();

      LOOP
        FETCH CARGOMANIFESTS_CURSOR INTO SHIP_MMSI, DESTINATION_CARGOSITE, DEPARTURE_CARGOSITE, DATE_START, DATE_FINISH;

        -- REUSE US405 TO CALCULATE AVERAGE OCCUPANCY RATE
        AVERAGE_OCCUPANCY_RATE := US405(SHIP_MMSI, MIN_DATE, DATE_FINISH);

        EXIT WHEN CARGOMANIFESTS_CURSOR%NOTFOUND;

        -- IF AVERAGE_OCCUPANCY_RATE IS BELLOW THE 66% THRESHOLD
          IF AVERAGE_OCCUPANCY_RATE < 66 THEN

                -- INSERT CURRENT RECORD INTO THE TEMPORARY TABLE
                EXECUTE IMMEDIATE SQL_INSERT_INTO_TEMPORARY_TABLE_STATEMENT
                USING SHIP_MMSI, DEPARTURE_CARGOSITE, DESTINATION_CARGOSITE, DATE_START, DATE_FINISH, AVERAGE_OCCUPANCY_RATE;
          END IF;

        END LOOP;

      CLOSE CARGOMANIFESTS_CURSOR;

    -- INSERT TEMPORARY TABLE DATA INTO A CURSOR TO BE RETURNED
    OPEN RETURN_CURSOR FOR SQL_SELECT_TEMPORARY_TABLE_STATEMENT;

    RETURN RETURN_CURSOR;
END;
