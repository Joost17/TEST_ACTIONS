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
-- seasonal forecasting, and real-time water resources management
--
-- ----------------------------------------------------------------
-- view_creation.sql
-- View creation script for SQLServer 2012 and higher for the Delft-FEWS database schema (tables and views).
-- Version v2021.01_20200415_1

-- Usage: 
-- 1. Navigate to a directory with write permissions.
-- 2. Ensure the sqlcmd executable can be found in your path.
-- 3. echo exit | sqlcmd -I -S<server> -d<database> -U<user> -P<password> -iview_creation.sql

DROP FUNCTION $(strschema).Mod
GO
CREATE FUNCTION $(strschema).Mod (@a BIGINT, @n INT) RETURNS BIGINT WITH EXECUTE AS CALLER AS BEGIN RETURN @a%@n; END
GO

DROP VIEW $(strschema).WarmStatesSizes;
GO
DROP VIEW $(strschema).TimeSeriesSizes;
GO
DROP VIEW $(strschema).GlobalRowIds;
GO
DROP VIEW $(strschema).Dual;
GO
CREATE VIEW $(strschema).Dual AS SELECT 1 AS X;
GO
CREATE VIEW $(strschema).GlobalRowIds AS   SELECT 'AccessKeyHashes' AS tableName, globalRowId, creationTime, modificationTime, localModificationTime FROM AccessKeyHashes UNION
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
CREATE VIEW $(strschema).TimeSeriesSizes AS SELECT moduleInstanceId, SUM(datalength(blob)/1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, MAX(CAST(DATEDIFF(minute,creationTime,expiryTime) AS BIGINT))*60 AS maxExpiryDurationInSec FROM TimeSeries GROUP BY moduleInstanceId;
GO
CREATE VIEW $(strschema).WarmStatesSizes AS SELECT moduleInstanceId, SUM(datalength(blob)/1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, MAX(CAST(DATEDIFF(minute,creationTime,expiryTime) AS BIGINT))*60 AS maxExpiryDurationInSec FROM WarmStates GROUP BY moduleInstanceId;
GO
