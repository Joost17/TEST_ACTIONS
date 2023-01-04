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
-- Schema creation script for Oracle 12c and higher for the Delft-FEWS database schema sequences, triggers, tables and indexes.
-- Version v2021.01_20200415_1

SET SERVEROUTPUT ON

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Detected ' || DBMS_DB_VERSION.VERSION || '.' || DBMS_DB_VERSION.RELEASE); 
  IF (DBMS_DB_VERSION.VERSION < 12) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Since 2017.02 Delft-FEWS requires 12c when using Oracle. Older versions are no longer supported by default. Please contact Delft-FEWS support for more information');
  END IF;
END;
/

SET VERIFY OFF
WHENEVER SQLERROR CONTINUE;

-- Input parameters:
DEFINE strusername=&1
DEFINE strtbsData=&strusername.Dat01
DEFINE strtbsIdx=&strusername.Idx01
DEFINE strtbsLob=&strusername.Lob01
DEFINE schemaversion='v2021.01_20200415_1'
DEFINE mcId=&2
DEFINE databaseIntId=&3

-- Creates the sequences, tables and indexes for the Delft-FEWS central database.
-- This script first drops existing tables so the script can be rerun.
-- The dropping of tables will report errors when the script is being run for the first time, these can be ignored.
--
-- Config tables all follow a similar pattern using a <ConfigFile> table with one or more versions per config file.
--
-- Rules for creating indices:
-- 1. always index on columns globalRowId, localModificationTime, expiryTime.
-- 2. for LogEntries compound index on (synchLevel, localModificationTime) single column indexes on creationTime, eventCode, logLevel, eventProcessed (mcOnly)
-- 3. indexes on nullable columns have an extra column, e.g. WhatIfScenarios(expiryTime, 1)

DROP VIEW &strusername..WarmStatesSizes;
DROP VIEW &strusername..TimeSeriesSizes;
DROP VIEW &strusername..GlobalRowIds;
DROP TABLE &strusername..TimeSeries;
DROP TABLE &strusername..WarmStates;
DROP TABLE &strusername..ArchiveMetaData;
DROP TABLE &strusername..TaskRunCompletions;
DROP TABLE &strusername..ModuleRunTables;
DROP TABLE &strusername..Reports;
DROP TABLE &strusername..ModuleRunTimes;
DROP TABLE &strusername..ModuleInstanceRuns;
DROP TABLE &strusername..TaskRuns;
DROP TABLE &strusername..Tasks;
DROP TABLE &strusername..ModuleParameterModifiers;
DROP TABLE &strusername..AttributeModifiers;
DROP TABLE &strusername..Modifiers;
DROP TABLE &strusername..WhatIfScenarios;
DROP TABLE &strusername..ThresholdEvents;
DROP TABLE &strusername..PiClientDataSets;
DROP TABLE &strusername..Samples;
DROP TABLE &strusername..LogEntries;
DROP TABLE &strusername..FloodPeriods;
DROP TABLE &strusername..HistoricalEvents;
DROP TABLE &strusername..FewsSessions;
DROP TABLE &strusername..TimeSeriesStatusSnapshots;
DROP TABLE &strusername..ExternalForecastVisibility;
DROP TABLE &strusername..ProductInfo;
DROP TABLE &strusername..ImportStatus;
DROP TABLE &strusername..EventActionMappings;
DROP TABLE &strusername..ActionConfigurations;
DROP TABLE &strusername..McFailoverPriorities;
DROP TABLE &strusername..WorkflowTargetFsss;
DROP TABLE &strusername..ForecastingShells;
DROP TABLE &strusername..FssGroups;
DROP TABLE &strusername..TaskRunDispatcherTimes;
DROP TABLE &strusername..LogEventProcessorTimes;
DROP TABLE &strusername..MasterControllers;
DROP TABLE &strusername..AiServletUsers;
DROP TABLE &strusername..ConfigRevisionSets;
DROP TABLE &strusername..WorkflowFiles;
DROP TABLE &strusername..UnitConversions;
DROP TABLE &strusername..SystemConfigurations;
DROP TABLE &strusername..RootConfigFiles;
DROP TABLE &strusername..ReportTemplates;
DROP TABLE &strusername..ReportImages;
DROP TABLE &strusername..RegionConfigurations;
DROP TABLE &strusername..PiServiceConfigurations;
DROP TABLE &strusername..PiClientConfigurations;
DROP TABLE &strusername..ModuleParameters;
DROP TABLE &strusername..ModuleInstanceDatasets;
DROP TABLE &strusername..ModuleInstanceConfigs;
DROP TABLE &strusername..MapLayers;
DROP TABLE &strusername..IdMaps;
DROP TABLE &strusername..Icons;
DROP TABLE &strusername..FlagConversions;
DROP TABLE &strusername..DisplayConfigurations;
DROP TABLE &strusername..CorrelationTravelTimes;
DROP TABLE &strusername..CorrelationEventSets;
DROP TABLE &strusername..ColdStates;
DROP TABLE &strusername..CoefficientSets;
DROP TABLE &strusername..LiveMcAvailabilities;
DROP TABLE &strusername..RollingBarrelTimes;
DROP TABLE &strusername..ProcessedDeletedRows;
DROP TABLE &strusername..DeletedRows;
DROP TABLE &strusername..LocalSynchTimes;
DROP TABLE &strusername..CMConfigFiles;
DROP TABLE &strusername..MCConfigFiles;
DROP TABLE &strusername..IndexFilesSnapshots;
DROP TABLE &strusername..UserSettings;
DROP TABLE &strusername..UserToGroupsMappings;
DROP TABLE &strusername..AccessKeyHashes;
DROP TABLE &strusername..Users;
DROP TABLE &strusername..FssResources;
DROP TABLE &strusername..FssStatus;
DROP TABLE &strusername..McSynchStatus;
DROP TABLE &strusername..FewsWebServices;
DROP TABLE &strusername..TaskRunLogFiles;
DROP TABLE &strusername..ComponentLogFileSnapshots;
DROP TABLE &strusername..BaseBuildFileSets;
DROP TABLE &strusername..BaseBuildFiles;
DROP TABLE &strusername..TableLocalModificationTimes;
DROP TABLE &strusername..LocalMcId;
DROP TABLE &strusername..SystemActivities;
DROP TABLE &strusername..VersionRunning;
DROP TABLE &strusername..VersionManagement;
DROP TABLE &strusername..LastIssuedTimestamp;
DROP TABLE &strusername..DatabaseSchemaInfo;
DROP SEQUENCE &strusername..TaskRunIdSequence;
DROP SEQUENCE &strusername..TaskIdSequence;
DROP SEQUENCE &strusername..ForecastingShellIdSequence;
DROP SEQUENCE &strusername..FewsWebServicesIdSequence;
DROP SEQUENCE &strusername..EntryIdSequence;
DROP SEQUENCE &strusername..ConfigRevisionSetsIdSequence;
DROP SEQUENCE &strusername..GlobalRowIdSequence;

-- Cleanup of the database has completed.
-- Dump out any objects still owned by the schema in the database.
SELECT object_type || '.' || object_name FROM all_objects WHERE owner = UPPER('&strusername') ORDER BY object_type, object_name;

--From now on everything should succeed
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

-- Create Delft-FEWS tables, sequences and triggers

