-- Delft-FEWS
-- ================================================================
--
-- Software Info: http://www.delft-fews.com
-- Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
--
-- (C) Copyright 2019, by Deltares
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
-- data_update.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2019, by Deltares
--
-- Data_update script for SQLServer 2012 and higher for migrating the Delft-FEWS database schema (tables and views).
-- Migrates to version v2021.01_20200415_1 from v2020.02_20201026_1.
--

DECLARE @maintenanceRunning INTEGER;
SET @maintenanceRunning=(SELECT maintenanceRunning FROM $(strschema).DatabaseSchemaInfo WHERE singleRowKey=0);

IF (@maintenanceRunning <> 1)
BEGIN
  PRINT 'Fatal error: Maintenance mode required. Please first activate maintenance mode before using the data_update script.';
  SET NOEXEC ON
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('DropColumnDefaultConstraint') AND type in (N'P', N'PC'))
DROP PROCEDURE $(strschema).DropColumnDefaultConstraint
GO
CREATE PROCEDURE $(strschema).DropColumnDefaultConstraint @schemaName varchar(30), @tableName varchar(30), @columnName varchar(30) AS
BEGIN
  DECLARE @ConstraintName varchar(30);
  SELECT @ConstraintName=sdc.name
  FROM sys.default_constraints sdc, sys.columns c, sys.schemas s
  WHERE sdc.parent_object_id = c.object_id AND sdc.parent_column_id = c.column_id
    AND sdc.schema_id=s.schema_id AND s.name=@schemaName AND sdc.parent_object_id = OBJECT_ID(@tableName, N'U') AND c.name = @columnName;

  IF @ConstraintName IS NOT NULL
      BEGIN
        EXEC('ALTER TABLE ' + @schemaName + '.' + @tableName + ' DROP CONSTRAINT ' + @ConstraintName)
        PRINT 'Dropped default constraint ' + @ConstraintName + ' FOR ' + @schemaName + '.' + @tableName + '.' + @columnName;
      END
  ELSE
    PRINT 'No default constraint found that could be dropped for column ' + @columnName + ' in ' + @schemaName + '.' + @tableName;
END
GO

PRINT 'L001';
GO
DROP VIEW $(strschema).WarmStatesSizes;
GO
PRINT 'L002';
GO
DROP VIEW $(strschema).TimeSeriesSizes;
GO
PRINT 'L003';
GO
DROP VIEW $(strschema).GlobalRowIds;
GO
PRINT 'L004';
GO
DROP VIEW $(strschema).Dual;
GO
PRINT 'L005';
GO
ALTER TABLE $(strschema).FssStatus ADD workflowNodeIndex INTEGER CONSTRAINT DEF_FssStatNodeInde DEFAULT '0' NOT NULL;
GO
PRINT 'L006';
GO
ALTER TABLE $(strschema).FssStatus ADD progressPercentage NUMERIC(2) CONSTRAINT DEF_FssStatPerc DEFAULT '0' NOT NULL;
GO
PRINT 'L007';
GO
ALTER TABLE $(strschema).Tasks ADD lastCompletedTaskRunId VARCHAR(64);
GO
PRINT 'L008';
GO
ALTER TABLE $(strschema).Tasks ADD lastCompletedDurationMillis BIGINT CONSTRAINT DEF_TaskCompDuraMill DEFAULT '0' NOT NULL;
GO
PRINT 'L009';
GO
ALTER TABLE $(strschema).TaskRuns ADD timeZero DATETIME2(3);
GO
PRINT 'L010';
GO
ALTER TABLE $(strschema).ModuleInstanceRuns ADD runStatus NUMERIC(2) CONSTRAINT DEF_ModuInstRunsStat DEFAULT '0' NOT NULL;
GO
PRINT 'L011';
GO
CREATE TABLE $(strschema).ModuleRunTimes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  workflowId VARCHAR(64) NOT NULL,
  moduleInstanceId VARCHAR(64) NOT NULL,
  pendingDurationMillis BIGINT NOT NULL,
  runDurationMillis BIGINT NOT NULL,
  minPartition INTEGER NOT NULL,
  maxPartition INTEGER NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuleRunTimes_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleRunTimes PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_ModuleRunTimes_id UNIQUE(globalRowId)
);
GO
PRINT 'L012';
GO
CREATE INDEX IDX_ModuleRunTimes_lmt ON $(strschema).ModuleRunTimes(localModificationTime);
GO
PRINT 'L013';
GO
CREATE INDEX IDX_ModuleRunTimes_workflowId_ ON $(strschema).ModuleRunTimes(workflowId, moduleInstanceId);
GO
DROP PROCEDURE $(strschema).DropColumnDefaultConstraint;
GO

