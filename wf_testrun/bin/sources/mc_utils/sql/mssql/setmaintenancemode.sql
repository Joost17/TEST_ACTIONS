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
-- (C) Copyright 2019, by Deltares

-- maintenance mode activation and deactivation script for SqlServer 2012 and higher before running data_update.

DECLARE @v_maintenanceRunning INTEGER;
SET @v_maintenanceRunning=(SELECT maintenanceRunning FROM $(schema).DatabaseSchemaInfo WHERE singleRowKey=0);
DECLARE @v_maintenanceRunning_option INTEGER;
SET @v_maintenanceRunning_option=(SELECT CASE WHEN UPPER($(maintenancemode)) IN ('1', 'TRUE', 'ON', 'Y', 'YES') THEN 1 ELSE 0 END);

IF (@v_maintenanceRunning = @v_maintenanceRunning_option)
BEGIN
  IF (@v_maintenanceRunning = 1)
    PRINT N'no action required, maintenancemode already on';
  ELSE
      PRINT N'no action required, maintenancemode already off';
END
ELSE
BEGIN
  UPDATE $(schema).DatabaseSchemaInfo SET maintenanceRunning=@v_maintenanceRunning_option, modificationTime=GETUTCDATE(), localModificationTime=GETUTCDATE()
  WHERE singleRowKey=0;
  UPDATE $(schema).TableLocalModificationTimes SET localModificationTime=GETUTCDATE(), modificationTime=GETUTCDATE();
  SET @v_maintenanceRunning=(SELECT maintenanceRunning FROM $(schema).DatabaseSchemaInfo WHERE singleRowKey=0);
  IF (@v_maintenanceRunning = 1)
    PRINT N'maintenancemode on';
  ELSE
    PRINT N'maintenancemode off';
END