CREATE SEQUENCE &strusername..GlobalRowIdSequence START WITH &databaseIntId. INCREMENT BY 100 MINVALUE &databaseIntId. MAXVALUE 9223372036854775807 CACHE 10;
CREATE SEQUENCE &strusername..ConfigRevisionSetsIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE &strusername..EntryIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE &strusername..FewsWebServicesIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE &strusername..ForecastingShellIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE &strusername..TaskIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;
CREATE SEQUENCE &strusername..TaskRunIdSequence START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 20;

CREATE TABLE &strusername..DatabaseSchemaInfo(
  singleRowKey NUMBER(10) NOT NULL, --PK
  maintenanceRunning NUMBER(1) NOT NULL,
  schemaModificationTime TIMESTAMP(3) NOT NULL,
  globalRowIdRegenerationTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_DatabaseSchemaInfo PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_DatabaseSchemaInfo_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_DatabaseSchemaInfo_lmt ON &strusername..DatabaseSchemaInfo(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LastIssuedTimestamp(
  singleRowKey NUMBER(10) NOT NULL, --PK
  dateTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LastIssuedTimestamp PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LastIssuedTimestamp_lmt ON &strusername..LastIssuedTimestamp(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..VersionManagement(
  versionId VARCHAR2(64) NOT NULL, --PK
  componentId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(10) NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_VersionManagement PRIMARY KEY(versionId, componentId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_VersionManagement_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_VersionManagement_lmt ON &strusername..VersionManagement(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..VersionRunning(
  versionId VARCHAR2(64) NOT NULL, --PK
  componentId VARCHAR2(64) NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_VersionRunning PRIMARY KEY(versionId, componentId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_VersionRunning_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_VersionRunning_lmt ON &strusername..VersionRunning(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..SystemActivities(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  taskRunType VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_SystemActivities PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_SystemActivities_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_SystemActivities_et ON &strusername..SystemActivities(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_SystemActivities_lmt ON &strusername..SystemActivities(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LocalMcId(
  singleRowKey NUMBER(10) NOT NULL, --PK
  mcId VARCHAR2(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LocalMcId PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_LocalMcId_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LocalMcId_lmt ON &strusername..LocalMcId(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TableLocalModificationTimes(
  tableName VARCHAR2(30) NOT NULL, --PK
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TableLocalModificationTimes PRIMARY KEY(tableName) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TablLocaModiTime_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TablLocaModiTime_lmt ON &strusername..TableLocalModificationTimes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..BaseBuildFiles(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  hash VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedFile BLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_BaseBuildFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_BaseBuildFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(compressedFile) STORE AS BaseBuildFilesCompressedFile(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_BaseBuildFiles_et ON &strusername..BaseBuildFiles(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_BaseBuildFiles ON &strusername..BaseBuildFiles(hash) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_BaseBuildFiles_lmt ON &strusername..BaseBuildFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..BaseBuildFileSets(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  buildType VARCHAR2(255) NOT NULL,
  implementationVersion VARCHAR2(255) NOT NULL,
  buildNumber NUMBER(10) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  commentText VARCHAR2(255),
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedXml BLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_BaseBuildFileSets PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_BaseBuildFileSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(compressedXml) STORE AS BaseBuildFileSetsCompressedXml(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_BaseBuildFileSets ON &strusername..BaseBuildFileSets(buildType, implementationVersion, buildNumber) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_BaseBuildFileSets_et ON &strusername..BaseBuildFileSets(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_BaseBuildFileSets_lmt ON &strusername..BaseBuildFileSets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ComponentLogFileSnapshots(
  logTaskRunId VARCHAR2(64) NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  snapshotZip BLOB,
  snapshotRequestedTime TIMESTAMP(3),
  snapshotCompletedTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ComponentLogFileSnapshots PRIMARY KEY(logTaskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_CmpLogFileSnapshots_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ComponentLogFileSnapshots FOREIGN KEY(logTaskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) LOGGING LOB(snapshotZip) STORE AS ComponentLogFileSnapshotZip(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_CmpLogFileSnapshots_et ON &strusername..ComponentLogFileSnapshots(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_CmpLogFileSnapshots_lmt ON &strusername..ComponentLogFileSnapshots(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TaskRunLogFiles(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  compressedLogFile BLOB,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TaskRunLogFiles PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TaskRunLogFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(compressedLogFile) STORE AS TaskRunLogCompressedLogFile(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TaskRunLogFiles_et ON &strusername..TaskRunLogFiles(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TaskRunLogFiles_lmt ON &strusername..TaskRunLogFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FewsWebServices(
  mcId VARCHAR2(64) NOT NULL, --PK
  webServiceId NUMBER(19) NOT NULL, --PK
  hostname VARCHAR2(128) NOT NULL,
  name VARCHAR2(64) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB NUMBER(10) NOT NULL,
  diskSpaceMB NUMBER(10) NOT NULL,
  logTaskRunId VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_WebServices PRIMARY KEY(mcId, webServiceId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FewsWebServices_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_WebServices FOREIGN KEY(logTaskRunId) REFERENCES &strusername..ComponentLogFileSnapshots(logTaskRunId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FewsWebServices_et ON &strusername..FewsWebServices(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FewsWebServices_lmt ON &strusername..FewsWebServices(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..McSynchStatus(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  remoteMcId VARCHAR2(30) NOT NULL,
  enabled NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_McSynchStatus PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_McSynchStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_McSynchStatus_lmt ON &strusername..McSynchStatus(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FssStatus(
  fssRowId NUMBER(19) NOT NULL, --PK
  fssStatus NUMBER(10) NOT NULL,
  lastFssStatusTransitionTime TIMESTAMP(3) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  workflowNodeIndex NUMBER(10) DEFAULT '0' NOT NULL,
  progressPercentage NUMBER(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FssStatus PRIMARY KEY(fssRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FssStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FssStatus_et ON &strusername..FssStatus(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FssStatus_lmt ON &strusername..FssStatus(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FssResources(
  fssRowId NUMBER(19) NOT NULL, --PK
  claimedSlots NUMBER(10) NOT NULL,
  freeSlots NUMBER(10) NOT NULL,
  cpu FLOAT DEFAULT '0' NOT NULL,
  cpuUsage FLOAT NOT NULL,
  memoryMB NUMBER(10) DEFAULT '0' NOT NULL,
  memoryUsageMB NUMBER(10) NOT NULL,
  javaHeapSpaceUsageMB NUMBER(10) NOT NULL,
  diskSpaceMB NUMBER(10) DEFAULT '0' NOT NULL,
  diskSpaceUsageMB NUMBER(10) NOT NULL,
  dbConnectionCount FLOAT NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FssResource PRIMARY KEY(fssRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FssResources_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FssResources_et ON &strusername..FssResources(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FssResources_lmt ON &strusername..FssResources(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Users(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  userName VARCHAR2(30) NOT NULL,
  userDisplayName VARCHAR2(128),
  emailAddress VARCHAR2(512),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Users PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Users_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Users_lmt ON &strusername..Users(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Users ON &strusername..Users(userName) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..AccessKeyHashes(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  userMcId VARCHAR2(64) NOT NULL,
  userEntryId NUMBER(19) NOT NULL,
  accessKeyHash VARCHAR2(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_AccessKeyHashes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_AccessKeyHashes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_AccessKeyHashes FOREIGN KEY(userMcId, userEntryId) REFERENCES &strusername..Users(mcId, entryId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_AccessKeyHashes_lmt ON &strusername..AccessKeyHashes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..UserToGroupsMappings(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  userMcId VARCHAR2(64) NOT NULL,
  userEntryId NUMBER(19) NOT NULL,
  userGroup VARCHAR2(30) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_UserToGroupsMappings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_UserToGroupsMappings_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_UserToGroupsMappings FOREIGN KEY(userMcId, userEntryId) REFERENCES &strusername..Users(mcId, entryId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_UserToGroupsMappings_lmt ON &strusername..UserToGroupsMappings(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..UserSettings(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  userMcId VARCHAR2(64) NOT NULL,
  userEntryId NUMBER(19) NOT NULL,
  compressedUserSettingsFile BLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_UserSettings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_UserSettings_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_UserSettings FOREIGN KEY(userMcId, userEntryId) REFERENCES &strusername..Users(mcId, entryId)
) LOGGING LOB(compressedUserSettingsFile) STORE AS UserSettingsUserSettingsFile(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_UserSettings_lmt ON &strusername..UserSettings(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..IndexFilesSnapshots(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  formatVersion VARCHAR2(64) NOT NULL,
  zipBlob BLOB,
  snapshotTime TIMESTAMP(3),
  globalRowIdRegenerationTime TIMESTAMP(3),
  updateInProgressHeartbeat TIMESTAMP(3),
  fullRebuildRequested NUMBER(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_IndexFilesSnapshots PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_IndexFilesSnapshots_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(zipBlob) STORE AS IndexFilesSnapshotsZipBlobLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_IndexFilesSnapshots_et ON &strusername..IndexFilesSnapshots(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_IndexFilesSnapshots_lmt ON &strusername..IndexFilesSnapshots(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_IndexFilesSnapshots ON &strusername..IndexFilesSnapshots(mcId, formatVersion) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..MCConfigFiles(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  patchFileBlob BLOB,
  compressedXml BLOB,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_MCConfigFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_MCConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(patchFileBlob) STORE AS MCConfigFilesPatchFileBlobLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(compressedXml) STORE AS MCConfigFilesCompressedXmlLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_MCConfigFiles_lmt ON &strusername..MCConfigFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..CMConfigFiles(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  buildType VARCHAR2(255) DEFAULT 'none' NOT NULL,
  implementationVersion VARCHAR2(255) DEFAULT 'none' NOT NULL,
  buildNumber NUMBER(10) DEFAULT '0' NOT NULL,
  creationUserId VARCHAR2(30) DEFAULT 'none' NOT NULL,
  commentText VARCHAR2(255),
  patchFileBlob BLOB,
  compressedXml BLOB,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_CMConfigFiles PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_CMConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(patchFileBlob) STORE AS CMConfigFilesPatchFileBlobLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(compressedXml) STORE AS CMConfigFilesCompressedXmlLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_CMConfigFiles_lmt ON &strusername..CMConfigFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LocalSynchTimes(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  remoteMcId VARCHAR2(64) NOT NULL,
  tableName VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  maxAgeMillis NUMBER(19),
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  lastSuccessfulSynchStartTime TIMESTAMP(3),
  lastFailedTime TIMESTAMP(3),
  totalNetworkBytes NUMBER(19) NOT NULL,
  totalInsertedBytes NUMBER(19) NOT NULL,
  totalInsertedRows NUMBER(19) NOT NULL,
  totalInsertedFailedRows NUMBER(19) NOT NULL,
  totalUpdatedBytes NUMBER(19) NOT NULL,
  totalUpdatedRows NUMBER(19) NOT NULL,
  totalUpdatedFailedRows NUMBER(19) NOT NULL,
  totalDurationMillis NUMBER(19) NOT NULL,
  totalDownDurationMillis NUMBER(19) NOT NULL,
  thisMonthNetworkBytes NUMBER(19) NOT NULL,
  thisMonthInsertedBytes NUMBER(19) NOT NULL,
  thisMonthInsertedRows NUMBER(19) NOT NULL,
  thisMonthInsertedFailedRows NUMBER(19) NOT NULL,
  thisMonthUpdatedBytes NUMBER(19) NOT NULL,
  thisMonthUpdatedRows NUMBER(19) NOT NULL,
  thisMonthUpdatedFailedRows NUMBER(19) NOT NULL,
  thisMonthDurationMillis NUMBER(19) NOT NULL,
  thisMonthDownDurationMillis NUMBER(19) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LocalSynchTimes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_LocalSynchTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LocalSynchTimes_lmt ON &strusername..LocalSynchTimes(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LocalSynchTimes ON &strusername..LocalSynchTimes(mcId, remoteMcId, tableName, synchLevel) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..DeletedRows(
  deletedGlobalRowIds BLOB NOT NULL,
  componentId VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL, --PK
  CONSTRAINT PK_DeletedRows PRIMARY KEY(globalRowId) USING INDEX TABLESPACE &strtbsIdx --PK
) LOGGING LOB(deletedGlobalRowIds) STORE AS DeletedRowsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_DeletedRows_et ON &strusername..DeletedRows(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_DeletedRows_lmt ON &strusername..DeletedRows(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ProcessedDeletedRows(
  processedGlobalRowId NUMBER(19) NOT NULL, --PK
  expiryTime TIMESTAMP(3) NOT NULL,
  durationMillis NUMBER(19) NOT NULL,
  deletedRowCount NUMBER(10) NOT NULL,
  failedRowCount NUMBER(10) NOT NULL,
  firstFailedTable VARCHAR2(30),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ProcessedDeletedRows PRIMARY KEY(processedGlobalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ProcessedDeletedRows_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ProcessedDeletedRows_et ON &strusername..ProcessedDeletedRows(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ProcessedDeletedRows_lmt ON &strusername..ProcessedDeletedRows(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..RollingBarrelTimes(
  singleRowKey NUMBER(10) NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  lastFailedTime TIMESTAMP(3),
  lastFailedTable VARCHAR2(30),
  totalStartedCount NUMBER(10) NOT NULL,
  totalFailedCount NUMBER(10) NOT NULL,
  totalSuccessCount NUMBER(10) NOT NULL,
  totalDurationMillis NUMBER(19) NOT NULL,
  totalDownDurationMillis NUMBER(19) NOT NULL,
  totalExpiredRowCount NUMBER(10) NOT NULL,
  totalExtendedRowCount NUMBER(10) NOT NULL,
  thisMonthStartedCount NUMBER(10) NOT NULL,
  thisMonthFailedCount NUMBER(10) NOT NULL,
  thisMonthFailedRunCount NUMBER(10) NOT NULL,
  thisMonthDurationMillis NUMBER(19) NOT NULL,
  thisMonthDownDurationMillis NUMBER(19) NOT NULL,
  thisMonthExpiredRowCount NUMBER(10) NOT NULL,
  thisMonthExtendedRowCount NUMBER(10) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_RollingBarrelTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_RollingBarrelTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_RollingBarrelTimes_lmt ON &strusername..RollingBarrelTimes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LiveMcAvailabilities(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  isFailover NUMBER(2),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LiveMcAvailabilities PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_LiveMcAvailabilities_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LiveMcAvailabilities_lmt ON &strusername..LiveMcAvailabilities(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LiveMcAvailabilities ON &strusername..LiveMcAvailabilities(mcId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..CoefficientSets(
  coefficientSetsId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_CoefficientSets PRIMARY KEY(coefficientSetsId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_CoefficientSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS CoefficientSetsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_CoefficientSets_et ON &strusername..CoefficientSets(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_CoefficientSets_lmt ON &strusername..CoefficientSets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ColdStates(
  coldStateId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ColdStates PRIMARY KEY(coldStateId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ColdStates_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS ColdStatesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ColdStates_et ON &strusername..ColdStates(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ColdStates_lmt ON &strusername..ColdStates(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..CorrelationEventSets(
  eventSetsId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_CorrEvSet PRIMARY KEY(eventSetsId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_CorrelationEventSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS CorrelationEventSetsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_CorrelationEventSets_et ON &strusername..CorrelationEventSets(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_CorrelationEventSets_lmt ON &strusername..CorrelationEventSets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..CorrelationTravelTimes(
  travelTimesId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_CorrTrTime PRIMARY KEY(travelTimesId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_CorrelationTravelTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS CorrelationTravelTimesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_CorrelationTravelTimes_et ON &strusername..CorrelationTravelTimes(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_CorrelationTravelTimes_lmt ON &strusername..CorrelationTravelTimes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..DisplayConfigurations(
  configTypeId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_DisplayConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_DisplayConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS DisplayConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_DisplayConfigurations_et ON &strusername..DisplayConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_DisplayConfigurations_lmt ON &strusername..DisplayConfigurations(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FlagConversions(
  flagConversionId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FlagConversions PRIMARY KEY(flagConversionId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FlagConversions_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS FlagConversionsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FlagConversions_et ON &strusername..FlagConversions(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FlagConversions_lmt ON &strusername..FlagConversions(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Icons(
  iconId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Icons PRIMARY KEY(iconId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Icons_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS IconsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Icons_et ON &strusername..Icons(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Icons_lmt ON &strusername..Icons(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..IdMaps(
  idMapId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_IdMaps PRIMARY KEY(idMapId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_IdMaps_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS IdMapsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_IdMaps_et ON &strusername..IdMaps(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_IdMaps_lmt ON &strusername..IdMaps(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..MapLayers(
  mapLayerId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_MapLayers PRIMARY KEY(mapLayerId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_MapLayers_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS MapLayersLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_MapLayers_et ON &strusername..MapLayers(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_MapLayers_lmt ON &strusername..MapLayers(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleInstanceConfigs(
  moduleInstanceId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleInstanceConfigs PRIMARY KEY(moduleInstanceId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceConfigs_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS ModuleInstanceConfigsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleInstanceConfigs_et ON &strusername..ModuleInstanceConfigs(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleInstanceConfigs_lmt ON &strusername..ModuleInstanceConfigs(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleInstanceDatasets(
  moduleInstanceId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleInstanceDatasets PRIMARY KEY(moduleInstanceId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceDatasets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS ModuleInstanceDatasetsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleInstanceDatasets_et ON &strusername..ModuleInstanceDatasets(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleInstanceDatasets_lmt ON &strusername..ModuleInstanceDatasets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleParameters(
  moduleParameterId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModParams PRIMARY KEY(moduleParameterId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleParameters_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS ModuleParametersLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleParameters_et ON &strusername..ModuleParameters(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleParameters_lmt ON &strusername..ModuleParameters(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..PiClientConfigurations(
  clientId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_PiClientConfigurations PRIMARY KEY(clientId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_PiClientConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS PiClientConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_PiClientConfigurations_et ON &strusername..PiClientConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_PiClientConfigurations_lmt ON &strusername..PiClientConfigurations(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..PiServiceConfigurations(
  clientId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_PiServiceConfigurations PRIMARY KEY(clientId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_PiServiceConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS PiServiceConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_PiServiceConfigurations_et ON &strusername..PiServiceConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_PiServConf_lmt ON &strusername..PiServiceConfigurations(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..RegionConfigurations(
  configTypeId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_RegionConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_RegionConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS RegionConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_RegionConfigurations_et ON &strusername..RegionConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_RegionConfigurations_lmt ON &strusername..RegionConfigurations(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ReportImages(
  reportImageId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ReportImages PRIMARY KEY(reportImageId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ReportImages_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS ReportImagesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ReportImages_et ON &strusername..ReportImages(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ReportImages_lmt ON &strusername..ReportImages(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ReportTemplates(
  configTypeId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_RepTemp PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ReportTemplates_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS ReportTemplatesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ReportTemplates_et ON &strusername..ReportTemplates(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ReportTemplates_lmt ON &strusername..ReportTemplates(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..RootConfigFiles(
  rootConfigFileId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  blob BLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_RootConfigFiles PRIMARY KEY(rootConfigFileId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_RootConfigFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS RootConfigFilesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_RootConfigFiles_et ON &strusername..RootConfigFiles(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_RootConfigFiles_lmt ON &strusername..RootConfigFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..SystemConfigurations(
  configTypeId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_SystemConfigurations PRIMARY KEY(configTypeId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_SystemConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS SystemConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_SystemConfigurations_et ON &strusername..SystemConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_SystemConfigurations_lmt ON &strusername..SystemConfigurations(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..UnitConversions(
  unitConversionId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_UnitConversions PRIMARY KEY(unitConversionId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_UnitConversions_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS UnitConversionsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_UnitConversions_et ON &strusername..UnitConversions(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_UnitConversions_lmt ON &strusername..UnitConversions(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..WorkflowFiles(
  workflowId VARCHAR2(64) NOT NULL, --PK
  version VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  configXml CLOB NOT NULL,
  hash VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_WorkflowFiles PRIMARY KEY(workflowId, version) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_WorkflowFiles_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS WorkflowFilesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_WorkflowFiles_et ON &strusername..WorkflowFiles(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_WorkflowFiles_lmt ON &strusername..WorkflowFiles(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ConfigRevisionSets(
  revisionId VARCHAR2(64) NOT NULL, --PK
  creationUserId VARCHAR2(30) NOT NULL,
  commentText VARCHAR2(255),
  numberOfChanges NUMBER(10) NOT NULL,
  dataSet BLOB NOT NULL,
  mcUpdateRequestTime TIMESTAMP(3),
  encodedPartitionSequencesXml CLOB,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ConfigRevisionSets PRIMARY KEY(revisionId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ConfigRevisionSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(dataSet) STORE AS ConfigRevisionSetsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(encodedPartitionSequencesXml) STORE AS ConfigRevSetsEncPartSeqXml(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ConfigRevisionSets_lmt ON &strusername..ConfigRevisionSets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..AiServletUsers(
  userName VARCHAR2(16) NOT NULL, --PK
  password BLOB NOT NULL,
  fullName VARCHAR2(32) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_AiServletUsers PRIMARY KEY(userName) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_AiServletUsers_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(password) STORE AS AiServletUsersLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_AiServletUsers_lmt ON &strusername..AiServletUsers(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..MasterControllers(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  hostname VARCHAR2(128) NOT NULL,
  cpu FLOAT NOT NULL,
  memoryMB NUMBER(10) NOT NULL,
  diskSpaceMB NUMBER(10) NOT NULL,
  databaseIntId NUMBER(10) NOT NULL,
  logTaskRunId VARCHAR2(64) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3),
  mcStatus NUMBER(10) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_MasterControllers PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_MasterControllers_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_MasterControllers FOREIGN KEY(logTaskRunId) REFERENCES &strusername..ComponentLogFileSnapshots(logTaskRunId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_MasterControllers_lmt ON &strusername..MasterControllers(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LogEventProcessorTimes(
  singleRowKey NUMBER(10) NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LogEventProcessorTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_LogEventProcessorTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LogEventProcessorTimes_lmt ON &strusername..LogEventProcessorTimes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TaskRunDispatcherTimes(
  singleRowKey NUMBER(10) NOT NULL, --PK
  lastStartTime TIMESTAMP(3) NOT NULL,
  lastHeartbeatTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TaskRunDispatcherTimes PRIMARY KEY(singleRowKey) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TaskRunDispatcherTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TaskRunDispatcherTimes_lmt ON &strusername..TaskRunDispatcherTimes(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FssGroups(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  fssGroupId VARCHAR2(64) NOT NULL,
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255),
  priority NUMBER(10) DEFAULT '0' NOT NULL,
  allowUnmapped NUMBER(1) DEFAULT '1' NOT NULL,
  readyCount NUMBER(10) DEFAULT '1' NOT NULL,
  maxAwakeCount NUMBER(10),
  gotoSleepSeconds NUMBER(10),
  releaseSlotsSeconds NUMBER(10),
  fssGroupStatus VARCHAR2(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FssGroups PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FssGroups_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FssGroups_lmt ON &strusername..FssGroups(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FssGroups ON &strusername..FssGroups(mcId, fssGroupId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ForecastingShells(
  mcId VARCHAR2(64) NOT NULL, --PK
  fssId NUMBER(19) NOT NULL, --PK
  mcEntryId NUMBER(19) NOT NULL,
  fssGroupEntryId NUMBER(19) NOT NULL,
  hostname VARCHAR2(128) NOT NULL,
  regionHome VARCHAR2(1000) DEFAULT '/opt/fews/fss/1' NOT NULL,
  hostSlotCount NUMBER(10) NOT NULL,
  indexAtHost NUMBER(10) NOT NULL,
  awakenedByIndexAtHost NUMBER(10) NOT NULL,
  logTaskRunId VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  cpu FLOAT DEFAULT '0' NOT NULL,
  memoryMB NUMBER(10) DEFAULT '0' NOT NULL,
  diskSpaceMB NUMBER(10) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ForecastingShells PRIMARY KEY(mcId, fssId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ForecastingShells_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ForecastingShells3 FOREIGN KEY(logTaskRunId) REFERENCES &strusername..ComponentLogFileSnapshots(logTaskRunId),
  CONSTRAINT FK_ForecastingShells2 FOREIGN KEY(mcId, fssGroupEntryId) REFERENCES &strusername..FssGroups(mcId, entryId),
  CONSTRAINT FK_ForecastingShells1 FOREIGN KEY(mcId, mcEntryId) REFERENCES &strusername..MasterControllers(mcId, entryId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ForecastingShells_et ON &strusername..ForecastingShells(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ForecastingShells_lmt ON &strusername..ForecastingShells(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..WorkflowTargetFsss(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  workflowId VARCHAR2(64) NOT NULL,
  fssGroupId VARCHAR2(64) NOT NULL,
  fssPendingRunStatus NUMBER(10),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_WorkflowTargetFsss PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_WorkflowTargetFsss_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_WorkflowTargetFsss_lmt ON &strusername..WorkflowTargetFsss(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_WorkflowTargetFsss ON &strusername..WorkflowTargetFsss(mcId, workflowId, fssGroupId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..McFailoverPriorities(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  priority NUMBER(10),
  visible NUMBER(1) DEFAULT '0' NOT NULL,
  active NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_McFailoverPriorities PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_McFailoverPriorities_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_McFailoverPriorities_lmt ON &strusername..McFailoverPriorities(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_McFailoverPriorities ON &strusername..McFailoverPriorities(mcId, priority) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ActionConfigurations(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  actionId VARCHAR2(64) NOT NULL,
  version VARCHAR2(64) NOT NULL,
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  creationUserId VARCHAR2(30) NOT NULL,
  configXml CLOB NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ActionConfigurations PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ActionConfigurations_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(configXml) STORE AS ActionConfigurationsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ActionConfigurations_et ON &strusername..ActionConfigurations(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ActionConfigurations_lmt ON &strusername..ActionConfigurations(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ActConf_mcId_act_ver ON &strusername..ActionConfigurations(mcId, actionId, version) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..EventActionMappings(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  actionId VARCHAR2(64) NOT NULL,
  eventCode VARCHAR2(64) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_EventActionMappings PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_EventActionMappings_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_EventActionMappings_lmt ON &strusername..EventActionMappings(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_EveActMap_mcId_ev_act ON &strusername..EventActionMappings(mcId, eventCode, actionId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ImportStatus(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  dataFeedId VARCHAR2(64) NOT NULL,
  directory VARCHAR2(128) NOT NULL,
  lastImportTime TIMESTAMP(3) NOT NULL,
  lastFileImported VARCHAR2(128) NOT NULL,
  filesReadCount NUMBER(10) NOT NULL,
  filesFailedCount NUMBER(10) NOT NULL,
  log CLOB,
  importState CLOB,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ImportStatus PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ImportStatus_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(log) STORE AS ImportStatusLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(importState) STORE AS ImportStatusImportStateLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ImportStatus_expiry ON &strusername..ImportStatus(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ImportStatus_lmt ON &strusername..ImportStatus(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ImportStatus_mcId_dataFeed ON &strusername..ImportStatus(mcId, dataFeedId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ProductInfo(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  productId VARCHAR2(64) NOT NULL,
  startForecastTime TIMESTAMP(3) NOT NULL,
  endForecastTime TIMESTAMP(3) NOT NULL,
  productInfoXml CLOB NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ProductInfo PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ProductInfo_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(productInfoXml) STORE AS ProductInfoProductInfoXmlLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ProductInfo_et ON &strusername..ProductInfo(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ProductInfo_lmt ON &strusername..ProductInfo(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ProductInfo_id_start_end ON &strusername..ProductInfo(productId, startForecastTime, endForecastTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ExternalForecastVisibility(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  productId VARCHAR2(64) NOT NULL,
  externalForecastTime TIMESTAMP(3) NOT NULL,
  visible NUMBER(1),
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ExternalForecastVisibility PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ExtForVis_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ExtForVis_et ON &strusername..ExternalForecastVisibility(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ExtForVis_lmt ON &strusername..ExternalForecastVisibility(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TimeSeriesStatusSnapshots(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  timeZero TIMESTAMP(3) NOT NULL,
  blob BLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TimeSeriesStatusSnapshot PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TimeSeriStatSnap_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(blob) STORE AS TimeSeriesStatusSnapshotsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TimeSeriStatSnap_lmt ON &strusername..TimeSeriesStatusSnapshots(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TimeSeriStatSnap_mcId ON &strusername..TimeSeriesStatusSnapshots(mcId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FewsSessions(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  ocAddress VARCHAR2(64) NOT NULL,
  userId VARCHAR2(30) NOT NULL,
  sessionMcId VARCHAR2(64) NOT NULL,
  loginTime TIMESTAMP(3) NOT NULL,
  lastRequestTime TIMESTAMP(3),
  sessionType NUMBER(2) NOT NULL,
  pid NUMBER(10),
  description VARCHAR2(255),
  clientSystemInfo CLOB,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FewsSessions PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FewsSessions_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_FewsSessions FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) LOGGING LOB(clientSystemInfo) STORE AS FewsSessionsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FewsSessions_et ON &strusername..FewsSessions(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FewsSessions_lmt ON &strusername..FewsSessions(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..HistoricalEvents(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  eventId VARCHAR2(64) NOT NULL, --PK
  name VARCHAR2(64) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  visible NUMBER(1) NOT NULL,
  eventXml CLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_HistoricalEvents PRIMARY KEY(taskRunId, eventId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_HistoricalEvents_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_HistoricalEvents FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) LOGGING LOB(eventXml) STORE AS HistoricalEventsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_HistoricalEvents_et ON &strusername..HistoricalEvents(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_HistoricalEvents_lmt ON &strusername..HistoricalEvents(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..FloodPeriods(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  periodId VARCHAR2(64) NOT NULL, --PK
  areaId VARCHAR2(64) NOT NULL,
  persistentBeginTime TIMESTAMP(3) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  description VARCHAR2(64),
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  eventTime TIMESTAMP(3),
  eventThresholdId VARCHAR2(64),
  eventLocationId VARCHAR2(64),
  eventParameterId VARCHAR2(64),
  periodStatus NUMBER(2) NOT NULL,
  visible NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_FloodPeriods PRIMARY KEY(taskRunId, periodId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_FloodPeriods_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_FloodPeriods FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_FloodPeriod_expiry ON &strusername..FloodPeriods(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_FloodPeriods_lmt ON &strusername..FloodPeriods(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..LogEntries(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  logEntryId NUMBER(10) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64),
  synchLevel NUMBER(10) NOT NULL,
  logLevel NUMBER(10) NOT NULL,
  eventCode VARCHAR2(255),
  eventAcknowledged NUMBER(10) NOT NULL,
  eventProcessed NUMBER(10) DEFAULT '0' NOT NULL,
  buildNumber NUMBER(10) DEFAULT '0' NOT NULL,
  logMessage CLOB NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_LogEntries PRIMARY KEY(taskRunId, logEntryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_LogEntries_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_LogEntries FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) LOGGING LOB(logMessage) STORE AS LogEntriesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_LogEntries_ct ON &strusername..LogEntries(creationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LogEntries_eventCode ON &strusername..LogEntries(eventCode) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LogEntries_processed ON &strusername..LogEntries(eventProcessed) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LogEntries_expiry ON &strusername..LogEntries(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LogEntries_lmt ON &strusername..LogEntries(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_LogEntries_logLevel ON &strusername..LogEntries(logLevel) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Samples(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  sampleId NUMBER(10) NOT NULL, --PK
  externalSampleId VARCHAR2(64) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  locationId VARCHAR2(64) NOT NULL,
  dateTime TIMESTAMP(3) NOT NULL,
  visible NUMBER(1) NOT NULL,
  sampleProperties CLOB NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Samples PRIMARY KEY(taskRunId, sampleId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Samples_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_Samples FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) LOGGING LOB(sampleProperties) STORE AS SamplesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Samples_et ON &strusername..Samples(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Samples_lmt ON &strusername..Samples(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..PiClientDataSets(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  dataSetId VARCHAR2(64) NOT NULL,
  nodeId VARCHAR2(64) NOT NULL,
  clientId VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  dataSet BLOB NOT NULL,
  visible NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_PiClientDataSets PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_PiClientDataSets_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(dataSet) STORE AS PiClientDataSetsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_PiClientDataSets_dataSetId ON &strusername..PiClientDataSets(dataSetId, clientId) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_PiClientDataSets_lmt ON &strusername..PiClientDataSets(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ThresholdEvents(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  eventEntryId NUMBER(10) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64) NOT NULL,
  thresholdValueSetId VARCHAR2(64) NOT NULL,
  parameterId VARCHAR2(64) NOT NULL,
  locationId VARCHAR2(64) NOT NULL,
  thresholdId VARCHAR2(64) NOT NULL,
  rateOfChange VARCHAR2(64),
  unitFromTimeStep VARCHAR2(64),
  thresholdIntId NUMBER(10) NOT NULL,
  timeSeriesType VARCHAR2(64) NOT NULL,
  eventTime TIMESTAMP(3) NOT NULL,
  eventValue FLOAT NOT NULL,
  eventActionId VARCHAR2(64),
  eventIssued NUMBER(1),
  expiryTime TIMESTAMP(3) NOT NULL,
  taskRunIdTimeZero TIMESTAMP(3),
  exportTime TIMESTAMP(3),
  acknowledgedBy VARCHAR2(64),
  acknowledgedTime TIMESTAMP(3),
  targetLocationId VARCHAR2(64),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ThresholdEvents PRIMARY KEY(taskRunId, eventEntryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ThresholdEvents_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ThresholdEvents_ct ON &strusername..ThresholdEvents(creationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ThresholdEv_expiry ON &strusername..ThresholdEvents(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ThresholdEvents_lmt ON &strusername..ThresholdEvents(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ThresholdEvents_mt ON &strusername..ThresholdEvents(modificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..WhatIfScenarios(
  whatIfId VARCHAR2(64) NOT NULL, --PK
  userDefinedId VARCHAR2(64) NOT NULL,
  parentWhatIfId VARCHAR2(64),
  description VARCHAR2(255),
  creationTaskRunId VARCHAR2(64),
  whatIfConfig CLOB NOT NULL,
  visible NUMBER(1) NOT NULL,
  persistent NUMBER(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  name VARCHAR2(64),
  pendingDeletion NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_WhatIfScenaios PRIMARY KEY(whatIfId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_WhatIfScenarios_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) LOGGING LOB(whatIfConfig) STORE AS WhatIfScenariosLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_WhatIfScenarios_expiry ON &strusername..WhatIfScenarios(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_WhatIfScenarios_lmt ON &strusername..WhatIfScenarios(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Modifiers(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  modifierId NUMBER(10) NOT NULL, --PK
  whatIfId VARCHAR2(64),
  name VARCHAR2(64) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  modType VARCHAR2(64) NOT NULL,
  priority NUMBER(10) NOT NULL,
  userId VARCHAR2(30) NOT NULL,
  enabled NUMBER(1) NOT NULL,
  enabledInEnsembleRun NUMBER(1) DEFAULT '0' NOT NULL,
  enabledPeriodStartTime TIMESTAMP(3),
  enabledPeriodEndTime TIMESTAMP(3),
  validTime TIMESTAMP(3),
  visible NUMBER(1) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  userCreationTime TIMESTAMP(3),
  userModificationTime TIMESTAMP(3),
  creatorUserId VARCHAR2(30),
  previousTaskRunId VARCHAR2(64),
  previousModifierId NUMBER(10),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Modifiers PRIMARY KEY(taskRunId, modifierId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Modifiers_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_Modifiers FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId),
  CONSTRAINT FK_Modifiers_whatIf FOREIGN KEY(whatIfId) REFERENCES &strusername..WhatIfScenarios(whatIfId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Modifiers_expiryTime ON &strusername..Modifiers(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Modifiers_lmt ON &strusername..Modifiers(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Modifiers_whatIfId ON &strusername..Modifiers(whatIfId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..AttributeModifiers(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  attributeModifierId NUMBER(10) NOT NULL, --PK
  modifierId NUMBER(10) NOT NULL,
  locationId VARCHAR2(64) NOT NULL,
  attributeId VARCHAR2(64) NOT NULL,
  attributeText VARCHAR2(2000),
  attributeNumber FLOAT,
  attributeBoolean NUMBER(10),
  attributeTime TIMESTAMP(3),
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_AttributeModifiers PRIMARY KEY(taskRunId, attributeModifierId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_AttributeModifiers_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_AttribModifiersModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES &strusername..Modifiers(taskRunId, modifierId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_AttribMods_expiryTime ON &strusername..AttributeModifiers(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_AttributeModifiers_lmt ON &strusername..AttributeModifiers(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_AttrModiId ON &strusername..AttributeModifiers(taskRunId, modifierId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleParameterModifiers(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  modifierId NUMBER(10) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64) NOT NULL,
  configXml CLOB NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleParameterModifiers PRIMARY KEY(taskRunId, modifierId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuParaModi_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ModuleParameterModifiers FOREIGN KEY(taskRunId, modifierId) REFERENCES &strusername..Modifiers(taskRunId, modifierId)
) LOGGING LOB(configXml) STORE AS ModuleParameterModifiersLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModParMods_expiryTime ON &strusername..ModuleParameterModifiers(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuParaModi_lmt ON &strusername..ModuleParameterModifiers(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Tasks(
  taskId VARCHAR2(64) NOT NULL, --PK
  creationTaskRunId VARCHAR2(64) NOT NULL,
  whatIfId VARCHAR2(64),
  workflowId VARCHAR2(64) NOT NULL,
  description VARCHAR2(255),
  ownerMcId VARCHAR2(64) NOT NULL,
  canRunOnFailover NUMBER(2) NOT NULL,
  cancelPendingOnDispatch NUMBER(1) DEFAULT '0' NOT NULL,
  waitWhenAlreadyRunning NUMBER(1) DEFAULT '0' NOT NULL,
  taskPriority NUMBER(10) NOT NULL,
  taskFirstDueTime TIMESTAMP(3),
  taskRepeatTime NUMBER(10),
  encodedTaskRepeatTime VARCHAR2(64),
  taskRepeatUntilTime TIMESTAMP(3),
  taskStatus VARCHAR2(1) NOT NULL,
  taskPendingSinceTime TIMESTAMP(3),
  taskTag VARCHAR2(146),
  taskProperties CLOB,
  expiryTime TIMESTAMP(3) NOT NULL,
  lastCompletedTaskRunId VARCHAR2(64),
  lastCompletedDurationMillis NUMBER(19) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Tasks PRIMARY KEY(taskId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Tasks_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_TasksWhatIf FOREIGN KEY(whatIfId) REFERENCES &strusername..WhatIfScenarios(whatIfId)
) LOGGING LOB(taskProperties) STORE AS TasksLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Tasks_expiry ON &strusername..Tasks(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Tasks_lmt ON &strusername..Tasks(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Tasks_taskStatus ON &strusername..Tasks(taskStatus) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Tasks_whatIfId ON &strusername..Tasks(whatIfId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TaskRuns(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  taskId VARCHAR2(64) NOT NULL,
  taskDispatchMcId VARCHAR2(64) NOT NULL,
  taskDispatchFssId VARCHAR2(30),
  taskDispatchTime TIMESTAMP(3) NOT NULL,
  taskRunStatus VARCHAR2(1) NOT NULL,
  scheduledDispatchTime TIMESTAMP(3) NOT NULL,
  taskRunCompletionTime TIMESTAMP(3),
  terminateRequested NUMBER(1) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  timeZero TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TaskRuns PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TaskRuns_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_TaskRunsTask FOREIGN KEY(taskId) REFERENCES &strusername..Tasks(taskId),
  CONSTRAINT FK_TaskRuns FOREIGN KEY(taskRunId) REFERENCES &strusername..SystemActivities(taskRunId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TaskRuns_expiry ON &strusername..TaskRuns(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TaskRuns_lmt ON &strusername..TaskRuns(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TaskRuns_taskId ON &strusername..TaskRuns(taskId) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TaskRuns_status ON &strusername..TaskRuns(taskRunStatus) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleInstanceRuns(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64) NOT NULL, --PK
  previousTaskRunId VARCHAR2(64),
  expiryTime TIMESTAMP(3) NOT NULL,
  runStatus NUMBER(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleInstanceRuns PRIMARY KEY(taskRunId, moduleInstanceId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleInstanceRuns_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ModuleInstanceRuns FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleInstanceRuns_et ON &strusername..ModuleInstanceRuns(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleInstanceRuns_lmt ON &strusername..ModuleInstanceRuns(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleRunTimes(
  mcId VARCHAR2(64) NOT NULL, --PK
  entryId NUMBER(19) NOT NULL, --PK
  workflowId VARCHAR2(64) NOT NULL,
  moduleInstanceId VARCHAR2(64) NOT NULL,
  pendingDurationMillis NUMBER(19) NOT NULL,
  runDurationMillis NUMBER(19) NOT NULL,
  minPartition NUMBER(10) NOT NULL,
  maxPartition NUMBER(10) NOT NULL,
  visible NUMBER(1) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleRunTimes PRIMARY KEY(mcId, entryId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleRunTimes_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleRunTimes_lmt ON &strusername..ModuleRunTimes(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleRunTimes_workflowId_ ON &strusername..ModuleRunTimes(workflowId, moduleInstanceId) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..Reports(
  reportId NUMBER(10) NOT NULL, --PK
  taskRunId VARCHAR2(64) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64) NOT NULL, --PK
  subjectTaskRunId VARCHAR2(64) NOT NULL,
  blob BLOB NOT NULL,
  subDirName VARCHAR2(64) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_Reports PRIMARY KEY(reportId, taskRunId, moduleInstanceId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_Reports_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ReportsRun FOREIGN KEY(taskRunId, moduleInstanceId) REFERENCES &strusername..ModuleInstanceRuns(taskRunId, moduleInstanceId)
) LOGGING LOB(blob) STORE AS ReportsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_Reports_expiry ON &strusername..Reports(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_Reports_lmt ON &strusername..Reports(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ModuleRunTables(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  fileId NUMBER(10) NOT NULL, --PK
  moduleInstanceId VARCHAR2(64) NOT NULL,
  name VARCHAR2(64) NOT NULL,
  fileBlob BLOB NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ModuleRunTables PRIMARY KEY(taskRunId, fileId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ModuleRunTables_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ModuleRunTables FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) LOGGING LOB(fileBlob) STORE AS ModuleRunTablesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ModuleRunTables_expiryTime ON &strusername..ModuleRunTables(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ModuleRunTables_lmt ON &strusername..ModuleRunTables(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TaskRunCompletions(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  taskRunCompletionStatus VARCHAR2(1) NOT NULL,
  taskRunCompletionTime TIMESTAMP(3) NOT NULL,
  taskRunProperties CLOB,
  expiryTime TIMESTAMP(3) NOT NULL,
  approvedTime TIMESTAMP(3),
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TaskRunCompletions PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TaskRunCompletions_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_TaskRunCompletions FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) LOGGING LOB(taskRunProperties) STORE AS TaskRunCompletionsLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TaskRunCompletions_et ON &strusername..TaskRunCompletions(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TaskRunCompletions_lmt ON &strusername..TaskRunCompletions(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..ArchiveMetaData(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  blob BLOB NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_ArchiveMetaData PRIMARY KEY(taskRunId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_ArchiveMetaData_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_ArchMetaDataTaskRuns FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) LOGGING LOB(blob) STORE AS ArchiveMetaDataLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_ArchiveMetaData_expiry ON &strusername..ArchiveMetaData(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_ArchiveMetaData_lmt ON &strusername..ArchiveMetaData(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..WarmStates(
  taskRunId VARCHAR2(64) NOT NULL, --PK
  stateId NUMBER(10) NOT NULL, --PK
  name VARCHAR2(255),
  description VARCHAR2(255),
  moduleInstanceId VARCHAR2(64) NOT NULL,
  blob BLOB NOT NULL,
  stateTime TIMESTAMP(3) NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  warmStateType NUMBER(2) DEFAULT '0' NOT NULL,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_WarmStates PRIMARY KEY(taskRunId, stateId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_WarmStates_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_WarmStates FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) LOGGING LOB(blob) STORE AS WarmStatesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_WarmStates_expiry ON &strusername..WarmStates(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_WarmStates_lmt ON &strusername..WarmStates(localModificationTime) TABLESPACE &strtbsIdx;

CREATE TABLE &strusername..TimeSeries(
  creatorTaskRunId VARCHAR2(64) NOT NULL, --PK
  blobId NUMBER(10) NOT NULL, --PK
  modifierId NUMBER(10),
  sampleId VARCHAR2(64),
  moduleInstanceId VARCHAR2(64),
  parameterId VARCHAR2(2000),
  qualifierSetId VARCHAR2(2000),
  locationId VARCHAR2(2000) NOT NULL,
  beginTime TIMESTAMP(3) NOT NULL,
  endTime TIMESTAMP(3) NOT NULL,
  timeSeriesType NUMBER(10) NOT NULL,
  taskRunId VARCHAR2(64),
  ensembleMemberId VARCHAR2(2000),
  blob BLOB NOT NULL,
  blobGZipCompressionRatio NUMBER(3) DEFAULT '0' NOT NULL,
  synchLevel NUMBER(10) NOT NULL,
  expiryTime TIMESTAMP(3) NOT NULL,
  valueType NUMBER(10) NOT NULL,
  timeStepId VARCHAR2(64) NOT NULL,
  aggregationPeriod VARCHAR2(64),
  repeatCycleId VARCHAR2(64),
  externalForecastingStartTime TIMESTAMP(3),
  constantFlag NUMBER(10),
  maxValue FLOAT,
  azGZipCompressionRatio NUMBER(3) DEFAULT '0' NOT NULL,
  a BLOB,
  b BLOB,
  c BLOB,
  d BLOB,
  e BLOB,
  f BLOB,
  g BLOB,
  h BLOB,
  i BLOB,
  j BLOB,
  k BLOB,
  l BLOB,
  m BLOB,
  n BLOB,
  o BLOB,
  p BLOB,
  q BLOB,
  r BLOB,
  s BLOB,
  t BLOB,
  u BLOB,
  v BLOB,
  w BLOB,
  x BLOB,
  y BLOB,
  z BLOB,
  creationTime TIMESTAMP(3) NOT NULL,
  modificationTime TIMESTAMP(3) NOT NULL,
  localModificationTime TIMESTAMP(3) NOT NULL,
  globalRowId NUMBER(19) DEFAULT &strusername..GlobalRowIdSequence.nextVal NOT NULL,
  CONSTRAINT PK_TimeSeries PRIMARY KEY(creatorTaskRunId, blobId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT IDX_TimeSeries_id UNIQUE(globalRowId) USING INDEX TABLESPACE &strtbsIdx,
  CONSTRAINT FK_TimeSeriesSysactivities FOREIGN KEY(creatorTaskRunId) REFERENCES &strusername..SystemActivities(taskRunId),
  CONSTRAINT FK_TimeSeries_Modifiers FOREIGN KEY(creatorTaskRunId, modifierId) REFERENCES &strusername..Modifiers(taskRunId, modifierId),
  CONSTRAINT FK_TimeSeries_TaskRuns FOREIGN KEY(taskRunId) REFERENCES &strusername..TaskRuns(taskRunId)
) LOGGING LOB(blob) STORE AS TimeSeriesLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(a) STORE AS TimeSeriesALOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(b) STORE AS TimeSeriesBLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(c) STORE AS TimeSeriesCLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(d) STORE AS TimeSeriesDLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(e) STORE AS TimeSeriesELOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(f) STORE AS TimeSeriesFLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(g) STORE AS TimeSeriesGLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(h) STORE AS TimeSeriesHLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(i) STORE AS TimeSeriesILOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(j) STORE AS TimeSeriesJLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(k) STORE AS TimeSeriesKLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(l) STORE AS TimeSeriesLLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(m) STORE AS TimeSeriesMLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(n) STORE AS TimeSeriesNLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(o) STORE AS TimeSeriesOLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(p) STORE AS TimeSeriesPLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(q) STORE AS TimeSeriesQLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(r) STORE AS TimeSeriesRLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(s) STORE AS TimeSeriesSLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(t) STORE AS TimeSeriesTLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(u) STORE AS TimeSeriesULOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(v) STORE AS TimeSeriesVLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(w) STORE AS TimeSeriesWLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(x) STORE AS TimeSeriesXLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(y) STORE AS TimeSeriesYLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) LOB(z) STORE AS TimeSeriesZLOB(TABLESPACE &strtbsLob ENABLE STORAGE IN ROW PCTVERSION 0 CACHE READS CHUNK 8192
) TABLESPACE &strtbsData;

CREATE INDEX &strusername..IDX_TimeSeries_expiryTime ON &strusername..TimeSeries(expiryTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TimeSeries_lmt ON &strusername..TimeSeries(localModificationTime) TABLESPACE &strtbsIdx;
CREATE INDEX &strusername..IDX_TimeSeries_taskRunId ON &strusername..TimeSeries(taskRunId) TABLESPACE &strtbsIdx;

INSERT INTO &strusername..LastIssuedTimeStamp(singleRowKey, dateTime, modificationTime, creationTime, localModificationTime)
  VALUES (0, TO_DATE('2000-01-01 00:00:00', 'yyyy/mm/dd hh24:mi:ss'), SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO &strusername..VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT nvl(MAX(entryId)+1, 1) FROM &strusername..VersionManagement), 'DATABASE_SCHEMA', '&schemaversion.', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO &strusername..VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime)
  VALUES ((SELECT nvl(MAX(entryId)+1, 1) FROM &strusername..VersionManagement), 'CURRENT_SCHEMA', '&schemaversion.',  SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO &strusername..DatabaseSchemaInfo (singleRowKey, maintenanceRunning, schemaModificationTime, globalRowIdRegenerationTime, modificationTime, creationTime, localModificationTime)
  VALUES (0, 0, SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT');

INSERT INTO &strusername..LocalMcId (mcId, singleRowKey, modificationTime, creationTime, localModificationTime) VALUES('&mcId.', 0,
  CURRENT_TIMESTAMP AT TIME ZONE 'GMT',  CURRENT_TIMESTAMP AT TIME ZONE 'GMT',  CURRENT_TIMESTAMP AT TIME ZONE 'GMT');

COMMIT;
