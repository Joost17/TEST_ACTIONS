-- Delft-FEWS
-- ================================================================
--
-- Software Info: http://www.delft-fews.com
-- Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
--
-- (C) Copyright 2008, by Deltares
--                        P.O. Box 177
--                        2600 MH  Delft
--                        The Netherlands
--                        http://www.deltares.nl
--
-- DELFT-FEWS: A platform for real time forecasting and water
-- resources management. Delft-FEWS is expert data handling and
-- model integration software for flood forecasting, drought and
-- seasonal forecasting, and real-time water resources management.
--
-- ----------------------------------------------------------------
-- clonedb_import.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares
--
DEFINE username = &1
DEFINE password = &2

CONNECT &username/&password

-- Input parameters:

SET serveroutput ON
DECLARE
   v_counter int;
BEGIN
  SELECT COUNT(*) INTO v_counter FROM user_tables WHERE UPPER(table_name)='TIMESERIESTABLE';
  IF v_counter > 0 THEN
    EXECUTE IMMEDIATE 'DROP TRIGGER &username..TRG_TIMESERIES_INS';
    EXECUTE IMMEDIATE 'DROP TRIGGER &username..TRG_SAMPLES_INS';
    EXECUTE IMMEDIATE 'DROP TRIGGER &username..TRG_VERSIONMANAGEMENT_INS';
    EXECUTE IMMEDIATE 'CREATE TRIGGER &username..TRG_VERSIONMANAGEMENT_INS BEFORE INSERT ON &username..VersionManagement FOR EACH ROW BEGIN SELECT &username..SEQ_VERSIONMANAGEMENT_ENTRYID.NEXTVAL INTO :NEW.entryId FROM dual; END; /';
    EXECUTE IMMEDIATE 'CREATE TRIGGER &username..TRG_SAMPLES_INS BEFORE INSERT ON &username..Samples FOR EACH ROW BEGIN SELECT &username..SEQ_SAMPLES_LOCALINTID.NEXTVAL INTO :NEW.localIntId FROM dual; END; /';
    EXECUTE IMMEDIATE 'CREATE TRIGGER &username..TRG_TIMESERIES_INS BEFORE INSERT ON &username..TimeSeriesTable FOR EACH ROW BEGIN SELECT &username..SEQ_TIMESERIES_LOCALINTID.NEXTVAL INTO :NEW.localIntId FROM dual; END;/';
  END IF;
END;
/

EXIT