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
-- schema_creation.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2019, by Deltares
--
-- Schema creation script for SQLServer 2012 and higher for the Delft-FEWS database schema sequences, triggers, tables and indexes.
-- Version v2021.01_20200415_1

DROP VIEW $(strschema).WarmStatesSizes;
GO
DROP VIEW $(strschema).TimeSeriesSizes;
GO
DROP VIEW $(strschema).GlobalRowIds;
GO
DROP VIEW $(strschema).Dual;
GO
DROP TABLE $(strschema).TimeSeries;
GO
DROP TABLE $(strschema).WarmStates;
GO
DROP TABLE $(strschema).ArchiveMetaData;
GO
DROP TABLE $(strschema).TaskRunCompletions;
GO
DROP TABLE $(strschema).ModuleRunTables;
GO
DROP TABLE $(strschema).Reports;
GO
DROP TABLE $(strschema).ModuleRunTimes;
GO
DROP TABLE $(strschema).ModuleInstanceRuns;
GO
DROP TABLE $(strschema).TaskRuns;
GO
DROP TABLE $(strschema).Tasks;
GO
DROP TABLE $(strschema).ModuleParameterModifiers;
GO
DROP TABLE $(strschema).AttributeModifiers;
GO
DROP TABLE $(strschema).Modifiers;
GO
DROP TABLE $(strschema).WhatIfScenarios;
GO
DROP TABLE $(strschema).ThresholdEvents;
GO
DROP TABLE $(strschema).PiClientDataSets;
GO
DROP TABLE $(strschema).Samples;
GO
DROP TABLE $(strschema).LogEntries;
GO
DROP TABLE $(strschema).FloodPeriods;
GO
DROP TABLE $(strschema).HistoricalEvents;
GO
DROP TABLE $(strschema).FewsSessions;
GO
DROP TABLE $(strschema).TimeSeriesStatusSnapshots;
GO
DROP TABLE $(strschema).ExternalForecastVisibility;
GO
DROP TABLE $(strschema).ProductInfo;
GO
DROP TABLE $(strschema).ImportStatus;
GO
DROP TABLE $(strschema).EventActionMappings;
GO
DROP TABLE $(strschema).ActionConfigurations;
GO
DROP TABLE $(strschema).McFailoverPriorities;
GO
DROP TABLE $(strschema).WorkflowTargetFsss;
GO
DROP TABLE $(strschema).ForecastingShells;
GO
DROP TABLE $(strschema).FssGroups;
GO
DROP TABLE $(strschema).TaskRunDispatcherTimes;
GO
DROP TABLE $(strschema).LogEventProcessorTimes;
GO
DROP TABLE $(strschema).MasterControllers;
GO
DROP TABLE $(strschema).AiServletUsers;
GO
DROP TABLE $(strschema).ConfigRevisionSets;
GO
DROP TABLE $(strschema).WorkflowFiles;
GO
DROP TABLE $(strschema).UnitConversions;
GO
DROP TABLE $(strschema).SystemConfigurations;
GO
DROP TABLE $(strschema).RootConfigFiles;
GO
DROP TABLE $(strschema).ReportTemplates;
GO
DROP TABLE $(strschema).ReportImages;
GO
DROP TABLE $(strschema).RegionConfigurations;
GO
DROP TABLE $(strschema).PiServiceConfigurations;
GO
DROP TABLE $(strschema).PiClientConfigurations;
GO
DROP TABLE $(strschema).ModuleParameters;
GO
DROP TABLE $(strschema).ModuleInstanceDatasets;
GO
DROP TABLE $(strschema).ModuleInstanceConfigs;
GO
DROP TABLE $(strschema).MapLayers;
GO
DROP TABLE $(strschema).IdMaps;
GO
DROP TABLE $(strschema).Icons;
GO
DROP TABLE $(strschema).FlagConversions;
GO
DROP TABLE $(strschema).DisplayConfigurations;
GO
DROP TABLE $(strschema).CorrelationTravelTimes;
GO
DROP TABLE $(strschema).CorrelationEventSets;
GO
DROP TABLE $(strschema).ColdStates;
GO
DROP TABLE $(strschema).CoefficientSets;
GO
DROP TABLE $(strschema).LiveMcAvailabilities;
GO
DROP TABLE $(strschema).RollingBarrelTimes;
GO
DROP TABLE $(strschema).ProcessedDeletedRows;
GO
DROP TABLE $(strschema).DeletedRows;
GO
DROP TABLE $(strschema).LocalSynchTimes;
GO
DROP TABLE $(strschema).CMConfigFiles;
GO
DROP TABLE $(strschema).MCConfigFiles;
GO
DROP TABLE $(strschema).IndexFilesSnapshots;
GO
DROP TABLE $(strschema).UserSettings;
GO
DROP TABLE $(strschema).UserToGroupsMappings;
GO
DROP TABLE $(strschema).AccessKeyHashes;
GO
DROP TABLE $(strschema).Users;
GO
DROP TABLE $(strschema).FssResources;
GO
DROP TABLE $(strschema).FssStatus;
GO
DROP TABLE $(strschema).McSynchStatus;
GO
DROP TABLE $(strschema).FewsWebServices;
GO
DROP TABLE $(strschema).TaskRunLogFiles;
GO
DROP TABLE $(strschema).ComponentLogFileSnapshots;
GO
DROP TABLE $(strschema).BaseBuildFileSets;
GO
DROP TABLE $(strschema).BaseBuildFiles;
GO
DROP TABLE $(strschema).TableLocalModificationTimes;
GO
DROP TABLE $(strschema).LocalMcId;
GO
DROP TABLE $(strschema).SystemActivities;
GO
DROP TABLE $(strschema).VersionRunning;
GO
DROP TABLE $(strschema).VersionManagement;
GO
DROP TABLE $(strschema).LastIssuedTimestamp;
GO
DROP TABLE $(strschema).DatabaseSchemaInfo;
GO
DROP SEQUENCE $(strschema).TaskRunIdSequence;
GO
DROP SEQUENCE $(strschema).TaskIdSequence;
GO
DROP SEQUENCE $(strschema).ForecastingShellIdSequence;
GO
DROP SEQUENCE $(strschema).FewsWebServicesIdSequence;
GO
DROP SEQUENCE $(strschema).EntryIdSequence;
GO
DROP SEQUENCE $(strschema).ConfigRevisionSetsIdSequence;
GO
DROP SEQUENCE $(strschema).GlobalRowIdSequence;
GO

SELECT so.type + '.' + so.name FROM $(strschema).sysobjects so, $(strschema).sysusers su WHERE so.uid = su.uid AND su.name = '$(strschema)' ORDER BY so.type, so.name;
GO

CREATE SEQUENCE $(strschema).GlobalRowIdSequence AS BIGINT START WITH $(databaseintid) INCREMENT BY 100 MINVALUE $(databaseintid) MAXVALUE 9223372036854775807 CACHE 10;
GO
CREATE SEQUENCE $(strschema).ConfigRevisionSetsIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO
CREATE SEQUENCE $(strschema).EntryIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO
CREATE SEQUENCE $(strschema).FewsWebServicesIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO
CREATE SEQUENCE $(strschema).ForecastingShellIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO
CREATE SEQUENCE $(strschema).TaskIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO
CREATE SEQUENCE $(strschema).TaskRunIdSequence AS BIGINT START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
GO