CREATE FUNCTION $(strschema).Mod (@a BIGINT, @n INT) RETURNS BIGINT WITH EXECUTE AS CALLER AS BEGIN RETURN @a%@n; END
GO
CREATE VIEW $(strschema).Dual AS SELECT 1 AS X
GO
CREATE VIEW $(strschema).WarmStatesSizes AS  SELECT moduleInstanceId, SUM(datalength(blob)/1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, MAX(CAST(DATEDIFF(minute,creationTime,expiryTime) AS BIGINT))*60 AS maxExpiryDurationInSec FROM WarmStates GROUP BY moduleInstanceId;
GO
CREATE VIEW $(strschema).TimeSeriesSizes AS SELECT moduleInstanceId, SUM(datalength(blob)/1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, MAX(CAST(DATEDIFF(minute,creationTime,expiryTime) AS BIGINT))*60 AS maxExpiryDurationInSec FROM TimeSeries GROUP BY moduleInstanceId;
GO
CREATE VIEW $(strschema).GlobalRowIds AS
  SELECT 'AccessKeyHashes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM AccessKeyHashes UNION
  SELECT 'ActionConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ActionConfigurations UNION
  SELECT 'AiServletUsers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM AiServletUsers UNION
  SELECT 'ArchiveMetaData' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ArchiveMetaData UNION
  SELECT 'AttributeModifiers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM AttributeModifiers UNION
  SELECT 'BaseBuildFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM BaseBuildFiles UNION
  SELECT 'BaseBuildFileSets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM BaseBuildFileSets UNION
  SELECT 'CMConfigFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM CMConfigFiles UNION
  SELECT 'CoefficientSets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM CoefficientSets UNION
  SELECT 'ColdStates' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ColdStates UNION
  SELECT 'ComponentLogFileSnapshots' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ComponentLogFileSnapshots UNION
  SELECT 'ConfigRevisionSets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ConfigRevisionSets UNION
  SELECT 'CorrelationEventSets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM CorrelationEventSets UNION
  SELECT 'CorrelationTravelTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM CorrelationTravelTimes UNION
  SELECT 'DatabaseSchemaInfo' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM DatabaseSchemaInfo UNION
  SELECT 'DeletedRows' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM DeletedRows UNION
  SELECT 'DisplayConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM DisplayConfigurations UNION
  SELECT 'EventActionMappings' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM EventActionMappings UNION
  SELECT 'ExternalForecastVisibility' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ExternalForecastVisibility UNION
  SELECT 'FewsSessions' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FewsSessions UNION
  SELECT 'FewsWebServices' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FewsWebServices UNION
  SELECT 'FlagConversions' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FlagConversions UNION
  SELECT 'FloodPeriods' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FloodPeriods UNION
  SELECT 'ForecastingShells' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ForecastingShells UNION
  SELECT 'FssGroups' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FssGroups UNION
  SELECT 'FssResources' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FssResources UNION
  SELECT 'FssStatus' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM FssStatus UNION
  SELECT 'HistoricalEvents' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM HistoricalEvents UNION
  SELECT 'Icons' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Icons UNION
  SELECT 'IdMaps' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM IdMaps UNION
  SELECT 'ImportStatus' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ImportStatus UNION
  SELECT 'IndexFilesSnapshots' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM IndexFilesSnapshots UNION
  SELECT 'LastIssuedTimestamp' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LastIssuedTimestamp UNION
  SELECT 'LiveMcAvailabilities' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LiveMcAvailabilities UNION
  SELECT 'LocalMcId' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LocalMcId UNION
  SELECT 'LocalSynchTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LocalSynchTimes UNION
  SELECT 'LogEntries' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LogEntries UNION
  SELECT 'LogEventProcessorTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM LogEventProcessorTimes UNION
  SELECT 'MapLayers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM MapLayers UNION
  SELECT 'MasterControllers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM MasterControllers UNION
  SELECT 'MCConfigFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM MCConfigFiles UNION
  SELECT 'McFailoverPriorities' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM McFailoverPriorities UNION
  SELECT 'McSynchStatus' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM McSynchStatus UNION
  SELECT 'Modifiers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Modifiers UNION
  SELECT 'ModuleInstanceConfigs' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleInstanceConfigs UNION
  SELECT 'ModuleInstanceDatasets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleInstanceDatasets UNION
  SELECT 'ModuleInstanceRuns' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleInstanceRuns UNION
  SELECT 'ModuleParameterModifiers' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleParameterModifiers UNION
  SELECT 'ModuleParameters' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleParameters UNION
  SELECT 'ModuleRunTables' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleRunTables UNION
  SELECT 'ModuleRunTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ModuleRunTimes UNION
  SELECT 'PiClientConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM PiClientConfigurations UNION
  SELECT 'PiClientDataSets' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM PiClientDataSets UNION
  SELECT 'PiServiceConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM PiServiceConfigurations UNION
  SELECT 'ProcessedDeletedRows' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ProcessedDeletedRows UNION
  SELECT 'ProductInfo' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ProductInfo UNION
  SELECT 'RegionConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM RegionConfigurations UNION
  SELECT 'ReportImages' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ReportImages UNION
  SELECT 'Reports' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Reports UNION
  SELECT 'ReportTemplates' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ReportTemplates UNION
  SELECT 'RollingBarrelTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM RollingBarrelTimes UNION
  SELECT 'RootConfigFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM RootConfigFiles UNION
  SELECT 'Samples' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Samples UNION
  SELECT 'SystemActivities' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM SystemActivities UNION
  SELECT 'SystemConfigurations' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM SystemConfigurations UNION
  SELECT 'TableLocalModificationTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TableLocalModificationTimes UNION
  SELECT 'TaskRunCompletions' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TaskRunCompletions UNION
  SELECT 'TaskRunDispatcherTimes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TaskRunDispatcherTimes UNION
  SELECT 'TaskRunLogFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TaskRunLogFiles UNION
  SELECT 'TaskRuns' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TaskRuns UNION
  SELECT 'Tasks' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Tasks UNION
  SELECT 'ThresholdEvents' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM ThresholdEvents UNION
  SELECT 'TimeSeries' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TimeSeries UNION
  SELECT 'TimeSeriesStatusSnapshots' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM TimeSeriesStatusSnapshots UNION
  SELECT 'UnitConversions' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM UnitConversions UNION
  SELECT 'Users' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM Users UNION
  SELECT 'UserSettings' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM UserSettings UNION
  SELECT 'UserToGroupsMappings' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM UserToGroupsMappings UNION
  SELECT 'VersionManagement' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM VersionManagement UNION
  SELECT 'VersionRunning' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM VersionRunning UNION
  SELECT 'WarmStates' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM WarmStates UNION
  SELECT 'WhatIfScenarios' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM WhatIfScenarios UNION
  SELECT 'WorkflowFiles' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM WorkflowFiles UNION
  SELECT 'WorkflowTargetFsss' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM WorkflowTargetFsss;
GO

PRINT 'E1';
GO
DELETE FROM $(strschema).VersionManagement WHERE componentId='CURRENT_SCHEMA';
GO

PRINT 'E2';
GO
INSERT INTO $(strschema).VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime) VALUES (
  (SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM $(strschema).VersionManagement), 'DATABASE_SCHEMA', 'v2021.01_20200415_1',
  GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO

PRINT 'E3';
GO
INSERT INTO $(strschema).VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime) VALUES (
  (SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM $(strschema).VersionManagement), 'CURRENT_SCHEMA', 'v2021.01_20200415_1',
  GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO

PRINT 'E4';
GO
UPDATE $(strschema).DatabaseSchemaInfo SET schemaModificationTime=GETUTCDATE(), modificationTime=GETUTCDATE(), localModificationTime=GETUTCDATE()
  WHERE singleRowKey=0;
GO
