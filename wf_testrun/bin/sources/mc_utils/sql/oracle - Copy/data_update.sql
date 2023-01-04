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
-- Description:
-- Data_update script for Oracle 12c and higher for migrating the Delft-FEWS database schema (tables and views).
-- Migrates to version v2021.01_20200415_1 from v2020.02_20201026_1.
--
SET SERVEROUTPUT ON

--exit when version check fails
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Detected ' || DBMS_DB_VERSION.VERSION || '.' || DBMS_DB_VERSION.RELEASE);
  IF (DBMS_DB_VERSION.VERSION < 12) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Since 2017.02 Delft-FEWS requires 12c when using Oracle. Older versions are no longer supported by default. Please contact Delft-FEWS support for more information');
  END IF; 
END;
/


SPOOL 'data_update_log_v2021.01_20200415_1.txt'

DEFINE strusername = &1
--DEFINE mcId = &2
DEFINE strtbsData = &strusername.Dat01
DEFINE strtbsIdx = &strusername.Idx01
DEFINE strtbsLob = &strusername.Lob01
DEFINE schemaversion = 'v2021.01_20200415_1'

DECLARE
  v_maintenanceRunning NUMBER(10);
  v_databaseIntId NUMBER(19);
  v_localMcId VARCHAR(64);
BEGIN
  SELECT maintenanceRunning INTO v_maintenanceRunning FROM &strusername..DatabaseSchemaInfo WHERE singleRowKey=0;
  IF (v_maintenanceRunning <> 1) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Fatal error: Maintenance mode required. Please first activate maintenance mode before using the data_update script.');
  END IF;
  SELECT MOD(&strusername..GlobalRowIdSequence.nextval, 100) INTO v_databaseIntId FROM DUAL;
  IF (v_databaseIntId = 99) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Fatal error: GlobalRowIdSequence is uninitialized (99). Before the 2018.02 data_update, after the 2017.02 data_update, it is required to first run the 2017.02 DatabaseInitializationTool.');
  END IF;
  SELECT MAX(mcId) INTO v_localMcId FROM &strusername..LocalMcId WHERE singleRowKey = 0;
--  IF v_localMcId IS NULL THEN
--    INSERT INTO &strusername..LocalMcId (mcId, singleRowKey, modificationTime, creationTime, localModificationTime) VALUES('&mcId.', 0, SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT'); 
--  END IF;
  SELECT MAX(mcId) INTO v_localMcId FROM &strusername..LocalMcId WHERE singleRowKey = 0;
  DBMS_OUTPUT.PUT_LINE('Detected mcId ''' || v_localMcId || ''' and databaseIntId ''' || v_databaseIntId || '''');
END;
/

WHENEVER SQLERROR CONTINUE;
SET VERIFY OFF

--PROMPT 'C1';
--BEGIN
--DROP all SYS_STS which blocks renaming columns, these are system generated in Oracle 12c from the DECODE in ALL_STAT_EXTENSIONS'
--FOR i IN (SELECT table_name, extension_name, extension, owner FROM dba_stat_extensions
-- WHERE UPPER(owner)=UPPER('&strusername') AND extension_name LIKE 'SYS_STS%' AND droppable='YES') LOOP
--    DBMS_OUTPUT.PUT_LINE(i.owner || ' ' || '&strusername' || i.table_name || ' ' ||i.extension);
--    DBMS_STATS.DROP_EXTENDED_STATS(UPPER('&strusername'), i.table_name, i.extension);
-- END LOOP;
--END;
--/
-- Add any schema updates here

PROMPT 'L001';
DROP VIEW &strusername..WarmStatesSizes;
PROMPT 'L002';
DROP VIEW &strusername..TimeSeriesSizes;
PROMPT 'L003';
DROP VIEW &strusername..GlobalRowIds;
PROMPT 'L004';
ALTER TABLE &strusername..FssStatus ADD workflowNodeIndex NUMBER(10) DEFAULT '0' NOT NULL;
PROMPT 'L005';
ALTER TABLE &strusername..FssStatus ADD progressPercentage NUMBER(2) DEFAULT '0' NOT NULL;
PROMPT 'L006';
ALTER TABLE &strusername..Tasks ADD lastCompletedTaskRunId VARCHAR2(64);
PROMPT 'L007';
ALTER TABLE &strusername..Tasks ADD lastCompletedDurationMillis NUMBER(19) DEFAULT '0' NOT NULL;
PROMPT 'L008';
ALTER TABLE &strusername..TaskRuns ADD timeZero TIMESTAMP(3);
PROMPT 'L009';
ALTER TABLE &strusername..ModuleInstanceRuns ADD runStatus NUMBER(2) DEFAULT '0' NOT NULL;
PROMPT 'L010';
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
PROMPT 'L011';
CREATE INDEX &strusername..IDX_ModuleRunTimes_lmt ON &strusername..ModuleRunTimes(localModificationTime) TABLESPACE &strtbsIdx;
PROMPT 'L012';
CREATE INDEX &strusername..IDX_ModuleRunTimes_workflowId_ ON &strusername..ModuleRunTimes(workflowId, moduleInstanceId) TABLESPACE &strtbsIdx;

CREATE VIEW &strusername..WarmStatesSizes AS SELECT moduleInstanceId, SUM(DBMS_LOB.GETLENGTH(blob) / 1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, FromInterval(MAX(expiryTime - creationTime)) AS maxExpiryDurationInSec FROM WarmStates GROUP BY moduleInstanceId;

CREATE VIEW &strusername..TimeSeriesSizes AS SELECT moduleInstanceId, SUM(DBMS_LOB.GETLENGTH(blob) / 1024.0) AS sumBlobSizeKb, COUNT(*) AS numRecords, FromInterval(MAX(expiryTime - creationTime)) AS maxExpiryDurationInSec FROM TimeSeries GROUP BY moduleInstanceId;

CREATE VIEW &strusername..GlobalRowIds AS
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

PROMPT 'E1';
DELETE FROM &strusername..VersionManagement WHERE componentId='CURRENT_SCHEMA';

PROMPT 'E2';
INSERT INTO &strusername..VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime) VALUES (
  (SELECT nvl(MAX(entryId)+1, 1) FROM &strusername..VersionManagement), 'DATABASE_SCHEMA', '&schemaversion.',
  SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT'
);

PROMPT 'E3';
INSERT INTO &strusername..VersionManagement (entryId, componentId, versionId, modificationTime, creationTime, localModificationTime) VALUES (
  (SELECT nvl(MAX(entryId)+1, 1) FROM &strusername..VersionManagement), 'CURRENT_SCHEMA', '&schemaversion.',
  SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT', SYSTIMESTAMP AT TIME ZONE 'GMT');

PROMPT 'E4';
UPDATE &strusername..DatabaseSchemaInfo SET schemaModificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT',
  modificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT', localModificationTime=SYSTIMESTAMP AT TIME ZONE 'GMT'
  WHERE singleRowKey=0;

COMMIT;

SPOOL OFF

