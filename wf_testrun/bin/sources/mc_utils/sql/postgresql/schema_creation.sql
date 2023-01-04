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
-- Description:
-- Schema creation script for Postgres 9.4 and higher for the Delft-FEWS database schema sequences, triggers, tables and indexes.
-- Version v2021.01_20200415_1
--
-- Invocation  : psql -f schema_creation.sql -d $1 -v database=$2 -v username=$3
-- Arguments   : $1 - Database instance
--               $2 - Database instance
--               $3 - Database owner user
-- Return      : none
-- Variables   : none
--


-- Input parameters:
\set strusername :username
\set strtbsData :database'_dat01'
\set strtbsIdx :database'_idx01'
\set schemaversion '\'v2021.01_20200415_1\''
\set quoted_mcId '\'' :mcId '\''

-- Set the message level a bit higher to avoid lots of messages (default is NOTICE)
set client_min_messages='WARNING';

DROP SCHEMA :strusername CASCADE;

CREATE SCHEMA :strusername;

CREATE SEQUENCE :strusername.GlobalRowIdSequence START :databaseIntId RESTART :databaseIntId INCREMENT BY 100 MINVALUE :databaseIntId MAXVALUE 9223372036854775807 CACHE 10;
CREATE SEQUENCE :strusername.ConfigRevisionSetsIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE :strusername.EntryIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE :strusername.FewsWebServicesIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE :strusername.ForecastingShellIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE :strusername.TaskIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE :strusername.TaskRunIdSequence START 1 RESTART 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;

