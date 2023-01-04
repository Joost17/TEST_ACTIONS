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
-- Database script to update database schema on PostgreSQL (9.4 and newer) from version v2020.02_20201026_1 to v2021.01_20200415_1.
--
-- Invocation  : psql -f data_update.sql -d <database> -v database=<database> -v strusername=<username>

\set strtbsData :database'_dat01'
\set strtbsIdx :database'_idx01'
\set schemaversion '\'v2021.01_20200415_1\''

-- Set the message level a bit higher to avoid lots of messages (default is NOTICE)
set client_min_messages='WARNING';

\set ON_ERROR_STOP ON
DO $$
DECLARE
  v_maintenanceRunning integer := 0;
BEGIN
   SELECT COALESCE(MAX(maintenanceRunning), 0) FROM DatabaseSchemaInfo WHERE singleRowKey=0 INTO v_maintenanceRunning;
   IF v_maintenanceRunning<>1 THEN
     RAISE 'Fatal error: Maintenance mode required. Please first activate maintenance mode before using the data_update script.';
   END IF;
END $$
LANGUAGE plpgsql;
\echo 'Maintenancemode detected'
\set ON_ERROR_STOP off

DELETE FROM :strusername.VersionManagement WHERE componentId='CURRENT_SCHEMA';

\echo 'L001'
DROP VIEW :strusername.WarmStatesSizes;
\echo 'L002'
DROP VIEW :strusername.TimeSeriesSizes;
\echo 'L003'
DROP VIEW :strusername.GlobalRowIds;
\echo 'L004'
DROP VIEW :strusername.Dual;
\echo 'L005'
ALTER TABLE :strusername.FssStatus ADD workflowNodeIndex INTEGER DEFAULT '0' NOT NULL;
\echo 'L006'
ALTER TABLE :strusername.FssStatus ADD progressPercentage NUMERIC(2) DEFAULT '0' NOT NULL;
\echo 'L007'
ALTER TABLE :strusername.Tasks ADD lastCompletedTaskRunId VARCHAR(64);
\echo 'L008'
ALTER TABLE :strusername.Tasks ADD lastCompletedDurationMillis BIGINT DEFAULT '0' NOT NULL;
\echo 'L009'
ALTER TABLE :strusername.TaskRuns ADD timeZero TIMESTAMP(3);
\echo 'L010'
ALTER TABLE :strusername.ModuleInstanceRuns ADD runStatus NUMERIC(2) DEFAULT '0' NOT NULL;
\echo 'L011'
CREATE TABLE :strusername.ModuleRunTimes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  workflowId VARCHAR(64) NOT NULL,
  moduleInstanceId VARCHAR(64) NOT NULL,
  pendingDurationMillis BIGINT NOT NULL,
  runDurationMillis BIGINT NOT NULL,
  minPartition INTEGER NOT NULL,
  maxPartition INTEGER NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleRunTimes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleRunTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;
\echo 'L012'
CREATE INDEX IDX_ModuleRunTimes_lmt ON :strusername.ModuleRunTimes(localModificationTime) TABLESPACE :strtbsIdx;
\echo 'L013'
CREATE INDEX IDX_ModuleRunTimes_workflowId_ ON :strusername.ModuleRunTimes(workflowId, moduleInstanceId) TABLESPACE :strtbsIdx;

ALTER TABLE :strusername.AiServletUsers ALTER COLUMN password SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ArchiveMetaData ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.BaseBuildFileSets ALTER COLUMN compressedXml SET STORAGE EXTERNAL;
ALTER TABLE :strusername.BaseBuildFiles ALTER COLUMN compressedFile SET STORAGE EXTERNAL;
ALTER TABLE :strusername.CMConfigFiles ALTER COLUMN compressedXml SET STORAGE EXTERNAL;
ALTER TABLE :strusername.CMConfigFiles ALTER COLUMN patchFileBlob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ColdStates ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ComponentLogFileSnapshots ALTER COLUMN snapshotZip SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ConfigRevisionSets ALTER COLUMN dataSet SET STORAGE EXTERNAL;
ALTER TABLE :strusername.DeletedRows ALTER COLUMN deletedGlobalRowIds SET STORAGE EXTERNAL;
ALTER TABLE :strusername.Icons ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.IndexFilesSnapshots ALTER COLUMN zipBlob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.MCConfigFiles ALTER COLUMN compressedXml SET STORAGE EXTERNAL;
ALTER TABLE :strusername.MCConfigFiles ALTER COLUMN patchFileBlob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.MapLayers ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ModuleInstanceDatasets ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ModuleRunTables ALTER COLUMN fileBlob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.PiClientDataSets ALTER COLUMN dataSet SET STORAGE EXTERNAL;
ALTER TABLE :strusername.ReportImages ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.Reports ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.RootConfigFiles ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TaskRunLogFiles ALTER COLUMN compressedLogFile SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN a SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN b SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN c SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN d SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN e SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN f SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN g SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN h SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN i SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN j SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN k SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN l SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN m SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN n SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN o SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN p SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN q SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN r SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN s SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN t SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN u SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN v SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN w SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN x SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN y SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeries ALTER COLUMN z SET STORAGE EXTERNAL;
ALTER TABLE :strusername.TimeSeriesStatusSnapshots ALTER COLUMN blob SET STORAGE EXTERNAL;
ALTER TABLE :strusername.UserSettings ALTER COLUMN compressedUserSettingsFile SET STORAGE EXTERNAL;
ALTER TABLE :strusername.WarmStates ALTER COLUMN blob SET STORAGE EXTERNAL;