CREATE TABLE $(strschema).DatabaseSchemaInfo(
  singleRowKey INTEGER NOT NULL, --PK
  maintenanceRunning NUMERIC(1) NOT NULL,
  schemaModificationTime DATETIME2(3) NOT NULL,
  globalRowIdRegenerationTime DATETIME2(3),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_DatabaseSchemaInfo_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_DatabaseSchemaInfo PRIMARY KEY(singleRowKey),
  CONSTRAINT IDX_DatabaseSchemaInfo_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_DatabaseSchemaInfo_lmt ON $(strschema).DatabaseSchemaInfo(localModificationTime);
GO

CREATE TABLE $(strschema).LastIssuedTimestamp(
  singleRowKey INTEGER NOT NULL, --PK
  dateTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LastIssuedTimestamp_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LastIssuedTimestamp PRIMARY KEY(singleRowKey)
);
GO

CREATE INDEX IDX_LastIssuedTimestamp_lmt ON $(strschema).LastIssuedTimestamp(localModificationTime);
GO

CREATE TABLE $(strschema).VersionManagement(
  versionId VARCHAR(64) NOT NULL, --PK
  componentId VARCHAR(64) NOT NULL, --PK
  entryId INTEGER NOT NULL, --PK
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_VersionManagement_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_VersionManagement PRIMARY KEY(versionId, componentId, entryId),
  CONSTRAINT IDX_VersionManagement_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_VersionManagement_lmt ON $(strschema).VersionManagement(localModificationTime);
GO

CREATE TABLE $(strschema).VersionRunning(
  versionId VARCHAR(64) NOT NULL, --PK
  componentId VARCHAR(64) NOT NULL, --PK
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_VersionRunning_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_VersionRunning PRIMARY KEY(versionId, componentId),
  CONSTRAINT IDX_VersionRunning_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_VersionRunning_lmt ON $(strschema).VersionRunning(localModificationTime);
GO

CREATE TABLE $(strschema).SystemActivities(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskRunType VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_SystemActivities_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_SystemActivities PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_SystemActivities_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_SystemActivities_et ON $(strschema).SystemActivities(expiryTime);
GO
CREATE INDEX IDX_SystemActivities_lmt ON $(strschema).SystemActivities(localModificationTime);
GO

CREATE TABLE $(strschema).LocalMcId(
  singleRowKey INTEGER NOT NULL, --PK
  mcId VARCHAR(64) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LocalMcId_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LocalMcId PRIMARY KEY(singleRowKey),
  CONSTRAINT IDX_LocalMcId_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_LocalMcId_lmt ON $(strschema).LocalMcId(localModificationTime);
GO

CREATE TABLE $(strschema).TableLocalModificationTimes(
  tableName VARCHAR(30) NOT NULL, --PK
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TablLocaModiTime_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TableLocalModificationTimes PRIMARY KEY(tableName),
  CONSTRAINT IDX_TablLocaModiTime_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_TablLocaModiTime_lmt ON $(strschema).TableLocalModificationTimes(localModificationTime);
GO

CREATE TABLE $(strschema).BaseBuildFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  hash VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  compressedFile VARBINARY(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_BaseBuildFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_BaseBuildFiles PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_BaseBuildFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_BaseBuildFiles_et ON $(strschema).BaseBuildFiles(expiryTime);
GO
CREATE INDEX IDX_BaseBuildFiles ON $(strschema).BaseBuildFiles(hash);
GO
CREATE INDEX IDX_BaseBuildFiles_lmt ON $(strschema).BaseBuildFiles(localModificationTime);
GO

CREATE TABLE $(strschema).BaseBuildFileSets(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  buildType VARCHAR(255) NOT NULL,
  implementationVersion VARCHAR(255) NOT NULL,
  buildNumber INTEGER NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  commentText VARCHAR(255),
  expiryTime DATETIME2(3) NOT NULL,
  compressedXml VARBINARY(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_BaseBuildFileSets_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_BaseBuildFileSets PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_BaseBuildFileSets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_BaseBuildFileSets ON $(strschema).BaseBuildFileSets(buildType, implementationVersion, buildNumber);
GO
CREATE INDEX IDX_BaseBuildFileSets_et ON $(strschema).BaseBuildFileSets(expiryTime);
GO
CREATE INDEX IDX_BaseBuildFileSets_lmt ON $(strschema).BaseBuildFileSets(localModificationTime);
GO

CREATE TABLE $(strschema).ComponentLogFileSnapshots(
  logTaskRunId VARCHAR(64) NOT NULL, --PK
  expiryTime DATETIME2(3) NOT NULL,
  snapshotZip VARBINARY(MAX),
  snapshotRequestedTime DATETIME2(3),
  snapshotCompletedTime DATETIME2(3),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_CmpLogFileSnapshots_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ComponentLogFileSnapshots PRIMARY KEY(logTaskRunId),
  CONSTRAINT IDX_CmpLogFileSnapshots_id UNIQUE(globalRowId),
  CONSTRAINT FK_ComponentLogFileSnapshots FOREIGN KEY(logTaskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_CmpLogFileSnapshots_et ON $(strschema).ComponentLogFileSnapshots(expiryTime);
GO
CREATE INDEX IDX_CmpLogFileSnapshots_lmt ON $(strschema).ComponentLogFileSnapshots(localModificationTime);
GO

CREATE TABLE $(strschema).TaskRunLogFiles(
  taskRunId VARCHAR(64) NOT NULL, --PK
  expiryTime DATETIME2(3) NOT NULL,
  compressedLogFile VARBINARY(MAX),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TaskRunLogFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TaskRunLogFiles PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_TaskRunLogFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_TaskRunLogFiles_et ON $(strschema).TaskRunLogFiles(expiryTime);
GO
CREATE INDEX IDX_TaskRunLogFiles_lmt ON $(strschema).TaskRunLogFiles(localModificationTime);
GO

CREATE TABLE $(strschema).FewsWebServices(
  mcId VARCHAR(64) NOT NULL, --PK
  webServiceId BIGINT NOT NULL, --PK
  hostname VARCHAR(128) NOT NULL,
  name VARCHAR(64) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB INTEGER NOT NULL,
  diskSpaceMB INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  lastHeartbeatTime DATETIME2(3),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FewsWebServices_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_WebServices PRIMARY KEY(mcId, webServiceId),
  CONSTRAINT IDX_FewsWebServices_id UNIQUE(globalRowId),
  CONSTRAINT FK_WebServices FOREIGN KEY(logTaskRunId) REFERENCES $(strschema).ComponentLogFileSnapshots(logTaskRunId)
);
GO

CREATE INDEX IDX_FewsWebServices_et ON $(strschema).FewsWebServices(expiryTime);
GO
CREATE INDEX IDX_FewsWebServices_lmt ON $(strschema).FewsWebServices(localModificationTime);
GO

CREATE TABLE $(strschema).McSynchStatus(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  remoteMcId VARCHAR(30) NOT NULL,
  enabled NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_McSynchStatus_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_McSynchStatus PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_McSynchStatus_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_McSynchStatus_lmt ON $(strschema).McSynchStatus(localModificationTime);
GO

CREATE TABLE $(strschema).FssStatus(
  fssRowId BIGINT NOT NULL, --PK
  fssStatus INTEGER NOT NULL,
  lastFssStatusTransitionTime DATETIME2(3) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  workflowNodeIndex INTEGER CONSTRAINT DEF_FssStatNodeInde DEFAULT '0' NOT NULL,
  progressPercentage NUMERIC(2) CONSTRAINT DEF_FssStatPerc DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FssStatus_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FssStatus PRIMARY KEY(fssRowId),
  CONSTRAINT IDX_FssStatus_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_FssStatus_et ON $(strschema).FssStatus(expiryTime);
GO
CREATE INDEX IDX_FssStatus_lmt ON $(strschema).FssStatus(localModificationTime);
GO

CREATE TABLE $(strschema).FssResources(
  fssRowId BIGINT NOT NULL, --PK
  claimedSlots INTEGER NOT NULL,
  freeSlots INTEGER NOT NULL,
  cpu FLOAT CONSTRAINT DEF_FssResources_cpu DEFAULT '0' NOT NULL,
  cpuUsage FLOAT NOT NULL,
  memoryMB INTEGER CONSTRAINT DEF_FssResources_memoryMB DEFAULT '0' NOT NULL,
  memoryUsageMB INTEGER NOT NULL,
  javaHeapSpaceUsageMB INTEGER NOT NULL,
  diskSpaceMB INTEGER CONSTRAINT DEF_FssResources_diskSpaceMB DEFAULT '0' NOT NULL,
  diskSpaceUsageMB INTEGER NOT NULL,
  dbConnectionCount FLOAT NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FssResources_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FssResource PRIMARY KEY(fssRowId),
  CONSTRAINT IDX_FssResources_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_FssResources_et ON $(strschema).FssResources(expiryTime);
GO
CREATE INDEX IDX_FssResources_lmt ON $(strschema).FssResources(localModificationTime);
GO

CREATE TABLE $(strschema).Users(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userName VARCHAR(30) NOT NULL,
  userDisplayName VARCHAR(128),
  emailAddress VARCHAR(512),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Users_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Users PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_Users_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_Users_lmt ON $(strschema).Users(localModificationTime);
GO
CREATE INDEX IDX_Users ON $(strschema).Users(userName);
GO

CREATE TABLE $(strschema).AccessKeyHashes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  accessKeyHash VARCHAR(64) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_AccessKeyHashes_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_AccessKeyHashes PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_AccessKeyHashes_id UNIQUE(globalRowId),
  CONSTRAINT FK_AccessKeyHashes FOREIGN KEY(userMcId, userEntryId) REFERENCES $(strschema).Users(mcId, entryId)
);
GO

CREATE INDEX IDX_AccessKeyHashes_lmt ON $(strschema).AccessKeyHashes(localModificationTime);
GO

CREATE TABLE $(strschema).UserToGroupsMappings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  userGroup VARCHAR(30) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_UserToGroupsMappings_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_UserToGroupsMappings PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_UserToGroupsMappings_id UNIQUE(globalRowId),
  CONSTRAINT FK_UserToGroupsMappings FOREIGN KEY(userMcId, userEntryId) REFERENCES $(strschema).Users(mcId, entryId)
);
GO

CREATE INDEX IDX_UserToGroupsMappings_lmt ON $(strschema).UserToGroupsMappings(localModificationTime);
GO

CREATE TABLE $(strschema).UserSettings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  compressedUserSettingsFile VARBINARY(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_UserSettings_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_UserSettings PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_UserSettings_id UNIQUE(globalRowId),
  CONSTRAINT FK_UserSettings FOREIGN KEY(userMcId, userEntryId) REFERENCES $(strschema).Users(mcId, entryId)
);
GO

CREATE INDEX IDX_UserSettings_lmt ON $(strschema).UserSettings(localModificationTime);
GO

CREATE TABLE $(strschema).IndexFilesSnapshots(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  formatVersion VARCHAR(64) NOT NULL,
  zipBlob VARBINARY(MAX),
  snapshotTime DATETIME2(3),
  globalRowIdRegenerationTime DATETIME2(3),
  updateInProgressHeartbeat DATETIME2(3),
  fullRebuildRequested NUMERIC(1) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_IndexFilesSnapshots_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_IndexFilesSnapshots PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_IndexFilesSnapshots_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_IndexFilesSnapshots_et ON $(strschema).IndexFilesSnapshots(expiryTime);
GO
CREATE INDEX IDX_IndexFilesSnapshots_lmt ON $(strschema).IndexFilesSnapshots(localModificationTime);
GO
CREATE INDEX IDX_IndexFilesSnapshots ON $(strschema).IndexFilesSnapshots(mcId, formatVersion);
GO

CREATE TABLE $(strschema).MCConfigFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  patchFileBlob VARBINARY(MAX),
  compressedXml VARBINARY(MAX),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_MCConfigFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_MCConfigFiles PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_MCConfigFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_MCConfigFiles_lmt ON $(strschema).MCConfigFiles(localModificationTime);
GO

CREATE TABLE $(strschema).CMConfigFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  buildType VARCHAR(255) CONSTRAINT DEF_CMConfigFiles_buildType DEFAULT 'none' NOT NULL,
  implementationVersion VARCHAR(255) CONSTRAINT DEF_CMConfFileVers DEFAULT 'none' NOT NULL,
  buildNumber INTEGER CONSTRAINT DEF_CMConfigFiles_buildNumber DEFAULT '0' NOT NULL,
  creationUserId VARCHAR(30) CONSTRAINT DEF_CMConfFileUserId DEFAULT 'none' NOT NULL,
  commentText VARCHAR(255),
  patchFileBlob VARBINARY(MAX),
  compressedXml VARBINARY(MAX),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_CMConfigFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_CMConfigFiles PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_CMConfigFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_CMConfigFiles_lmt ON $(strschema).CMConfigFiles(localModificationTime);
GO

CREATE TABLE $(strschema).LocalSynchTimes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  remoteMcId VARCHAR(64) NOT NULL,
  tableName VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  maxAgeMillis BIGINT,
  lastHeartbeatTime DATETIME2(3) NOT NULL,
  lastSuccessfulSynchStartTime DATETIME2(3),
  lastFailedTime DATETIME2(3),
  totalNetworkBytes BIGINT NOT NULL,
  totalInsertedBytes BIGINT NOT NULL,
  totalInsertedRows BIGINT NOT NULL,
  totalInsertedFailedRows BIGINT NOT NULL,
  totalUpdatedBytes BIGINT NOT NULL,
  totalUpdatedRows BIGINT NOT NULL,
  totalUpdatedFailedRows BIGINT NOT NULL,
  totalDurationMillis BIGINT NOT NULL,
  totalDownDurationMillis BIGINT NOT NULL,
  thisMonthNetworkBytes BIGINT NOT NULL,
  thisMonthInsertedBytes BIGINT NOT NULL,
  thisMonthInsertedRows BIGINT NOT NULL,
  thisMonthInsertedFailedRows BIGINT NOT NULL,
  thisMonthUpdatedBytes BIGINT NOT NULL,
  thisMonthUpdatedRows BIGINT NOT NULL,
  thisMonthUpdatedFailedRows BIGINT NOT NULL,
  thisMonthDurationMillis BIGINT NOT NULL,
  thisMonthDownDurationMillis BIGINT NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LocalSynchTimes_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LocalSynchTimes PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_LocalSynchTimes_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_LocalSynchTimes_lmt ON $(strschema).LocalSynchTimes(localModificationTime);
GO
CREATE INDEX IDX_LocalSynchTimes ON $(strschema).LocalSynchTimes(mcId, remoteMcId, tableName, synchLevel);
GO

CREATE TABLE $(strschema).DeletedRows(
  deletedGlobalRowIds VARBINARY(MAX) NOT NULL,
  componentId VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_DeletedRows_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL, --PK
  CONSTRAINT PK_DeletedRows PRIMARY KEY(globalRowId) --PK
);
GO

CREATE INDEX IDX_DeletedRows_et ON $(strschema).DeletedRows(expiryTime);
GO
CREATE INDEX IDX_DeletedRows_lmt ON $(strschema).DeletedRows(localModificationTime);
GO

CREATE TABLE $(strschema).ProcessedDeletedRows(
  processedGlobalRowId BIGINT NOT NULL, --PK
  expiryTime DATETIME2(3) NOT NULL,
  durationMillis BIGINT NOT NULL,
  deletedRowCount INTEGER NOT NULL,
  failedRowCount INTEGER NOT NULL,
  firstFailedTable VARCHAR(30),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ProcessedDeletedRows_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ProcessedDeletedRows PRIMARY KEY(processedGlobalRowId),
  CONSTRAINT IDX_ProcessedDeletedRows_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ProcessedDeletedRows_et ON $(strschema).ProcessedDeletedRows(expiryTime);
GO
CREATE INDEX IDX_ProcessedDeletedRows_lmt ON $(strschema).ProcessedDeletedRows(localModificationTime);
GO

CREATE TABLE $(strschema).RollingBarrelTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime DATETIME2(3) NOT NULL,
  lastHeartbeatTime DATETIME2(3) NOT NULL,
  lastFailedTime DATETIME2(3),
  lastFailedTable VARCHAR(30),
  totalStartedCount INTEGER NOT NULL,
  totalFailedCount INTEGER NOT NULL,
  totalSuccessCount INTEGER NOT NULL,
  totalDurationMillis BIGINT NOT NULL,
  totalDownDurationMillis BIGINT NOT NULL,
  totalExpiredRowCount INTEGER NOT NULL,
  totalExtendedRowCount INTEGER NOT NULL,
  thisMonthStartedCount INTEGER NOT NULL,
  thisMonthFailedCount INTEGER NOT NULL,
  thisMonthFailedRunCount INTEGER NOT NULL,
  thisMonthDurationMillis BIGINT NOT NULL,
  thisMonthDownDurationMillis BIGINT NOT NULL,
  thisMonthExpiredRowCount INTEGER NOT NULL,
  thisMonthExtendedRowCount INTEGER NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_RollingBarrelTimes_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_RollingBarrelTimes PRIMARY KEY(singleRowKey),
  CONSTRAINT IDX_RollingBarrelTimes_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_RollingBarrelTimes_lmt ON $(strschema).RollingBarrelTimes(localModificationTime);
GO

CREATE TABLE $(strschema).LiveMcAvailabilities(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  isFailover NUMERIC(2),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LiveMcAvailabilities_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LiveMcAvailabilities PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_LiveMcAvailabilities_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_LiveMcAvailabilities_lmt ON $(strschema).LiveMcAvailabilities(localModificationTime);
GO
CREATE INDEX IDX_LiveMcAvailabilities ON $(strschema).LiveMcAvailabilities(mcId);
GO

CREATE TABLE $(strschema).CoefficientSets(
  coefficientSetsId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_CoefficientSets_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_CoefficientSets PRIMARY KEY(coefficientSetsId, version),
  CONSTRAINT IDX_CoefficientSets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_CoefficientSets_et ON $(strschema).CoefficientSets(expiryTime);
GO
CREATE INDEX IDX_CoefficientSets_lmt ON $(strschema).CoefficientSets(localModificationTime);
GO

CREATE TABLE $(strschema).ColdStates(
  coldStateId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ColdStates_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ColdStates PRIMARY KEY(coldStateId, version),
  CONSTRAINT IDX_ColdStates_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ColdStates_et ON $(strschema).ColdStates(expiryTime);
GO
CREATE INDEX IDX_ColdStates_lmt ON $(strschema).ColdStates(localModificationTime);
GO

CREATE TABLE $(strschema).CorrelationEventSets(
  eventSetsId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_CorrelationEventSets_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_CorrEvSet PRIMARY KEY(eventSetsId, version),
  CONSTRAINT IDX_CorrelationEventSets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_CorrelationEventSets_et ON $(strschema).CorrelationEventSets(expiryTime);
GO
CREATE INDEX IDX_CorrelationEventSets_lmt ON $(strschema).CorrelationEventSets(localModificationTime);
GO

CREATE TABLE $(strschema).CorrelationTravelTimes(
  travelTimesId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_CorrTravTime_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_CorrTrTime PRIMARY KEY(travelTimesId, version),
  CONSTRAINT IDX_CorrelationTravelTimes_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_CorrelationTravelTimes_et ON $(strschema).CorrelationTravelTimes(expiryTime);
GO
CREATE INDEX IDX_CorrelationTravelTimes_lmt ON $(strschema).CorrelationTravelTimes(localModificationTime);
GO

CREATE TABLE $(strschema).DisplayConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_DispConf_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_DisplayConfigurations PRIMARY KEY(configTypeId, version),
  CONSTRAINT IDX_DisplayConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_DisplayConfigurations_et ON $(strschema).DisplayConfigurations(expiryTime);
GO
CREATE INDEX IDX_DisplayConfigurations_lmt ON $(strschema).DisplayConfigurations(localModificationTime);
GO

CREATE TABLE $(strschema).FlagConversions(
  flagConversionId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FlagConversions_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FlagConversions PRIMARY KEY(flagConversionId, version),
  CONSTRAINT IDX_FlagConversions_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_FlagConversions_et ON $(strschema).FlagConversions(expiryTime);
GO
CREATE INDEX IDX_FlagConversions_lmt ON $(strschema).FlagConversions(localModificationTime);
GO

CREATE TABLE $(strschema).Icons(
  iconId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Icons_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Icons PRIMARY KEY(iconId, version),
  CONSTRAINT IDX_Icons_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_Icons_et ON $(strschema).Icons(expiryTime);
GO
CREATE INDEX IDX_Icons_lmt ON $(strschema).Icons(localModificationTime);
GO

CREATE TABLE $(strschema).IdMaps(
  idMapId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_IdMaps_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_IdMaps PRIMARY KEY(idMapId, version),
  CONSTRAINT IDX_IdMaps_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_IdMaps_et ON $(strschema).IdMaps(expiryTime);
GO
CREATE INDEX IDX_IdMaps_lmt ON $(strschema).IdMaps(localModificationTime);
GO

CREATE TABLE $(strschema).MapLayers(
  mapLayerId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_MapLayers_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_MapLayers PRIMARY KEY(mapLayerId, version),
  CONSTRAINT IDX_MapLayers_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_MapLayers_et ON $(strschema).MapLayers(expiryTime);
GO
CREATE INDEX IDX_MapLayers_lmt ON $(strschema).MapLayers(localModificationTime);
GO

CREATE TABLE $(strschema).ModuleInstanceConfigs(
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuInstConf_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleInstanceConfigs PRIMARY KEY(moduleInstanceId, version),
  CONSTRAINT IDX_ModuleInstanceConfigs_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ModuleInstanceConfigs_et ON $(strschema).ModuleInstanceConfigs(expiryTime);
GO
CREATE INDEX IDX_ModuleInstanceConfigs_lmt ON $(strschema).ModuleInstanceConfigs(localModificationTime);
GO

CREATE TABLE $(strschema).ModuleInstanceDatasets(
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuInstData_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleInstanceDatasets PRIMARY KEY(moduleInstanceId, version),
  CONSTRAINT IDX_ModuleInstanceDatasets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ModuleInstanceDatasets_et ON $(strschema).ModuleInstanceDatasets(expiryTime);
GO
CREATE INDEX IDX_ModuleInstanceDatasets_lmt ON $(strschema).ModuleInstanceDatasets(localModificationTime);
GO

CREATE TABLE $(strschema).ModuleParameters(
  moduleParameterId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuleParameters_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModParams PRIMARY KEY(moduleParameterId, version),
  CONSTRAINT IDX_ModuleParameters_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ModuleParameters_et ON $(strschema).ModuleParameters(expiryTime);
GO
CREATE INDEX IDX_ModuleParameters_lmt ON $(strschema).ModuleParameters(localModificationTime);
GO

CREATE TABLE $(strschema).PiClientConfigurations(
  clientId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_PiClieConf_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_PiClientConfigurations PRIMARY KEY(clientId, version),
  CONSTRAINT IDX_PiClientConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_PiClientConfigurations_et ON $(strschema).PiClientConfigurations(expiryTime);
GO
CREATE INDEX IDX_PiClientConfigurations_lmt ON $(strschema).PiClientConfigurations(localModificationTime);
GO

CREATE TABLE $(strschema).PiServiceConfigurations(
  clientId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_PiServConf_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_PiServiceConfigurations PRIMARY KEY(clientId, version),
  CONSTRAINT IDX_PiServiceConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_PiServiceConfigurations_et ON $(strschema).PiServiceConfigurations(expiryTime);
GO
CREATE INDEX IDX_PiServConf_lmt ON $(strschema).PiServiceConfigurations(localModificationTime);
GO

CREATE TABLE $(strschema).RegionConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_RegionConfigurations_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_RegionConfigurations PRIMARY KEY(configTypeId, version),
  CONSTRAINT IDX_RegionConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_RegionConfigurations_et ON $(strschema).RegionConfigurations(expiryTime);
GO
CREATE INDEX IDX_RegionConfigurations_lmt ON $(strschema).RegionConfigurations(localModificationTime);
GO

CREATE TABLE $(strschema).ReportImages(
  reportImageId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ReportImages_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ReportImages PRIMARY KEY(reportImageId, version),
  CONSTRAINT IDX_ReportImages_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ReportImages_et ON $(strschema).ReportImages(expiryTime);
GO
CREATE INDEX IDX_ReportImages_lmt ON $(strschema).ReportImages(localModificationTime);
GO

CREATE TABLE $(strschema).ReportTemplates(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ReportTemplates_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_RepTemp PRIMARY KEY(configTypeId, version),
  CONSTRAINT IDX_ReportTemplates_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ReportTemplates_et ON $(strschema).ReportTemplates(expiryTime);
GO
CREATE INDEX IDX_ReportTemplates_lmt ON $(strschema).ReportTemplates(localModificationTime);
GO

CREATE TABLE $(strschema).RootConfigFiles(
  rootConfigFileId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_RootConfigFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_RootConfigFiles PRIMARY KEY(rootConfigFileId, version),
  CONSTRAINT IDX_RootConfigFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_RootConfigFiles_et ON $(strschema).RootConfigFiles(expiryTime);
GO
CREATE INDEX IDX_RootConfigFiles_lmt ON $(strschema).RootConfigFiles(localModificationTime);
GO

CREATE TABLE $(strschema).SystemConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_SystemConfigurations_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_SystemConfigurations PRIMARY KEY(configTypeId, version),
  CONSTRAINT IDX_SystemConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_SystemConfigurations_et ON $(strschema).SystemConfigurations(expiryTime);
GO
CREATE INDEX IDX_SystemConfigurations_lmt ON $(strschema).SystemConfigurations(localModificationTime);
GO

CREATE TABLE $(strschema).UnitConversions(
  unitConversionId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_UnitConversions_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_UnitConversions PRIMARY KEY(unitConversionId, version),
  CONSTRAINT IDX_UnitConversions_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_UnitConversions_et ON $(strschema).UnitConversions(expiryTime);
GO
CREATE INDEX IDX_UnitConversions_lmt ON $(strschema).UnitConversions(localModificationTime);
GO

CREATE TABLE $(strschema).WorkflowFiles(
  workflowId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  hash VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_WorkflowFiles_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_WorkflowFiles PRIMARY KEY(workflowId, version),
  CONSTRAINT IDX_WorkflowFiles_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_WorkflowFiles_et ON $(strschema).WorkflowFiles(expiryTime);
GO
CREATE INDEX IDX_WorkflowFiles_lmt ON $(strschema).WorkflowFiles(localModificationTime);
GO

CREATE TABLE $(strschema).ConfigRevisionSets(
  revisionId VARCHAR(64) NOT NULL, --PK
  creationUserId VARCHAR(30) NOT NULL,
  commentText VARCHAR(255),
  numberOfChanges INTEGER NOT NULL,
  dataSet VARBINARY(MAX) NOT NULL,
  mcUpdateRequestTime DATETIME2(3),
  encodedPartitionSequencesXml NVARCHAR(MAX),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ConfigRevisionSets_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ConfigRevisionSets PRIMARY KEY(revisionId),
  CONSTRAINT IDX_ConfigRevisionSets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ConfigRevisionSets_lmt ON $(strschema).ConfigRevisionSets(localModificationTime);
GO

CREATE TABLE $(strschema).AiServletUsers(
  userName VARCHAR(16) NOT NULL, --PK
  password VARBINARY(MAX) NOT NULL,
  fullName VARCHAR(32) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_AiServletUsers_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_AiServletUsers PRIMARY KEY(userName),
  CONSTRAINT IDX_AiServletUsers_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_AiServletUsers_lmt ON $(strschema).AiServletUsers(localModificationTime);
GO

CREATE TABLE $(strschema).MasterControllers(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  hostname VARCHAR(128) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB INTEGER NOT NULL,
  diskSpaceMB INTEGER NOT NULL,
  databaseIntId INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  lastHeartbeatTime DATETIME2(3),
  mcStatus INTEGER CONSTRAINT DEF_MasterControllers_mcStatus DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_MasterControllers_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_MasterControllers PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_MasterControllers_id UNIQUE(globalRowId),
  CONSTRAINT FK_MasterControllers FOREIGN KEY(logTaskRunId) REFERENCES $(strschema).ComponentLogFileSnapshots(logTaskRunId)
);
GO

CREATE INDEX IDX_MasterControllers_lmt ON $(strschema).MasterControllers(localModificationTime);
GO

CREATE TABLE $(strschema).LogEventProcessorTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime DATETIME2(3) NOT NULL,
  lastHeartbeatTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LogEvenProcTime_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LogEventProcessorTimes PRIMARY KEY(singleRowKey),
  CONSTRAINT IDX_LogEventProcessorTimes_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_LogEventProcessorTimes_lmt ON $(strschema).LogEventProcessorTimes(localModificationTime);
GO

CREATE TABLE $(strschema).TaskRunDispatcherTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime DATETIME2(3) NOT NULL,
  lastHeartbeatTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TaskRunDispTime_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TaskRunDispatcherTimes PRIMARY KEY(singleRowKey),
  CONSTRAINT IDX_TaskRunDispatcherTimes_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_TaskRunDispatcherTimes_lmt ON $(strschema).TaskRunDispatcherTimes(localModificationTime);
GO

CREATE TABLE $(strschema).FssGroups(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  fssGroupId VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255),
  priority INTEGER CONSTRAINT DEF_FssGroups_priority DEFAULT '0' NOT NULL,
  allowUnmapped NUMERIC(1) CONSTRAINT DEF_FssGroups_allowUnmapped DEFAULT '1' NOT NULL,
  readyCount INTEGER CONSTRAINT DEF_FssGroups_readyCount DEFAULT '1' NOT NULL,
  maxAwakeCount INTEGER,
  gotoSleepSeconds INTEGER,
  releaseSlotsSeconds INTEGER,
  fssGroupStatus VARCHAR(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FssGroups_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FssGroups PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_FssGroups_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_FssGroups_lmt ON $(strschema).FssGroups(localModificationTime);
GO
CREATE INDEX IDX_FssGroups ON $(strschema).FssGroups(mcId, fssGroupId);
GO

CREATE TABLE $(strschema).ForecastingShells(
  mcId VARCHAR(64) NOT NULL, --PK
  fssId BIGINT NOT NULL, --PK
  mcEntryId BIGINT NOT NULL,
  fssGroupEntryId BIGINT NOT NULL,
  hostname VARCHAR(128) NOT NULL,
  regionHome VARCHAR(1000) CONSTRAINT DEF_ForeShelHome DEFAULT '/opt/fews/fss/1' NOT NULL,
  hostSlotCount INTEGER NOT NULL,
  indexAtHost INTEGER NOT NULL,
  awakenedByIndexAtHost INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  cpu FLOAT CONSTRAINT DEF_ForecastingShells_cpu DEFAULT '0' NOT NULL,
  memoryMB INTEGER CONSTRAINT DEF_ForeShel_memoMB DEFAULT '0' NOT NULL,
  diskSpaceMB INTEGER CONSTRAINT DEF_ForeShelSpacMB DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ForecastingShells_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ForecastingShells PRIMARY KEY(mcId, fssId),
  CONSTRAINT IDX_ForecastingShells_id UNIQUE(globalRowId),
  CONSTRAINT FK_ForecastingShells FOREIGN KEY(logTaskRunId) REFERENCES $(strschema).ComponentLogFileSnapshots(logTaskRunId),
  CONSTRAINT FK_ForecastingShells2 FOREIGN KEY(mcId, fssGroupEntryId) REFERENCES $(strschema).FssGroups(mcId, entryId),
  CONSTRAINT FK_ForecastingShells1 FOREIGN KEY(mcId, mcEntryId) REFERENCES $(strschema).MasterControllers(mcId, entryId)
);
GO

CREATE INDEX IDX_ForecastingShells_et ON $(strschema).ForecastingShells(expiryTime);
GO
CREATE INDEX IDX_ForecastingShells_lmt ON $(strschema).ForecastingShells(localModificationTime);
GO

CREATE TABLE $(strschema).WorkflowTargetFsss(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  workflowId VARCHAR(64) NOT NULL,
  fssGroupId VARCHAR(64) NOT NULL,
  fssPendingRunStatus INTEGER,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_WorkflowTargetFsss_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_WorkflowTargetFsss PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_WorkflowTargetFsss_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_WorkflowTargetFsss_lmt ON $(strschema).WorkflowTargetFsss(localModificationTime);
GO
CREATE INDEX IDX_WorkflowTargetFsss ON $(strschema).WorkflowTargetFsss(mcId, workflowId, fssGroupId);
GO

CREATE TABLE $(strschema).McFailoverPriorities(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  priority INTEGER,
  visible NUMERIC(1) CONSTRAINT DEF_McFailPrioVisi DEFAULT '0' NOT NULL,
  active NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_McFailoverPriorities_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_McFailoverPriorities PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_McFailoverPriorities_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_McFailoverPriorities_lmt ON $(strschema).McFailoverPriorities(localModificationTime);
GO
CREATE INDEX IDX_McFailoverPriorities ON $(strschema).McFailoverPriorities(mcId, priority);
GO

CREATE TABLE $(strschema).ActionConfigurations(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  actionId VARCHAR(64) NOT NULL,
  version VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ActionConfigurations_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ActionConfigurations PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_ActionConfigurations_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ActionConfigurations_et ON $(strschema).ActionConfigurations(expiryTime);
GO
CREATE INDEX IDX_ActionConfigurations_lmt ON $(strschema).ActionConfigurations(localModificationTime);
GO
CREATE INDEX IDX_ActionConfigurations ON $(strschema).ActionConfigurations(mcId, actionId, version);
GO

CREATE TABLE $(strschema).EventActionMappings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  actionId VARCHAR(64) NOT NULL,
  eventCode VARCHAR(64) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_EventActionMappings_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_EventActionMappings PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_EventActionMappings_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_EventActionMappings_lmt ON $(strschema).EventActionMappings(localModificationTime);
GO
CREATE INDEX IDX_EventActionMappings ON $(strschema).EventActionMappings(mcId, eventCode, actionId);
GO

CREATE TABLE $(strschema).ImportStatus(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  dataFeedId VARCHAR(64) NOT NULL,
  directory VARCHAR(128) NOT NULL,
  lastImportTime DATETIME2(3) NOT NULL,
  lastFileImported VARCHAR(128) NOT NULL,
  filesReadCount INTEGER NOT NULL,
  filesFailedCount INTEGER NOT NULL,
  log NVARCHAR(MAX),
  importState NVARCHAR(MAX),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ImportStatus_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ImportStatus PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_ImportStatus_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_Import_Status_Expiry_Time ON $(strschema).ImportStatus(expiryTime);
GO
CREATE INDEX IDX_ImportStatus_lmt ON $(strschema).ImportStatus(localModificationTime);
GO
CREATE INDEX IDX_ImportStatus ON $(strschema).ImportStatus(mcId, dataFeedId);
GO

CREATE TABLE $(strschema).ProductInfo(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  productId VARCHAR(64) NOT NULL,
  startForecastTime DATETIME2(3) NOT NULL,
  endForecastTime DATETIME2(3) NOT NULL,
  productInfoXml NVARCHAR(MAX) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ProductInfo_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ProductInfo PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_ProductInfo_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ProductInfo_et ON $(strschema).ProductInfo(expiryTime);
GO
CREATE INDEX IDX_ProductInfo_lmt ON $(strschema).ProductInfo(localModificationTime);
GO
CREATE INDEX IDX_ProductInfo_id_start_end ON $(strschema).ProductInfo(productId, startForecastTime, endForecastTime);
GO

CREATE TABLE $(strschema).ExternalForecastVisibility(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  productId VARCHAR(64) NOT NULL,
  externalForecastTime DATETIME2(3) NOT NULL,
  visible NUMERIC(1),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ExternalForecastVisibility_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ExternalForecastVisibility PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_ExtForVis_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ExtForVis_et ON $(strschema).ExternalForecastVisibility(expiryTime);
GO
CREATE INDEX IDX_ExtForVis_lmt ON $(strschema).ExternalForecastVisibility(localModificationTime);
GO

CREATE TABLE $(strschema).TimeSeriesStatusSnapshots(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  timeZero DATETIME2(3) NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TimeSeriStatSnap_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TimeSeriesStatusSnapshot PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_TimeSeriStatSnap_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_TimeSeriStatSnap_lmt ON $(strschema).TimeSeriesStatusSnapshots(localModificationTime);
GO
CREATE INDEX IDX_TimeSeriesStatusSnapshots ON $(strschema).TimeSeriesStatusSnapshots(mcId);
GO

CREATE TABLE $(strschema).FewsSessions(
  taskRunId VARCHAR(64) NOT NULL, --PK
  ocAddress VARCHAR(64) NOT NULL,
  userId VARCHAR(30) NOT NULL,
  sessionMcId VARCHAR(64) NOT NULL,
  loginTime DATETIME2(3) NOT NULL,
  lastRequestTime DATETIME2(3),
  sessionType NUMERIC(2) NOT NULL,
  pid INTEGER,
  description VARCHAR(255),
  clientSystemInfo NVARCHAR(MAX),
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FewsSessions_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FewsSessions PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_FewsSessions_id UNIQUE(globalRowId),
  CONSTRAINT FK_FewsSessions FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_FewsSessions_et ON $(strschema).FewsSessions(expiryTime);
GO
CREATE INDEX IDX_FewsSessions_lmt ON $(strschema).FewsSessions(localModificationTime);
GO

CREATE TABLE $(strschema).HistoricalEvents(
  taskRunId VARCHAR(64) NOT NULL, --PK
  eventId VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  beginTime DATETIME2(3) NOT NULL,
  endTime DATETIME2(3) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  eventXml NVARCHAR(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_HistoricalEvents_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_HistoricalEvents PRIMARY KEY(taskRunId, eventId),
  CONSTRAINT IDX_HistoricalEvents_id UNIQUE(globalRowId),
  CONSTRAINT FK_HistoricalEvents FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_HistoricalEvents_expiry ON $(strschema).HistoricalEvents(expiryTime);
GO
CREATE INDEX IDX_HistoricalEvents_lmt ON $(strschema).HistoricalEvents(localModificationTime);
GO

CREATE TABLE $(strschema).FloodPeriods(
  taskRunId VARCHAR(64) NOT NULL, --PK
  periodId VARCHAR(64) NOT NULL, --PK
  areaId VARCHAR(64) NOT NULL,
  persistentBeginTime DATETIME2(3) NOT NULL,
  beginTime DATETIME2(3) NOT NULL,
  endTime DATETIME2(3) NOT NULL,
  description VARCHAR(64),
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  eventTime DATETIME2(3),
  eventThresholdId VARCHAR(64),
  eventLocationId VARCHAR(64),
  eventParameterId VARCHAR(64),
  periodStatus NUMERIC(2) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_FloodPeriods_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_FloodPeriods PRIMARY KEY(taskRunId, periodId),
  CONSTRAINT IDX_FloodPeriods_id UNIQUE(globalRowId),
  CONSTRAINT FK_FloodPeriods FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_FloodPeriod_expiry ON $(strschema).FloodPeriods(expiryTime);
GO
CREATE INDEX IDX_FloodPeriods_lmt ON $(strschema).FloodPeriods(localModificationTime);
GO

CREATE TABLE $(strschema).LogEntries(
  taskRunId VARCHAR(64) NOT NULL, --PK
  logEntryId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64),
  synchLevel INTEGER NOT NULL,
  logLevel INTEGER NOT NULL,
  eventCode VARCHAR(255),
  eventAcknowledged INTEGER NOT NULL,
  eventProcessed INTEGER CONSTRAINT DEF_LogEntries_eventProcessed DEFAULT '0' NOT NULL,
  buildNumber INTEGER CONSTRAINT DEF_LogEntries_buildNumber DEFAULT '0' NOT NULL,
  logMessage NVARCHAR(MAX) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_LogEntries_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_LogEntries PRIMARY KEY(taskRunId, logEntryId),
  CONSTRAINT IDX_LogEntries_id UNIQUE(globalRowId),
  CONSTRAINT FK_LogEntries FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_LogEntries_ct ON $(strschema).LogEntries(creationTime);
GO
CREATE INDEX IDX_LogEntries_eventCode ON $(strschema).LogEntries(eventCode);
GO
CREATE INDEX IDX_LogEntries_processed ON $(strschema).LogEntries(eventProcessed);
GO
CREATE INDEX IDX_LogEntries_expiry ON $(strschema).LogEntries(expiryTime);
GO
CREATE INDEX IDX_LogEntries_lmt ON $(strschema).LogEntries(localModificationTime);
GO
CREATE INDEX IDX_LogEntries_logLevel ON $(strschema).LogEntries(logLevel);
GO

CREATE TABLE $(strschema).Samples(
  taskRunId VARCHAR(64) NOT NULL, --PK
  sampleId INTEGER NOT NULL, --PK
  externalSampleId VARCHAR(64) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  locationId VARCHAR(64) NOT NULL,
  dateTime DATETIME2(3) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  sampleProperties NVARCHAR(MAX) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Samples_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Samples PRIMARY KEY(taskRunId, sampleId),
  CONSTRAINT IDX_Samples_id UNIQUE(globalRowId),
  CONSTRAINT FK_Samples FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_Samples_expiry ON $(strschema).Samples(expiryTime);
GO
CREATE INDEX IDX_Samples_lmt ON $(strschema).Samples(localModificationTime);
GO

CREATE TABLE $(strschema).PiClientDataSets(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  dataSetId VARCHAR(64) NOT NULL,
  nodeId VARCHAR(64) NOT NULL,
  clientId VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  dataSet VARBINARY(MAX) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_PiClientDataSets_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_PiClientDataSets PRIMARY KEY(mcId, entryId),
  CONSTRAINT IDX_PiClientDataSets_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_PiClientDataSets ON $(strschema).PiClientDataSets(dataSetId, clientId);
GO
CREATE INDEX IDX_PiClientDataSets_lmt ON $(strschema).PiClientDataSets(localModificationTime);
GO

CREATE TABLE $(strschema).ThresholdEvents(
  taskRunId VARCHAR(64) NOT NULL, --PK
  eventEntryId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL,
  thresholdValueSetId VARCHAR(64) NOT NULL,
  parameterId VARCHAR(64) NOT NULL,
  locationId VARCHAR(64) NOT NULL,
  thresholdId VARCHAR(64) NOT NULL,
  rateOfChange VARCHAR(64),
  unitFromTimeStep VARCHAR(64),
  thresholdIntId INTEGER NOT NULL,
  timeSeriesType VARCHAR(64) NOT NULL,
  eventTime DATETIME2(3) NOT NULL,
  eventValue FLOAT NOT NULL,
  eventActionId VARCHAR(64),
  eventIssued NUMERIC(1),
  expiryTime DATETIME2(3) NOT NULL,
  taskRunIdTimeZero DATETIME2(3),
  exportTime DATETIME2(3),
  acknowledgedBy VARCHAR(64),
  acknowledgedTime DATETIME2(3),
  targetLocationId VARCHAR(64),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ThresholdEvents_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ThresholdEvents PRIMARY KEY(taskRunId, eventEntryId),
  CONSTRAINT IDX_ThresholdEvents_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_ThresholdEvents_ct ON $(strschema).ThresholdEvents(creationTime);
GO
CREATE INDEX IDX_Threshold_Events_expiry_Time ON $(strschema).ThresholdEvents(expiryTime);
GO
CREATE INDEX IDX_ThresholdEvents_lmt ON $(strschema).ThresholdEvents(localModificationTime);
GO
CREATE INDEX IDX_ThresholdEvents_mt ON $(strschema).ThresholdEvents(modificationTime);
GO

CREATE TABLE $(strschema).WhatIfScenarios(
  whatIfId VARCHAR(64) NOT NULL, --PK
  userDefinedId VARCHAR(64) NOT NULL,
  parentWhatIfId VARCHAR(64),
  description VARCHAR(255),
  creationTaskRunId VARCHAR(64),
  whatIfConfig NVARCHAR(MAX) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  persistent NUMERIC(1) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  name VARCHAR(64),
  pendingDeletion NUMERIC(1) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_WhatIfScenarios_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_WhatIfScenaios PRIMARY KEY(whatIfId),
  CONSTRAINT IDX_WhatIfScenarios_id UNIQUE(globalRowId)
);
GO

CREATE INDEX IDX_WhatIfScenarios_expiry ON $(strschema).WhatIfScenarios(expiryTime);
GO
CREATE INDEX IDX_WhatIfScenarios_lmt ON $(strschema).WhatIfScenarios(localModificationTime);
GO

CREATE TABLE $(strschema).Modifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  modifierId INTEGER NOT NULL, --PK
  whatIfId VARCHAR(64),
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  modType VARCHAR(64) NOT NULL,
  priority INTEGER NOT NULL,
  userId VARCHAR(30) NOT NULL,
  enabled NUMERIC(1) NOT NULL,
  enabledInEnsembleRun NUMERIC(1) CONSTRAINT DEF_ModiInEnseRun DEFAULT '0' NOT NULL,
  enabledPeriodStartTime DATETIME2(3),
  enabledPeriodEndTime DATETIME2(3),
  validTime DATETIME2(3),
  visible NUMERIC(1) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  userCreationTime DATETIME2(3),
  userModificationTime DATETIME2(3),
  creatorUserId VARCHAR(30),
  previousTaskRunId VARCHAR(64),
  previousModifierId INTEGER,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Modifiers_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Modifiers PRIMARY KEY(taskRunId, modifierId),
  CONSTRAINT IDX_Modifiers_id UNIQUE(globalRowId),
  CONSTRAINT FK_Modifiers FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId),
  CONSTRAINT FK_Modifiers_whatIf FOREIGN KEY(whatIfId) REFERENCES $(strschema).WhatIfScenarios(whatIfId)
);
GO

CREATE INDEX IDX_Modifiers_expiryTime ON $(strschema).Modifiers(expiryTime);
GO
CREATE INDEX IDX_Modifiers_lmt ON $(strschema).Modifiers(localModificationTime);
GO
CREATE INDEX IDX_Modifiers_whatIfId ON $(strschema).Modifiers(whatIfId);
GO

CREATE TABLE $(strschema).AttributeModifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  attributeModifierId INTEGER NOT NULL, --PK
  modifierId INTEGER NOT NULL,
  locationId VARCHAR(64) NOT NULL,
  attributeId VARCHAR(64) NOT NULL,
  attributeText VARCHAR(2000),
  attributeNumber FLOAT,
  attributeBoolean INTEGER,
  attributeTime DATETIME2(3),
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_AttributeModifiers_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_AttributeModifiers PRIMARY KEY(taskRunId, attributeModifierId),
  CONSTRAINT IDX_AttributeModifiers_id UNIQUE(globalRowId),
  CONSTRAINT FK_AttribModifiersModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES $(strschema).Modifiers(taskRunId, modifierId)
);
GO

CREATE INDEX IDX_AttribMods_expiryTime ON $(strschema).AttributeModifiers(expiryTime);
GO
CREATE INDEX IDX_AttributeModifiers_lmt ON $(strschema).AttributeModifiers(localModificationTime);
GO
CREATE INDEX IDX_AttrModiId ON $(strschema).AttributeModifiers(taskRunId, modifierId);
GO

CREATE TABLE $(strschema).ModuleParameterModifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  modifierId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL,
  configXml NVARCHAR(MAX) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuParaModi_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleParameterModifiers PRIMARY KEY(taskRunId, modifierId),
  CONSTRAINT IDX_ModuParaModi_id UNIQUE(globalRowId),
  CONSTRAINT FK_ModuleParameterModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES $(strschema).Modifiers(taskRunId, modifierId)
);
GO

CREATE INDEX IDX_ModParMods_expiryTime ON $(strschema).ModuleParameterModifiers(expiryTime);
GO
CREATE INDEX IDX_ModuParaModi_lmt ON $(strschema).ModuleParameterModifiers(localModificationTime);
GO

CREATE TABLE $(strschema).Tasks(
  taskId VARCHAR(64) NOT NULL, --PK
  creationTaskRunId VARCHAR(64) NOT NULL,
  whatIfId VARCHAR(64),
  workflowId VARCHAR(64) NOT NULL,
  description VARCHAR(255),
  ownerMcId VARCHAR(64) NOT NULL,
  canRunOnFailover NUMERIC(2) NOT NULL,
  cancelPendingOnDispatch NUMERIC(1) CONSTRAINT DEF_TaskPendOnDisp DEFAULT '0' NOT NULL,
  waitWhenAlreadyRunning NUMERIC(1) CONSTRAINT DEF_TaskWhenAlreRunn DEFAULT '0' NOT NULL,
  taskPriority INTEGER NOT NULL,
  taskFirstDueTime DATETIME2(3),
  taskRepeatTime INTEGER,
  encodedTaskRepeatTime VARCHAR(64),
  taskRepeatUntilTime DATETIME2(3),
  taskStatus VARCHAR(1) NOT NULL,
  taskPendingSinceTime DATETIME2(3),
  taskTag VARCHAR(146),
  taskProperties NVARCHAR(MAX),
  expiryTime DATETIME2(3) NOT NULL,
  lastCompletedTaskRunId VARCHAR(64),
  lastCompletedDurationMillis BIGINT CONSTRAINT DEF_TaskCompDuraMill DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Tasks_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Tasks PRIMARY KEY(taskId),
  CONSTRAINT IDX_Tasks_id UNIQUE(globalRowId),
  CONSTRAINT FK_TasksWhatIf FOREIGN KEY(whatIfId) REFERENCES $(strschema).WhatIfScenarios(whatIfId)
);
GO

CREATE INDEX IDX_Tasks_expiry ON $(strschema).Tasks(expiryTime);
GO
CREATE INDEX IDX_Tasks_lmt ON $(strschema).Tasks(localModificationTime);
GO
CREATE INDEX IDX_Tasks_taskStatus ON $(strschema).Tasks(taskStatus);
GO
CREATE INDEX IDX_Tasks_whatIfId ON $(strschema).Tasks(whatIfId);
GO

CREATE TABLE $(strschema).TaskRuns(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskId VARCHAR(64) NOT NULL,
  taskDispatchMcId VARCHAR(64) NOT NULL,
  taskDispatchFssId VARCHAR(30),
  taskDispatchTime DATETIME2(3) NOT NULL,
  taskRunStatus VARCHAR(1) NOT NULL,
  scheduledDispatchTime DATETIME2(3) NOT NULL,
  taskRunCompletionTime DATETIME2(3),
  terminateRequested NUMERIC(1) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  timeZero DATETIME2(3),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TaskRuns_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TaskRuns PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_TaskRuns_id UNIQUE(globalRowId),
  CONSTRAINT FK_TaskRunsTask FOREIGN KEY(taskId) REFERENCES $(strschema).Tasks(taskId),
  CONSTRAINT FK_TaskRuns FOREIGN KEY(taskRunId) REFERENCES $(strschema).SystemActivities(taskRunId)
);
GO

CREATE INDEX IDX_TaskRuns_expiry ON $(strschema).TaskRuns(expiryTime);
GO
CREATE INDEX IDX_TaskRuns_lmt ON $(strschema).TaskRuns(localModificationTime);
GO
CREATE INDEX IDX_TaskRuns_taskId ON $(strschema).TaskRuns(taskId);
GO
CREATE INDEX IDX_TaskRuns_status ON $(strschema).TaskRuns(taskRunStatus);
GO

CREATE TABLE $(strschema).ModuleInstanceRuns(
  taskRunId VARCHAR(64) NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  previousTaskRunId VARCHAR(64),
  expiryTime DATETIME2(3) NOT NULL,
  runStatus NUMERIC(2) CONSTRAINT DEF_ModuInstRunsStat DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuleInstanceRuns_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleInstanceRuns PRIMARY KEY(taskRunId, moduleInstanceId),
  CONSTRAINT IDX_ModuleInstanceRuns_id UNIQUE(globalRowId),
  CONSTRAINT FK_ModuleInstanceRuns FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_ModuleInstanceRuns_et ON $(strschema).ModuleInstanceRuns(expiryTime);
GO
CREATE INDEX IDX_ModuleInstanceRuns_lmt ON $(strschema).ModuleInstanceRuns(localModificationTime);
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

CREATE INDEX IDX_ModuleRunTimes_lmt ON $(strschema).ModuleRunTimes(localModificationTime);
GO
CREATE INDEX IDX_ModuleRunTimes_workflowId_ ON $(strschema).ModuleRunTimes(workflowId, moduleInstanceId);
GO

CREATE TABLE $(strschema).Reports(
  reportId INTEGER NOT NULL, --PK
  taskRunId VARCHAR(64) NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  subjectTaskRunId VARCHAR(64) NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  subDirName VARCHAR(64) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_Reports_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_Reports PRIMARY KEY(reportId, taskRunId, moduleInstanceId),
  CONSTRAINT IDX_Reports_id UNIQUE(globalRowId),
  CONSTRAINT FK_ReportsRun FOREIGN KEY(taskRunId, moduleInstanceId) REFERENCES $(strschema).ModuleInstanceRuns(taskRunId, moduleInstanceId)
);
GO

CREATE INDEX IDX_Reports_expiry ON $(strschema).Reports(expiryTime);
GO
CREATE INDEX IDX_Reports_lmt ON $(strschema).Reports(localModificationTime);
GO

CREATE TABLE $(strschema).ModuleRunTables(
  taskRunId VARCHAR(64) NOT NULL, --PK
  fileId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  fileBlob VARBINARY(MAX) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ModuleRunTables_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ModuleRunTables PRIMARY KEY(taskRunId, fileId),
  CONSTRAINT IDX_ModuleRunTables_id UNIQUE(globalRowId),
  CONSTRAINT FK_ModuleRunTables FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_ModuleRunTables_expiryTime ON $(strschema).ModuleRunTables(expiryTime);
GO
CREATE INDEX IDX_ModuleRunTables_lmt ON $(strschema).ModuleRunTables(localModificationTime);
GO

CREATE TABLE $(strschema).TaskRunCompletions(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskRunCompletionStatus VARCHAR(1) NOT NULL,
  taskRunCompletionTime DATETIME2(3) NOT NULL,
  taskRunProperties NVARCHAR(MAX),
  expiryTime DATETIME2(3) NOT NULL,
  approvedTime DATETIME2(3),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TaskRunCompletions_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TaskRunCompletions PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_TaskRunCompletions_id UNIQUE(globalRowId),
  CONSTRAINT FK_TaskRunCompletions FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_TaskRunCompletions_et ON $(strschema).TaskRunCompletions(expiryTime);
GO
CREATE INDEX IDX_TaskRunCompletions_lmt ON $(strschema).TaskRunCompletions(localModificationTime);
GO

CREATE TABLE $(strschema).ArchiveMetaData(
  taskRunId VARCHAR(64) NOT NULL, --PK
  blob VARBINARY(MAX) NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_ArchiveMetaData_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_ArchiveMetaData PRIMARY KEY(taskRunId),
  CONSTRAINT IDX_ArchiveMetaData_id UNIQUE(globalRowId),
  CONSTRAINT FK_ArchMetaDataTaskRuns FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_ArchiveMetaData_expiry ON $(strschema).ArchiveMetaData(expiryTime);
GO
CREATE INDEX IDX_ArchiveMetaData_lmt ON $(strschema).ArchiveMetaData(localModificationTime);
GO

CREATE TABLE $(strschema).WarmStates(
  taskRunId VARCHAR(64) NOT NULL, --PK
  stateId INTEGER NOT NULL, --PK
  name VARCHAR(255),
  description VARCHAR(255),
  moduleInstanceId VARCHAR(64) NOT NULL,
  blob VARBINARY(MAX) NOT NULL,
  stateTime DATETIME2(3) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  warmStateType NUMERIC(2) CONSTRAINT DEF_WarmStates_warmStateType DEFAULT '0' NOT NULL,
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_WarmStates_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_WarmStates PRIMARY KEY(taskRunId, stateId),
  CONSTRAINT IDX_WarmStates_id UNIQUE(globalRowId),
  CONSTRAINT FK_WarmStates FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_WarmStates_expiry ON $(strschema).WarmStates(expiryTime);
GO
CREATE INDEX IDX_WarmStates_lmt ON $(strschema).WarmStates(localModificationTime);
GO

CREATE TABLE $(strschema).TimeSeries(
  creatorTaskRunId VARCHAR(64) NOT NULL, --PK
  blobId INTEGER NOT NULL, --PK
  modifierId INTEGER,
  sampleId VARCHAR(64),
  moduleInstanceId VARCHAR(64),
  parameterId VARCHAR(2000),
  qualifierSetId VARCHAR(2000),
  locationId VARCHAR(2000) NOT NULL,
  beginTime DATETIME2(3) NOT NULL,
  endTime DATETIME2(3) NOT NULL,
  timeSeriesType INTEGER NOT NULL,
  taskRunId VARCHAR(64),
  ensembleMemberId VARCHAR(2000),
  blob VARBINARY(MAX) NOT NULL,
  blobGZipCompressionRatio NUMERIC(3) CONSTRAINT DEF_TimeSeriBlobGZipCompRati DEFAULT '0' NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime DATETIME2(3) NOT NULL,
  valueType INTEGER NOT NULL,
  timeStepId VARCHAR(64) NOT NULL,
  aggregationPeriod VARCHAR(64),
  repeatCycleId VARCHAR(64),
  externalForecastingStartTime DATETIME2(3),
  constantFlag INTEGER,
  maxValue FLOAT,
  azGZipCompressionRatio NUMERIC(3) CONSTRAINT DEF_TimeSeriAzGZipCompRati DEFAULT '0' NOT NULL,
  a VARBINARY(MAX),
  b VARBINARY(MAX),
  c VARBINARY(MAX),
  d VARBINARY(MAX),
  e VARBINARY(MAX),
  f VARBINARY(MAX),
  g VARBINARY(MAX),
  h VARBINARY(MAX),
  i VARBINARY(MAX),
  j VARBINARY(MAX),
  k VARBINARY(MAX),
  l VARBINARY(MAX),
  m VARBINARY(MAX),
  n VARBINARY(MAX),
  o VARBINARY(MAX),
  p VARBINARY(MAX),
  q VARBINARY(MAX),
  r VARBINARY(MAX),
  s VARBINARY(MAX),
  t VARBINARY(MAX),
  u VARBINARY(MAX),
  v VARBINARY(MAX),
  w VARBINARY(MAX),
  x VARBINARY(MAX),
  y VARBINARY(MAX),
  z VARBINARY(MAX),
  creationTime DATETIME2(3) NOT NULL,
  modificationTime DATETIME2(3) NOT NULL,
  localModificationTime DATETIME2(3) NOT NULL,
  globalRowId BIGINT CONSTRAINT DEF_TimeSeries_rowId DEFAULT NEXT VALUE FOR $(strschema).GlobalRowIdSequence NOT NULL,
  CONSTRAINT PK_TimeSeries PRIMARY KEY(creatorTaskRunId, blobId),
  CONSTRAINT IDX_TimeSeries_id UNIQUE(globalRowId),
  CONSTRAINT FK_TimeSeriesSysactivities FOREIGN KEY(creatorTaskRunId) REFERENCES $(strschema).SystemActivities(taskRunId),
  CONSTRAINT FK_TimeSeries_Modifiers FOREIGN KEY(creatorTaskRunId, modifierId) REFERENCES $(strschema).Modifiers(taskRunId, modifierId),
  CONSTRAINT FK_TimeSeries_TaskRuns FOREIGN KEY(taskRunId) REFERENCES $(strschema).TaskRuns(taskRunId)
);
GO

CREATE INDEX IDX_TimeSeries_expiryTime ON $(strschema).TimeSeries(expiryTime);
GO
CREATE INDEX IDX_TimeSeries_lmt ON $(strschema).TimeSeries(localModificationTime);
GO
CREATE INDEX IDX_TimeSeries_taskRunId ON $(strschema).TimeSeries(taskRunId);
GO
INSERT INTO $(strschema).LastIssuedTimeStamp(singleRowKey, dateTime, modificationTime, creationTime, localModificationTime)
  VALUES (0, '2000-01-01 00:00:00', GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO
INSERT INTO $(strschema).VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM $(strschema).VersionManagement),
    'DATABASE_SCHEMA', 'v2021.01_20200415_1', GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO
INSERT INTO $(strschema).VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM $(strschema).VersionManagement),
    'CURRENT_SCHEMA', 'v2021.01_20200415_1', GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO
INSERT INTO $(strschema).DatabaseSchemaInfo (singleRowKey, maintenanceRunning,
  schemaModificationTime, globalRowIdRegenerationTime, modificationTime, creationTime, localModificationTime) VALUES (0, 0,
  GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO
INSERT INTO $(strschema).LocalMcId (mcId, singleRowKey, modificationTime, creationTime, localModificationTime) VALUES('$(mcId)', 0,
  GETUTCDATE(), GETUTCDATE(), GETUTCDATE());
GO
