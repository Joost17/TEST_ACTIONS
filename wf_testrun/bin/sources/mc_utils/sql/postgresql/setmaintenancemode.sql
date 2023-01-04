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
-- Description:
-- Activates / deactivates maintenance mode.
-- Invocation  : psql -f setmaintenancemode.sql -d $1 -v database=$2 -v user=$2 -v schema=$2 -v maintenancemode=1
--or
-- Invocation  : psql -f setmaintenancemode.sql -d $1 -v database=$2 -v user=$2 -v schema=$2 -v maintenancemode=0
-- Arguments   : $1 - Database instance
--               $2 - fews user
--               $3 - maintenancemode 1 or 0
-- Return      : none
-- Variables   : none
--


-- Input parameters:

\set quotedSchema '\'' :schema '\''
\set quotedMaintenanceMode '\'' :maintenancemode '\''

CREATE OR REPLACE FUNCTION SET_MAINTENANCEMODE(p_schema VARCHAR(64), p_maintenancemode VARCHAR(64)) RETURNS VOID AS $$
DECLARE
  v_maintenanceRunning INTEGER := 0;
  v_maintenanceRunning_option INTEGER := 0;
BEGIN
  EXECUTE format('SELECT maintenanceRunning FROM %I.DatabaseSchemaInfo WHERE singleRowKey=0', p_schema) INTO v_maintenanceRunning;
  SELECT CASE WHEN UPPER(p_maintenancemode) IN ('1', 'TRUE', 'ON', 'Y', 'YES') THEN 1 ELSE 0 END INTO v_maintenanceRunning_option;
  IF (v_maintenanceRunning = v_maintenanceRunning_option) THEN
    IF (v_maintenanceRunning = 1) THEN
      RAISE NOTICE 'no action required, maintenancemode already on';
    ELSE
      RAISE NOTICE 'no action required, maintenancemode already off';
    END IF;
    RETURN;
  ELSE
    EXECUTE format('UPDATE %I.DatabaseSchemaInfo SET maintenanceRunning=%s, modificationTime=CURRENT_TIMESTAMP AT TIME ZONE ''GMT'', localModificationTime=CURRENT_TIMESTAMP AT TIME ZONE ''GMT'' WHERE singleRowKey=0', p_schema, v_maintenanceRunning_option);
    EXECUTE format('UPDATE %I.TableLocalModificationTimes SET modificationTime=CURRENT_TIMESTAMP AT TIME ZONE ''GMT'', localModificationTime=CURRENT_TIMESTAMP AT TIME ZONE ''GMT''', p_schema);
  END IF;
  EXECUTE format('SELECT maintenanceRunning FROM %I.DatabaseSchemaInfo WHERE singleRowKey=0', p_schema) INTO v_maintenanceRunning;
  IF (v_maintenanceRunning = 1) THEN
    RAISE NOTICE 'maintenancemode on';
  ELSE
    RAISE NOTICE 'maintenancemode off';
  END IF;
  RETURN;
END; $$
LANGUAGE plpgsql;

SELECT SET_MAINTENANCEMODE(CAST (:quotedSchema AS VARCHAR(64)), CAST (:quotedMaintenanceMode AS VARCHAR(64)));
DROP FUNCTION SET_MAINTENANCEMODE(p_schema VARCHAR(64), p_maintenancemode VARCHAR(64));
