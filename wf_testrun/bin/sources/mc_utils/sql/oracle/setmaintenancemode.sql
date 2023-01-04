
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
-- setmaintenancemode.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares
--
-- Description:
-- maintenance mode activation and deactivation script for Oracle 12c and higher before running data_update.

--exit when version check fails
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

SET SERVEROUTPUT ON

--Usage:
--
-- Activate maintenance mode:
--    @setmaintenancemode <schema> 1
--
-- Deactivate maintenance mode:
--    @setmaintenancemode <schema> 0

DEFINE username=&1
DEFINE maintenancemode=&2

DECLARE
  v_maintenanceRunning INTEGER;
  v_maintenanceRunning_option INTEGER;
BEGIN
  SELECT maintenanceRunning INTO v_maintenanceRunning FROM &username..DatabaseSchemaInfo WHERE singleRowKey=0;
  SELECT CASE WHEN UPPER(&maintenancemode.) IN ('1', 'TRUE', 'ON', 'Y', 'YES') THEN 1 ELSE 0 END INTO v_maintenanceRunning_option FROM DUAL;
  IF (v_maintenanceRunning = v_maintenanceRunning_option) THEN
      IF (v_maintenanceRunning = 1) THEN
        dbms_output.put_line('no action required, maintenancemode already on');
      ELSE
        dbms_output.put_line('no action required, maintenancemode already off');
      END IF;
      RETURN;
  ELSE 
    UPDATE &username..DatabaseSchemaInfo SET maintenanceRunning=v_maintenanceRunning_option,
       modificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT', localModificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT'
    WHERE singleRowKey=0;
    UPDATE &username..TableLocalModificationTimes SET localModificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT', modificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT';
  END IF;
  SELECT maintenanceRunning INTO v_maintenanceRunning FROM &username..DatabaseSchemaInfo WHERE singleRowKey=0;
  IF (v_maintenanceRunning = 1) THEN
    dbms_output.put_line('maintenancemode on');
  ELSE
    dbms_output.put_line('maintenancemode off');
  END IF;
END;
/

COMMIT;