UPDATE :strusername.AiServletUsers SET password = decode(encode(password, 'base64'), 'base64');
UPDATE :strusername.ArchiveMetaData SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.BaseBuildFileSets SET compressedXml = decode(encode(compressedXml, 'base64'), 'base64');
UPDATE :strusername.BaseBuildFiles SET compressedFile = decode(encode(compressedFile, 'base64'), 'base64');
UPDATE :strusername.CMConfigFiles SET compressedXml = decode(encode(compressedXml, 'base64'), 'base64');
UPDATE :strusername.CMConfigFiles SET patchFileBlob = decode(encode(patchFileBlob, 'base64'), 'base64');
UPDATE :strusername.ColdStates SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.ComponentLogFileSnapshots SET snapshotZip = decode(encode(snapshotZip, 'base64'), 'base64');
UPDATE :strusername.ConfigRevisionSets SET dataSet = decode(encode(dataSet, 'base64'), 'base64');
UPDATE :strusername.DeletedRows SET deletedGlobalRowIds = decode(encode(deletedGlobalRowIds, 'base64'), 'base64');
UPDATE :strusername.Icons SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.IndexFilesSnapshots SET zipBlob = decode(encode(zipBlob, 'base64'), 'base64');
UPDATE :strusername.MCConfigFiles SET compressedXml = decode(encode(compressedXml, 'base64'), 'base64');
UPDATE :strusername.MCConfigFiles SET patchFileBlob = decode(encode(patchFileBlob, 'base64'), 'base64');
UPDATE :strusername.MapLayers SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.ModuleInstanceDatasets SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.ModuleRunTables SET fileBlob = decode(encode(fileBlob, 'base64'), 'base64');
UPDATE :strusername.PiClientDataSets SET dataSet = decode(encode(dataSet, 'base64'), 'base64');
UPDATE :strusername.ReportImages SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.Reports SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.RootConfigFiles SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.TaskRunLogFiles SET compressedLogFile = decode(encode(compressedLogFile, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET a = decode(encode(a, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET b = decode(encode(b, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET c = decode(encode(c, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET d = decode(encode(d, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET e = decode(encode(e, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET f = decode(encode(f, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET g = decode(encode(g, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET h = decode(encode(h, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET i = decode(encode(i, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET j = decode(encode(j, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET k = decode(encode(k, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET l = decode(encode(l, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET m = decode(encode(m, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET n = decode(encode(n, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET o = decode(encode(o, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET p = decode(encode(p, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET q = decode(encode(q, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET r = decode(encode(r, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET s = decode(encode(s, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET t = decode(encode(t, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET u = decode(encode(u, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET v = decode(encode(v, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET w = decode(encode(w, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET x = decode(encode(x, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET y = decode(encode(y, 'base64'), 'base64');
UPDATE :strusername.TimeSeries SET z = decode(encode(z, 'base64'), 'base64');
UPDATE :strusername.TimeSeriesStatusSnapshots SET blob = decode(encode(blob, 'base64'), 'base64');
UPDATE :strusername.UserSettings SET compressedUserSettingsFile = decode(encode(compressedUserSettingsFile, 'base64'), 'base64');
UPDATE :strusername.WarmStates SET blob = decode(encode(blob, 'base64'), 'base64');

CREATE VIEW :strusername.WarmStatesSizes AS SELECT warmstates.moduleinstanceid, sum(((pg_column_size(warmstates.blob))::numeric / 1024.0)) AS sumblobsizekb, count(*) AS numrecords, (date_part('epoch'::text, max((warmstates.expirytime - warmstates.creationtime))))::numeric AS maxexpirydurationinsec FROM warmstates GROUP BY warmstates.moduleinstanceid;

CREATE VIEW :strusername.TimeSeriesSizes AS SELECT timeseries.moduleinstanceid, sum(((pg_column_size(timeseries.blob))::numeric / 1024.0)) AS sumblobsizekb, count(*) AS numrecords, (date_part('epoch'::text, max((timeseries.expirytime - timeseries.creationtime))))::numeric AS maxexpirydurationinsec FROM timeseries GROUP BY timeseries.moduleinstanceid;

CREATE VIEW :strusername.Dual AS SELECT 1 AS X;

CREATE VIEW :strusername.GlobalRowIds AS
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

-- End of schema updates here
\echo 'E1'
INSERT INTO :strusername.VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime) 
   VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM VersionManagement), 'DATABASE_SCHEMA',
   :schemaversion, CURRENT_TIMESTAMP AT TIME ZONE 'GMT',
   CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

\echo 'E2'
INSERT INTO :strusername.VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
   VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM VersionManagement), 'CURRENT_SCHEMA',
   :schemaversion, CURRENT_TIMESTAMP AT TIME ZONE 'GMT',
   CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

\echo 'E3'
UPDATE :strusername.DatabaseSchemaInfo SET schemaModificationTime=CURRENT_TIMESTAMP AT TIME ZONE 'GMT',
  modificationTime=CURRENT_TIMESTAMP AT TIME ZONE 'GMT', localModificationTime=CURRENT_TIMESTAMP AT TIME ZONE 'GMT'
  WHERE singleRowKey=0;