CREATE TABLE :strusername.DatabaseSchemaInfo(
  singleRowKey INTEGER NOT NULL, --PK
  maintenanceRunning NUMERIC(1) NOT NULL,
  schemaModificationTime TIMESTAMP(3) NOT NULL,
  globalRowIdRegenerationTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_DatabaseSchemaInfo PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_DatabaseSchemaInfo_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_DatabaseSchemaInfo_lmt ON :strusername.DatabaseSchemaInfo(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LastIssuedTimestamp(
  singleRowKey INTEGER NOT NULL, --PK
  dateTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LastIssuedTimestamp PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LastIssuedTimestamp_lmt ON :strusername.LastIssuedTimestamp(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.VersionManagement(
  versionId VARCHAR(64) NOT NULL, --PK
  componentId VARCHAR(64) NOT NULL, --PK
  entryId INTEGER NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_VersionManagement PRIMARY KEY(versionId, componentId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_VersionManagement_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_VersionManagement_lmt ON :strusername.VersionManagement(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.VersionRunning(
  versionId VARCHAR(64) NOT NULL, --PK
  componentId VARCHAR(64) NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_VersionRunning PRIMARY KEY(versionId, componentId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_VersionRunning_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_VersionRunning_lmt ON :strusername.VersionRunning(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.SystemActivities(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskRunType VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_SystemActivities PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_SystemActivities_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_SystemActivities_et ON :strusername.SystemActivities(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_SystemActivities_lmt ON :strusername.SystemActivities(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LocalMcId(
  singleRowKey INTEGER NOT NULL, --PK
  mcId VARCHAR(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LocalMcId PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_LocalMcId_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LocalMcId_lmt ON :strusername.LocalMcId(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TableLocalModificationTimes(
  tableName VARCHAR(30) NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TableLocalModificationTimes PRIMARY KEY(tableName) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TablLocaModiTime_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TablLocaModiTime_lmt ON :strusername.TableLocalModificationTimes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.BaseBuildFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  hash VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedFile BYTEA NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_BaseBuildFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_BaseBuildFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_BaseBuildFiles_et ON :strusername.BaseBuildFiles(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_BaseBuildFiles ON :strusername.BaseBuildFiles(hash) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_BaseBuildFiles_lmt ON :strusername.BaseBuildFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.BaseBuildFileSets(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  buildType VARCHAR(255) NOT NULL,
  implementationVersion VARCHAR(255) NOT NULL,
  buildNumber INTEGER NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  commentText VARCHAR(255),
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedXml BYTEA NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_BaseBuildFileSets PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_BaseBuildFileSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_BaseBuildFileSets ON :strusername.BaseBuildFileSets(buildType, implementationVersion, buildNumber) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_BaseBuildFileSets_et ON :strusername.BaseBuildFileSets(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_BaseBuildFileSets_lmt ON :strusername.BaseBuildFileSets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ComponentLogFileSnapshots(
  logTaskRunId VARCHAR(64) NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  snapshotZip BYTEA,
  snapshotRequestedTime TIMESTAMP(3),
  snapshotCompletedTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ComponentLogFileSnapshots PRIMARY KEY(logTaskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_CmpLogFileSnapshots_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ComponentLogFileSnapshots FOREIGN KEY(logTaskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_CmpLogFileSnapshots_et ON :strusername.ComponentLogFileSnapshots(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_CmpLogFileSnapshots_lmt ON :strusername.ComponentLogFileSnapshots(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TaskRunLogFiles(
  taskRunId VARCHAR(64) NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedLogFile BYTEA,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TaskRunLogFiles PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TaskRunLogFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TaskRunLogFiles_et ON :strusername.TaskRunLogFiles(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TaskRunLogFiles_lmt ON :strusername.TaskRunLogFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FewsWebServices(
  mcId VARCHAR(64) NOT NULL, --PK
  webServiceId BIGINT NOT NULL, --PK
  hostname VARCHAR(128) NOT NULL,
  name VARCHAR(64) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB INTEGER NOT NULL,
  diskSpaceMB INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_WebServices PRIMARY KEY(mcId, webServiceId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FewsWebServices_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_WebServices FOREIGN KEY(logTaskRunId) REFERENCES :strusername.ComponentLogFileSnapshots(logTaskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FewsWebServices_et ON :strusername.FewsWebServices(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FewsWebServices_lmt ON :strusername.FewsWebServices(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.McSynchStatus(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  remoteMcId VARCHAR(30) NOT NULL,
  enabled NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_McSynchStatus PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_McSynchStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_McSynchStatus_lmt ON :strusername.McSynchStatus(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FssStatus(
  fssRowId BIGINT NOT NULL, --PK
  fssStatus INTEGER NOT NULL,
  lastFssStatusTransitionTime TIMESTAMP(3) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  workflowNodeIndex INTEGER DEFAULT '0' NOT NULL,
  progressPercentage NUMERIC(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FssStatus PRIMARY KEY(fssRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FssStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FssStatus_et ON :strusername.FssStatus(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FssStatus_lmt ON :strusername.FssStatus(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FssResources(
  fssRowId BIGINT NOT NULL, --PK
  claimedSlots INTEGER NOT NULL,
  freeSlots INTEGER NOT NULL,
  cpu FLOAT DEFAULT '0' NOT NULL,
  cpuUsage FLOAT NOT NULL,
  memoryMB INTEGER DEFAULT '0' NOT NULL,
  memoryUsageMB INTEGER NOT NULL,
  javaHeapSpaceUsageMB INTEGER NOT NULL,
  diskSpaceMB INTEGER DEFAULT '0' NOT NULL,
  diskSpaceUsageMB INTEGER NOT NULL,
  dbConnectionCount FLOAT NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FssResource PRIMARY KEY(fssRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FssResources_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FssResources_et ON :strusername.FssResources(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FssResources_lmt ON :strusername.FssResources(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Users(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userName VARCHAR(30) NOT NULL,
  userDisplayName VARCHAR(128),
  emailAddress VARCHAR(512),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Users PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Users_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Users_lmt ON :strusername.Users(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Users ON :strusername.Users(userName) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.AccessKeyHashes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  accessKeyHash VARCHAR(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_AccessKeyHashes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_AccessKeyHashes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_AccessKeyHashes FOREIGN KEY(userMcId, userEntryId) REFERENCES :strusername.Users(mcId, entryId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_AccessKeyHashes_lmt ON :strusername.AccessKeyHashes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.UserToGroupsMappings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  userGroup VARCHAR(30) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_UserToGroupsMappings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_UserToGroupsMappings_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_UserToGroupsMappings FOREIGN KEY(userMcId, userEntryId) REFERENCES :strusername.Users(mcId, entryId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_UserToGroupsMappings_lmt ON :strusername.UserToGroupsMappings(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.UserSettings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  userMcId VARCHAR(64) NOT NULL,
  userEntryId BIGINT NOT NULL,
  compressedUserSettingsFile BYTEA NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_UserSettings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_UserSettings_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_UserSettings FOREIGN KEY(userMcId, userEntryId) REFERENCES :strusername.Users(mcId, entryId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_UserSettings_lmt ON :strusername.UserSettings(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.IndexFilesSnapshots(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  formatVersion VARCHAR(64) NOT NULL,
  zipBlob BYTEA,
  snapshotTime TIMESTAMP(3),
  globalRowIdRegenerationTime TIMESTAMP(3),
  updateInProgressHeartbeat TIMESTAMP(3),
  fullRebuildRequested NUMERIC(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_IndexFilesSnapshots PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_IndexFilesSnapshots_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_IndexFilesSnapshots_et ON :strusername.IndexFilesSnapshots(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_IndexFilesSnapshots_lmt ON :strusername.IndexFilesSnapshots(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_IndexFilesSnapshots ON :strusername.IndexFilesSnapshots(mcId, formatVersion) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.MCConfigFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  patchFileBlob BYTEA,
  compressedXml BYTEA,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_MCConfigFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_MCConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_MCConfigFiles_lmt ON :strusername.MCConfigFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.CMConfigFiles(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  buildType VARCHAR(255) DEFAULT 'none' NOT NULL,
  implementationVersion VARCHAR(255) DEFAULT 'none' NOT NULL,
  buildNumber INTEGER DEFAULT '0' NOT NULL,
  creationUserId VARCHAR(30) DEFAULT 'none' NOT NULL,
  commentText VARCHAR(255),
  patchFileBlob BYTEA,
  compressedXml BYTEA,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_CMConfigFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_CMConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_CMConfigFiles_lmt ON :strusername.CMConfigFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LocalSynchTimes(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  remoteMcId VARCHAR(64) NOT NULL,
  tableName VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  maxAgeMillis BIGINT,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  lastSuccessfulSynchStartTime TIMESTAMP(3),
  lastFailedTime TIMESTAMP(3),
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
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LocalSynchTimes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_LocalSynchTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LocalSynchTimes_lmt ON :strusername.LocalSynchTimes(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LocalSynchTimes ON :strusername.LocalSynchTimes(mcId, remoteMcId, tableName, synchLevel) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.DeletedRows(
  deletedGlobalRowIds BYTEA NOT NULL,
  componentId VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL, --PK
  CONSTRAINT PK_DeletedRows PRIMARY KEY(globalRowId) USING INDEX TABLESPACE :strtbsIdx --PK
) TABLESPACE :strtbsData;

CREATE INDEX IDX_DeletedRows_et ON :strusername.DeletedRows(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_DeletedRows_lmt ON :strusername.DeletedRows(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ProcessedDeletedRows(
  processedGlobalRowId BIGINT NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  durationMillis BIGINT NOT NULL,
  deletedRowCount INTEGER NOT NULL,
  failedRowCount INTEGER NOT NULL,
  firstFailedTable VARCHAR(30),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ProcessedDeletedRows PRIMARY KEY(processedGlobalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ProcessedDeletedRows_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ProcessedDeletedRows_et ON :strusername.ProcessedDeletedRows(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ProcessedDeletedRows_lmt ON :strusername.ProcessedDeletedRows(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.RollingBarrelTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  lastFailedTime TIMESTAMP(3),
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
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_RollingBarrelTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_RollingBarrelTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_RollingBarrelTimes_lmt ON :strusername.RollingBarrelTimes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LiveMcAvailabilities(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  isFailover NUMERIC(2),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LiveMcAvailabilities PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_LiveMcAvailabilities_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LiveMcAvailabilities_lmt ON :strusername.LiveMcAvailabilities(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LiveMcAvailabilities ON :strusername.LiveMcAvailabilities(mcId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.CoefficientSets(
  coefficientSetsId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_CoefficientSets PRIMARY KEY(coefficientSetsId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_CoefficientSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_CoefficientSets_et ON :strusername.CoefficientSets(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_CoefficientSets_lmt ON :strusername.CoefficientSets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ColdStates(
  coldStateId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ColdStates PRIMARY KEY(coldStateId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ColdStates_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ColdStates_et ON :strusername.ColdStates(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ColdStates_lmt ON :strusername.ColdStates(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.CorrelationEventSets(
  eventSetsId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_CorrEvSet PRIMARY KEY(eventSetsId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_CorrelationEventSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_CorrelationEventSets_et ON :strusername.CorrelationEventSets(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_CorrelationEventSets_lmt ON :strusername.CorrelationEventSets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.CorrelationTravelTimes(
  travelTimesId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_CorrTrTime PRIMARY KEY(travelTimesId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_CorrelationTravelTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_CorrelationTravelTimes_et ON :strusername.CorrelationTravelTimes(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_CorrelationTravelTimes_lmt ON :strusername.CorrelationTravelTimes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.DisplayConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_DisplayConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_DisplayConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_DisplayConfigurations_et ON :strusername.DisplayConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_DisplayConfigurations_lmt ON :strusername.DisplayConfigurations(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FlagConversions(
  flagConversionId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FlagConversions PRIMARY KEY(flagConversionId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FlagConversions_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FlagConversions_et ON :strusername.FlagConversions(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FlagConversions_lmt ON :strusername.FlagConversions(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Icons(
  iconId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Icons PRIMARY KEY(iconId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Icons_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Icons_et ON :strusername.Icons(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Icons_lmt ON :strusername.Icons(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.IdMaps(
  idMapId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_IdMaps PRIMARY KEY(idMapId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_IdMaps_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_IdMaps_et ON :strusername.IdMaps(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_IdMaps_lmt ON :strusername.IdMaps(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.MapLayers(
  mapLayerId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_MapLayers PRIMARY KEY(mapLayerId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_MapLayers_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_MapLayers_et ON :strusername.MapLayers(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_MapLayers_lmt ON :strusername.MapLayers(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleInstanceConfigs(
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleInstanceConfigs PRIMARY KEY(moduleInstanceId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceConfigs_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModuleInstanceConfigs_et ON :strusername.ModuleInstanceConfigs(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleInstanceConfigs_lmt ON :strusername.ModuleInstanceConfigs(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleInstanceDatasets(
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleInstanceDatasets PRIMARY KEY(moduleInstanceId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceDatasets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModuleInstanceDatasets_et ON :strusername.ModuleInstanceDatasets(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleInstanceDatasets_lmt ON :strusername.ModuleInstanceDatasets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleParameters(
  moduleParameterId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModParams PRIMARY KEY(moduleParameterId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleParameters_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModuleParameters_et ON :strusername.ModuleParameters(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleParameters_lmt ON :strusername.ModuleParameters(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.PiClientConfigurations(
  clientId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_PiClientConfigurations PRIMARY KEY(clientId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_PiClientConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_PiClientConfigurations_et ON :strusername.PiClientConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_PiClientConfigurations_lmt ON :strusername.PiClientConfigurations(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.PiServiceConfigurations(
  clientId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_PiServiceConfigurations PRIMARY KEY(clientId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_PiServiceConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_PiServiceConfigurations_et ON :strusername.PiServiceConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_PiServConf_lmt ON :strusername.PiServiceConfigurations(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.RegionConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_RegionConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_RegionConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_RegionConfigurations_et ON :strusername.RegionConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_RegionConfigurations_lmt ON :strusername.RegionConfigurations(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ReportImages(
  reportImageId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ReportImages PRIMARY KEY(reportImageId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ReportImages_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ReportImages_et ON :strusername.ReportImages(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ReportImages_lmt ON :strusername.ReportImages(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ReportTemplates(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_RepTemp PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ReportTemplates_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ReportTemplates_et ON :strusername.ReportTemplates(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ReportTemplates_lmt ON :strusername.ReportTemplates(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.RootConfigFiles(
  rootConfigFileId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  blob BYTEA NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_RootConfigFiles PRIMARY KEY(rootConfigFileId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_RootConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_RootConfigFiles_et ON :strusername.RootConfigFiles(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_RootConfigFiles_lmt ON :strusername.RootConfigFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.SystemConfigurations(
  configTypeId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_SystemConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_SystemConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_SystemConfigurations_et ON :strusername.SystemConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_SystemConfigurations_lmt ON :strusername.SystemConfigurations(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.UnitConversions(
  unitConversionId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_UnitConversions PRIMARY KEY(unitConversionId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_UnitConversions_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_UnitConversions_et ON :strusername.UnitConversions(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_UnitConversions_lmt ON :strusername.UnitConversions(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.WorkflowFiles(
  workflowId VARCHAR(64) NOT NULL, --PK
  version VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  synchLevel INTEGER NOT NULL,
  configXml TEXT NOT NULL,
  hash VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_WorkflowFiles PRIMARY KEY(workflowId, version) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_WorkflowFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_WorkflowFiles_et ON :strusername.WorkflowFiles(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_WorkflowFiles_lmt ON :strusername.WorkflowFiles(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ConfigRevisionSets(
  revisionId VARCHAR(64) NOT NULL, --PK
  creationUserId VARCHAR(30) NOT NULL,
  commentText VARCHAR(255),
  numberOfChanges INTEGER NOT NULL,
  dataSet BYTEA NOT NULL,
  mcUpdateRequestTime TIMESTAMP(3),
  encodedPartitionSequencesXml TEXT,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ConfigRevisionSets PRIMARY KEY(revisionId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ConfigRevisionSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ConfigRevisionSets_lmt ON :strusername.ConfigRevisionSets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.AiServletUsers(
  userName VARCHAR(16) NOT NULL, --PK
  password BYTEA NOT NULL,
  fullName VARCHAR(32) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_AiServletUsers PRIMARY KEY(userName) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_AiServletUsers_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_AiServletUsers_lmt ON :strusername.AiServletUsers(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.MasterControllers(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  hostname VARCHAR(128) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB INTEGER NOT NULL,
  diskSpaceMB INTEGER NOT NULL,
  databaseIntId INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3),
  mcStatus INTEGER DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_MasterControllers PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_MasterControllers_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_MasterControllers FOREIGN KEY(logTaskRunId) REFERENCES :strusername.ComponentLogFileSnapshots(logTaskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_MasterControllers_lmt ON :strusername.MasterControllers(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LogEventProcessorTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LogEventProcessorTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_LogEventProcessorTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LogEventProcessorTimes_lmt ON :strusername.LogEventProcessorTimes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TaskRunDispatcherTimes(
  singleRowKey INTEGER NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TaskRunDispatcherTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TaskRunDispatcherTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TaskRunDispatcherTimes_lmt ON :strusername.TaskRunDispatcherTimes(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FssGroups(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  fssGroupId VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255),
  priority INTEGER DEFAULT '0' NOT NULL,
  allowUnmapped NUMERIC(1) DEFAULT '1' NOT NULL,
  readyCount INTEGER DEFAULT '1' NOT NULL,
  maxAwakeCount INTEGER,
  gotoSleepSeconds INTEGER,
  releaseSlotsSeconds INTEGER,
  fssGroupStatus VARCHAR(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FssGroups PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FssGroups_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FssGroups_lmt ON :strusername.FssGroups(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FssGroups ON :strusername.FssGroups(mcId, fssGroupId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ForecastingShells(
  mcId VARCHAR(64) NOT NULL, --PK
  fssId BIGINT NOT NULL, --PK
  mcEntryId BIGINT NOT NULL,
  fssGroupEntryId BIGINT NOT NULL,
  hostname VARCHAR(128) NOT NULL,
  regionHome VARCHAR(1000) DEFAULT '/opt/fews/fss/1' NOT NULL,
  hostSlotCount INTEGER NOT NULL,
  indexAtHost INTEGER NOT NULL,
  awakenedByIndexAtHost INTEGER NOT NULL,
  logTaskRunId VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  cpu FLOAT DEFAULT '0' NOT NULL,
  memoryMB INTEGER DEFAULT '0' NOT NULL,
  diskSpaceMB INTEGER DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ForecastingShells PRIMARY KEY(mcId, fssId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ForecastingShells_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ForecastingShells FOREIGN KEY(logTaskRunId) REFERENCES :strusername.ComponentLogFileSnapshots(logTaskRunId),
  CONSTRAINT FK_ForecastingShells2 FOREIGN KEY(mcId, fssGroupEntryId) REFERENCES :strusername.FssGroups(mcId, entryId),
  CONSTRAINT FK_ForecastingShells1 FOREIGN KEY(mcId, mcEntryId) REFERENCES :strusername.MasterControllers(mcId, entryId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ForecastingShells_et ON :strusername.ForecastingShells(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ForecastingShells_lmt ON :strusername.ForecastingShells(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.WorkflowTargetFsss(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  workflowId VARCHAR(64) NOT NULL,
  fssGroupId VARCHAR(64) NOT NULL,
  fssPendingRunStatus INTEGER,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_WorkflowTargetFsss PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_WorkflowTargetFsss_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_WorkflowTargetFsss_lmt ON :strusername.WorkflowTargetFsss(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_WorkflowTargetFsss ON :strusername.WorkflowTargetFsss(mcId, workflowId, fssGroupId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.McFailoverPriorities(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  priority INTEGER,
  visible NUMERIC(1) DEFAULT '0' NOT NULL,
  active NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_McFailoverPriorities PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_McFailoverPriorities_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_McFailoverPriorities_lmt ON :strusername.McFailoverPriorities(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_McFailoverPriorities ON :strusername.McFailoverPriorities(mcId, priority) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ActionConfigurations(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  actionId VARCHAR(64) NOT NULL,
  version VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  creationUserId VARCHAR(30) NOT NULL,
  configXml TEXT NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ActionConfigurations PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ActionConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ActionConfigurations_et ON :strusername.ActionConfigurations(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ActionConfigurations_lmt ON :strusername.ActionConfigurations(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ActionConfigurations ON :strusername.ActionConfigurations(mcId, actionId, version) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.EventActionMappings(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  actionId VARCHAR(64) NOT NULL,
  eventCode VARCHAR(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_EventActionMappings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_EventActionMappings_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_EventActionMappings_lmt ON :strusername.EventActionMappings(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_EventActionMappings ON :strusername.EventActionMappings(mcId, eventCode, actionId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ImportStatus(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  dataFeedId VARCHAR(64) NOT NULL,
  directory VARCHAR(128) NOT NULL,
  lastImportTime TIMESTAMP(3) NOT NULL,
  lastFileImported VARCHAR(128) NOT NULL,
  filesReadCount INTEGER NOT NULL,
  filesFailedCount INTEGER NOT NULL,
  log TEXT,
  importState TEXT,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ImportStatus PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ImportStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ImportStatus_expiry ON :strusername.ImportStatus(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ImportStatus_lmt ON :strusername.ImportStatus(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ImportStatus ON :strusername.ImportStatus(mcId, dataFeedId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ProductInfo(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  productId VARCHAR(64) NOT NULL,
  startForecastTime TIMESTAMP(3) NOT NULL,
  endForecastTime TIMESTAMP(3) NOT NULL,
  productInfoXml TEXT NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ProductInfo PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ProductInfo_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ProductInfo_et ON :strusername.ProductInfo(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ProductInfo_lmt ON :strusername.ProductInfo(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ProductInfo_id_start_end ON :strusername.ProductInfo(productId, startForecastTime, endForecastTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ExternalForecastVisibility(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  productId VARCHAR(64) NOT NULL,
  externalForecastTime TIMESTAMP(3) NOT NULL,
  visible NUMERIC(1),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ExternalForecastVisibility PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ExtForVis_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ExtForVis_et ON :strusername.ExternalForecastVisibility(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ExtForVis_lmt ON :strusername.ExternalForecastVisibility(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TimeSeriesStatusSnapshots(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  timeZero TIMESTAMP(3) NOT NULL,
  blob BYTEA NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TimeSeriesStatusSnapshot PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TimeSeriStatSnap_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TimeSeriStatSnap_lmt ON :strusername.TimeSeriesStatusSnapshots(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TimeSeriesStatusSnapshots ON :strusername.TimeSeriesStatusSnapshots(mcId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FewsSessions(
  taskRunId VARCHAR(64) NOT NULL, --PK
  ocAddress VARCHAR(64) NOT NULL,
  userId VARCHAR(30) NOT NULL,
  sessionMcId VARCHAR(64) NOT NULL,
  loginTime TIMESTAMP(3) NOT NULL,
  lastRequestTime TIMESTAMP(3),
  sessionType NUMERIC(2) NOT NULL,
  pid INTEGER,
  description VARCHAR(255),
  clientSystemInfo TEXT,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FewsSessions PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FewsSessions_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_FewsSessions FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FewsSessions_et ON :strusername.FewsSessions(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FewsSessions_lmt ON :strusername.FewsSessions(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.HistoricalEvents(
  taskRunId VARCHAR(64) NOT NULL, --PK
  eventId VARCHAR(64) NOT NULL, --PK
  name VARCHAR(64) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  eventXml TEXT NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_HistoricalEvents PRIMARY KEY(taskRunId, eventId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_HistoricalEvents_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_HistoricalEvents FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_HistoricalEvents_expiry ON :strusername.HistoricalEvents(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_HistoricalEvents_lmt ON :strusername.HistoricalEvents(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.FloodPeriods(
  taskRunId VARCHAR(64) NOT NULL, --PK
  periodId VARCHAR(64) NOT NULL, --PK
  areaId VARCHAR(64) NOT NULL,
  persistentBeginTime TIMESTAMP(3) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  description VARCHAR(64),
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  eventTime TIMESTAMP(3),
  eventThresholdId VARCHAR(64),
  eventLocationId VARCHAR(64),
  eventParameterId VARCHAR(64),
  periodStatus NUMERIC(2) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_FloodPeriods PRIMARY KEY(taskRunId, periodId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_FloodPeriods_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_FloodPeriods FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_FloodPeriod_expiry ON :strusername.FloodPeriods(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_FloodPeriods_lmt ON :strusername.FloodPeriods(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.LogEntries(
  taskRunId VARCHAR(64) NOT NULL, --PK
  logEntryId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64),
  synchLevel INTEGER NOT NULL,
  logLevel INTEGER NOT NULL,
  eventCode VARCHAR(255),
  eventAcknowledged INTEGER NOT NULL,
  eventProcessed INTEGER DEFAULT '0' NOT NULL,
  buildNumber INTEGER DEFAULT '0' NOT NULL,
  logMessage TEXT NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_LogEntries PRIMARY KEY(taskRunId, logEntryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_LogEntries_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_LogEntries FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_LogEntries_ct ON :strusername.LogEntries(creationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LogEntries_eventCode ON :strusername.LogEntries(eventCode) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LogEntries_processed ON :strusername.LogEntries(eventProcessed) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LogEntries_expiry ON :strusername.LogEntries(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LogEntries_lmt ON :strusername.LogEntries(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_LogEntries_logLevel ON :strusername.LogEntries(logLevel) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Samples(
  taskRunId VARCHAR(64) NOT NULL, --PK
  sampleId INTEGER NOT NULL, --PK
  externalSampleId VARCHAR(64) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  locationId VARCHAR(64) NOT NULL,
  dateTime TIMESTAMP(3) NOT NULL,
  visible NUMERIC(1) NOT NULL,
  sampleProperties TEXT NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Samples PRIMARY KEY(taskRunId, sampleId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Samples_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_Samples FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Samples_expiry ON :strusername.Samples(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Samples_lmt ON :strusername.Samples(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.PiClientDataSets(
  mcId VARCHAR(64) NOT NULL, --PK
  entryId BIGINT NOT NULL, --PK
  dataSetId VARCHAR(64) NOT NULL,
  nodeId VARCHAR(64) NOT NULL,
  clientId VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  dataSet BYTEA NOT NULL,
  visible NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_PiClientDataSets PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_PiClientDataSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_PiClientDataSets ON :strusername.PiClientDataSets(dataSetId, clientId) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_PiClientDataSets_lmt ON :strusername.PiClientDataSets(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ThresholdEvents(
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
  eventTime TIMESTAMP(3) NOT NULL,
  eventValue FLOAT NOT NULL,
  eventActionId VARCHAR(64),
  eventIssued NUMERIC(1),
  expiryTime TIMESTAMP(3) NOT NULL,
  taskRunIdTimeZero TIMESTAMP(3),
  exportTime TIMESTAMP(3),
  acknowledgedBy VARCHAR(64),
  acknowledgedTime TIMESTAMP(3),
  targetLocationId VARCHAR(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ThresholdEvents PRIMARY KEY(taskRunId, eventEntryId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ThresholdEvents_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ThresholdEvents_ct ON :strusername.ThresholdEvents(creationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ThresholdEvents_expiry ON :strusername.ThresholdEvents(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ThresholdEvents_lmt ON :strusername.ThresholdEvents(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ThresholdEvents_mt ON :strusername.ThresholdEvents(modificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.WhatIfScenarios(
  whatIfId VARCHAR(64) NOT NULL, --PK
  userDefinedId VARCHAR(64) NOT NULL,
  parentWhatIfId VARCHAR(64),
  description VARCHAR(255),
  creationTaskRunId VARCHAR(64),
  whatIfConfig TEXT NOT NULL,
  visible NUMERIC(1) NOT NULL,
  persistent NUMERIC(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  name VARCHAR(64),
  pendingDeletion NUMERIC(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_WhatIfScenaios PRIMARY KEY(whatIfId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_WhatIfScenarios_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx
) TABLESPACE :strtbsData;

CREATE INDEX IDX_WhatIfScenarios_expiry ON :strusername.WhatIfScenarios(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_WhatIfScenarios_lmt ON :strusername.WhatIfScenarios(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Modifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  modifierId INTEGER NOT NULL, --PK
  whatIfId VARCHAR(64),
  name VARCHAR(64) NOT NULL,
  description VARCHAR(255) NOT NULL,
  modType VARCHAR(64) NOT NULL,
  priority INTEGER NOT NULL,
  userId VARCHAR(30) NOT NULL,
  enabled NUMERIC(1) NOT NULL,
  enabledInEnsembleRun NUMERIC(1) DEFAULT '0' NOT NULL,
  enabledPeriodStartTime TIMESTAMP(3),
  enabledPeriodEndTime TIMESTAMP(3),
  validTime TIMESTAMP(3),
  visible NUMERIC(1) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  userCreationTime TIMESTAMP(3),
  userModificationTime TIMESTAMP(3),
  creatorUserId VARCHAR(30),
  previousTaskRunId VARCHAR(64),
  previousModifierId INTEGER,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Modifiers PRIMARY KEY(taskRunId, modifierId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Modifiers_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_Modifiers FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId),
  CONSTRAINT FK_Modifiers_whatIf FOREIGN KEY(whatIfId) REFERENCES :strusername.WhatIfScenarios(whatIfId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Modifiers_expiryTime ON :strusername.Modifiers(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Modifiers_lmt ON :strusername.Modifiers(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Modifiers_whatIfId ON :strusername.Modifiers(whatIfId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.AttributeModifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  attributeModifierId INTEGER NOT NULL, --PK
  modifierId INTEGER NOT NULL,
  locationId VARCHAR(64) NOT NULL,
  attributeId VARCHAR(64) NOT NULL,
  attributeText VARCHAR(2000),
  attributeNumber FLOAT,
  attributeBoolean INTEGER,
  attributeTime TIMESTAMP(3),
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_AttributeModifiers PRIMARY KEY(taskRunId, attributeModifierId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_AttributeModifiers_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_AttribModifiersModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES :strusername.Modifiers(taskRunId, modifierId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_AttribMods_expiryTime ON :strusername.AttributeModifiers(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_AttributeModifiers_lmt ON :strusername.AttributeModifiers(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_AttrModiId ON :strusername.AttributeModifiers(taskRunId, modifierId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleParameterModifiers(
  taskRunId VARCHAR(64) NOT NULL, --PK
  modifierId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL,
  configXml TEXT NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleParameterModifiers PRIMARY KEY(taskRunId, modifierId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuParaModi_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ModuleParameterModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES :strusername.Modifiers(taskRunId, modifierId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModParMods_expiryTime ON :strusername.ModuleParameterModifiers(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuParaModi_lmt ON :strusername.ModuleParameterModifiers(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Tasks(
  taskId VARCHAR(64) NOT NULL, --PK
  creationTaskRunId VARCHAR(64) NOT NULL,
  whatIfId VARCHAR(64),
  workflowId VARCHAR(64) NOT NULL,
  description VARCHAR(255),
  ownerMcId VARCHAR(64) NOT NULL,
  canRunOnFailover NUMERIC(2) NOT NULL,
  cancelPendingOnDispatch NUMERIC(1) DEFAULT '0' NOT NULL,
  waitWhenAlreadyRunning NUMERIC(1) DEFAULT '0' NOT NULL,
  taskPriority INTEGER NOT NULL,
  taskFirstDueTime TIMESTAMP(3),
  taskRepeatTime INTEGER,
  encodedTaskRepeatTime VARCHAR(64),
  taskRepeatUntilTime TIMESTAMP(3),
  taskStatus VARCHAR(1) NOT NULL,
  taskPendingSinceTime TIMESTAMP(3),
  taskTag VARCHAR(146),
  taskProperties TEXT,
  expiryTime TIMESTAMP(3) NOT NULL,
  lastCompletedTaskRunId VARCHAR(64),
  lastCompletedDurationMillis BIGINT DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Tasks PRIMARY KEY(taskId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Tasks_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_TasksWhatIf FOREIGN KEY(whatIfId) REFERENCES :strusername.WhatIfScenarios(whatIfId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Tasks_expiry ON :strusername.Tasks(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Tasks_lmt ON :strusername.Tasks(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Tasks_taskStatus ON :strusername.Tasks(taskStatus) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Tasks_whatIfId ON :strusername.Tasks(whatIfId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TaskRuns(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskId VARCHAR(64) NOT NULL,
  taskDispatchMcId VARCHAR(64) NOT NULL,
  taskDispatchFssId VARCHAR(30),
  taskDispatchTime TIMESTAMP(3) NOT NULL,
  taskRunStatus VARCHAR(1) NOT NULL,
  scheduledDispatchTime TIMESTAMP(3) NOT NULL,
  taskRunCompletionTime TIMESTAMP(3),
  terminateRequested NUMERIC(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  timeZero TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TaskRuns PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TaskRuns_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_TaskRunsTask FOREIGN KEY(taskId) REFERENCES :strusername.Tasks(taskId),
  CONSTRAINT FK_TaskRuns FOREIGN KEY(taskRunId) REFERENCES :strusername.SystemActivities(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TaskRuns_expiry ON :strusername.TaskRuns(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TaskRuns_lmt ON :strusername.TaskRuns(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TaskRuns_taskId ON :strusername.TaskRuns(taskId) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TaskRuns_status ON :strusername.TaskRuns(taskRunStatus) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleInstanceRuns(
  taskRunId VARCHAR(64) NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  previousTaskRunId VARCHAR(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  runStatus NUMERIC(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleInstanceRuns PRIMARY KEY(taskRunId, moduleInstanceId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceRuns_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ModuleInstanceRuns FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModuleInstanceRuns_et ON :strusername.ModuleInstanceRuns(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleInstanceRuns_lmt ON :strusername.ModuleInstanceRuns(localModificationTime) TABLESPACE :strtbsIdx;

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

CREATE INDEX IDX_ModuleRunTimes_lmt ON :strusername.ModuleRunTimes(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleRunTimes_workflowId_ ON :strusername.ModuleRunTimes(workflowId, moduleInstanceId) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.Reports(
  reportId INTEGER NOT NULL, --PK
  taskRunId VARCHAR(64) NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL, --PK
  subjectTaskRunId VARCHAR(64) NOT NULL,
  blob BYTEA NOT NULL,
  subDirName VARCHAR(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_Reports PRIMARY KEY(reportId, taskRunId, moduleInstanceId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_Reports_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ReportsRun FOREIGN KEY(taskRunId, moduleInstanceId) REFERENCES :strusername.ModuleInstanceRuns(taskRunId, moduleInstanceId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_Reports_expiry ON :strusername.Reports(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_Reports_lmt ON :strusername.Reports(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ModuleRunTables(
  taskRunId VARCHAR(64) NOT NULL, --PK
  fileId INTEGER NOT NULL, --PK
  moduleInstanceId VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  fileBlob BYTEA NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ModuleRunTables PRIMARY KEY(taskRunId, fileId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ModuleRunTables_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ModelRunTables FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ModuleRunTables_expiryTime ON :strusername.ModuleRunTables(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ModuleRunTables_lmt ON :strusername.ModuleRunTables(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TaskRunCompletions(
  taskRunId VARCHAR(64) NOT NULL, --PK
  taskRunCompletionStatus VARCHAR(1) NOT NULL,
  taskRunCompletionTime TIMESTAMP(3) NOT NULL,
  taskRunProperties TEXT,
  expiryTime TIMESTAMP(3) NOT NULL,
  approvedTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TaskRunCompletions PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TaskRunCompletions_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_TaskRunCompletions FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TaskRunCompletions_et ON :strusername.TaskRunCompletions(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TaskRunCompletions_lmt ON :strusername.TaskRunCompletions(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.ArchiveMetaData(
  taskRunId VARCHAR(64) NOT NULL, --PK
  blob BYTEA NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_ArchiveMetaData PRIMARY KEY(taskRunId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_ArchiveMetaData_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_ArchMetaDataTaskRuns FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_ArchiveMetaData_expiry ON :strusername.ArchiveMetaData(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_ArchiveMetaData_lmt ON :strusername.ArchiveMetaData(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.WarmStates(
  taskRunId VARCHAR(64) NOT NULL, --PK
  stateId INTEGER NOT NULL, --PK
  name VARCHAR(255),
  description VARCHAR(255),
  moduleInstanceId VARCHAR(64) NOT NULL,
  blob BYTEA NOT NULL,
  stateTime TIMESTAMP(3) NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  warmStateType NUMERIC(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_WarmStates PRIMARY KEY(taskRunId, stateId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_WarmStates_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_WarmStates FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_WarmStates_expiry ON :strusername.WarmStates(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_WarmStates_lmt ON :strusername.WarmStates(localModificationTime) TABLESPACE :strtbsIdx;

CREATE TABLE :strusername.TimeSeries(
  creatorTaskRunId VARCHAR(64) NOT NULL, --PK
  blobId INTEGER NOT NULL, --PK
  modifierId INTEGER,
  sampleId VARCHAR(64),
  moduleInstanceId VARCHAR(64),
  parameterId VARCHAR(2000),
  qualifierSetId VARCHAR(2000),
  locationId VARCHAR(2000) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  timeSeriesType INTEGER NOT NULL,
  taskRunId VARCHAR(64),
  ensembleMemberId VARCHAR(2000),
  blob BYTEA NOT NULL,
  blobGZipCompressionRatio NUMERIC(3) DEFAULT '0' NOT NULL,
  synchLevel INTEGER NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  valueType INTEGER NOT NULL,
  timeStepId VARCHAR(64) NOT NULL,
  aggregationPeriod VARCHAR(64),
  repeatCycleId VARCHAR(64),
  externalForecastingStartTime TIMESTAMP(3),
  constantFlag INTEGER,
  maxValue FLOAT,
  azGZipCompressionRatio NUMERIC(3) DEFAULT '0' NOT NULL,
  a BYTEA,
  b BYTEA,
  c BYTEA,
  d BYTEA,
  e BYTEA,
  f BYTEA,
  g BYTEA,
  h BYTEA,
  i BYTEA,
  j BYTEA,
  k BYTEA,
  l BYTEA,
  m BYTEA,
  n BYTEA,
  o BYTEA,
  p BYTEA,
  q BYTEA,
  r BYTEA,
  s BYTEA,
  t BYTEA,
  u BYTEA,
  v BYTEA,
  w BYTEA,
  x BYTEA,
  y BYTEA,
  z BYTEA,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId BIGINT DEFAULT nextval('globalrowidsequence') NOT NULL,
  CONSTRAINT PK_TimeSeries PRIMARY KEY(creatorTaskRunId, blobId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT IDX_TimeSeries_id UNIQUE(globalRowId) USING INDEX TABLESPACE :strtbsIdx,
  CONSTRAINT FK_TimeSeriesSysactivities FOREIGN KEY(creatorTaskRunId) REFERENCES :strusername.SystemActivities(taskRunId),
  CONSTRAINT FK_TimeSeries_Modifiers FOREIGN KEY(creatorTaskRunId, modifierId) REFERENCES :strusername.Modifiers(taskRunId, modifierId),
  CONSTRAINT FK_TimeSeries_TaskRuns FOREIGN KEY(taskRunId) REFERENCES :strusername.TaskRuns(taskRunId)
) TABLESPACE :strtbsData;

CREATE INDEX IDX_TimeSeries_expiryTime ON :strusername.TimeSeries(expiryTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TimeSeries_lmt ON :strusername.TimeSeries(localModificationTime) TABLESPACE :strtbsIdx;
CREATE INDEX IDX_TimeSeries_taskRunId ON :strusername.TimeSeries(taskRunId) TABLESPACE :strtbsIdx;

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

CREATE RULE RULE_WARMSTATES_IGNORE_PK_VIOLATION AS ON INSERT TO :strusername.WarmStates
  WHERE EXISTS (SELECT 1 FROM :strusername.WarmStates WHERE taskRunId = NEW.taskRunId AND stateId = NEW.stateId)
  DO INSTEAD NOTHING;

CREATE RULE RULE_MODULEINSTACERUNS_IGNORE_PK_VIOLATION AS ON INSERT TO :strusername.ModuleInstanceRuns
  WHERE EXISTS (SELECT 1 FROM :strusername.ModuleInstanceRuns WHERE taskRunId = NEW.taskRunId AND moduleInstanceId = NEW.moduleInstanceId)
  DO INSTEAD NOTHING;

CREATE RULE RULE_LOGENTRIES_IGNORE_PK_VIOLATION AS ON INSERT TO :strusername.LogEntries
  WHERE EXISTS (SELECT 1 FROM :strusername.LogEntries WHERE taskRunId = NEW.taskRunId AND logEntryId = NEW.logEntryId)
  DO INSTEAD NOTHING;

CREATE RULE RULE_ARCHIVEMETADATA_IGNORE_PK_VIOLATION AS ON INSERT TO :strusername.ArchiveMetaData
  WHERE EXISTS (SELECT 1 FROM :strusername.ArchiveMetaData WHERE taskRunId = NEW.taskRunId)
  DO INSTEAD NOTHING;

INSERT INTO :strusername.LastIssuedTimeStamp(singleRowKey, dateTime, modificationTime, creationTime, localModificationTime)
  VALUES (0, '2000-01-01 00:00:00', CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO :strusername.VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM VersionManagement), 'DATABASE_SCHEMA',
  :schemaversion, CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO :strusername.VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT CASE WHEN MAX(entryId) IS NULL THEN 1 ELSE MAX(entryId)+1 END FROM VersionManagement), 'CURRENT_SCHEMA',
  :schemaversion, CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO :strusername.DatabaseSchemaInfo (singleRowKey, maintenanceRunning,
  schemaModificationTime, globalRowIdRegenerationTime, modificationTime, creationTime, localModificationTime) VALUES (0, 0,
  CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT',
  CURRENT_TIMESTAMP AT TIME ZONE 'GMT', CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO :strusername.LocalMcId (mcId, singleRowKey, modificationTime, creationTime, localModificationTime) VALUES(:quoted_mcId, 0,
  CURRENT_TIMESTAMP AT TIME ZONE 'GMT',  CURRENT_TIMESTAMP AT TIME ZONE 'GMT',  CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

