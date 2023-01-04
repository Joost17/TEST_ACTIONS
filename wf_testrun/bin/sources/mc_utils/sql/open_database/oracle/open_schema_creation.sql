--
-- Delft FEWS
-- Copyright (c) 2003-2012 Deltares. All Rights Reserved.
--
-- Developed by:
-- Tessella
-- Tauro Kantorencentrum
-- President Kennedylaan 19
-- 2517 JK Den Haag
-- The Netherlands
-- email: info@tessella.com
-- web:   www.tessella.com
--
-- Project Ref: Tessella/NPD/7488
--
-- File history
-- Version           Date                           Author
-- $Revision: 38183 $  $Date: 2012-11-23 17:56:23 +0100 (vr, 23 nov. 2012) $   $Author: broek_f $
--
-- Creates tables for an open database for Delft FEWS 
--
-- Invocation  : @open_schema_creation <USERNAME>
-- Arguments   :
--      &1 - User/schema name to use
-- Return      : none
-- Variables   : none
--

set verify off

-- Input parameters:
define strusername = &1
define strtbsData = &strusername.Dat01
define strtbsIdx = &strusername.Idx01


-- Drop any tables created. This allows the script to be rerun to clear the database.
-- Some errors will be seen if the script is being run for the first time - or if the 
-- schema has changed since last run. These can be ignored.

DROP TABLE &strusername..FilterTimeSeriesKeys;
DROP TRIGGER &strusername..TRG_Filters_INS;
DROP SEQUENCE &strusername..SEQ_Filters_filterKey;
DROP TABLE &strusername..Filters;
DROP TABLE &strusername..Samples;
DROP TABLE &strusername..TimeSeriesManualEditsHistory;
DROP TABLE &strusername..TimeSeriesComments;
DROP TABLE &strusername..TimeSeriesValuesAndFlags;
DROP TRIGGER &strusername..TRG_TimeSeriesKeys_INS;
DROP SEQUENCE &strusername..SEQ_TimeSeriesKeys_seriesKey;
DROP TABLE &strusername..TimeSeriesKeys;
DROP TRIGGER &strusername..TRG_AggregationPer_INS;
DROP SEQUENCE &strusername..SEQ_AggregationPer_aggPerKey;
DROP TABLE &strusername..AggregationPeriods;
DROP TRIGGER &strusername..TRG_TimeSteps_INS;
DROP SEQUENCE &strusername..SEQ_TimeSteps_timeStepKey;
DROP TABLE &strusername..TimeSteps;
DROP TRIGGER &strusername..TRG_ModuleInstances_INS;
DROP SEQUENCE &strusername..SEQ_ModuleInstances_modInsKey;
DROP TABLE &strusername..ModuleInstances;
DROP TRIGGER &strusername..TRG_QualifierSets_INS;
DROP SEQUENCE &strusername..SEQ_QualifierSets_qualSetKey;
DROP TABLE &strusername..QualifierSets;
DROP TRIGGER &strusername..TRG_Qualifiers_INS;
DROP SEQUENCE &strusername..SEQ_Qualifiers_qualifierKey;
DROP TABLE &strusername..Qualifiers;
DROP TRIGGER &strusername..TRG_Users_INS;
DROP SEQUENCE &strusername..SEQ_Users_userKey;
DROP TABLE &strusername..Users;
DROP TRIGGER &strusername..TRG_Locations_INS;
DROP SEQUENCE &strusername..SEQ_Locations_locationKey;
DROP TABLE &strusername..Locations;
DROP TRIGGER &strusername..TRG_ParametersT_INS;
DROP SEQUENCE &strusername..SEQ_ParametersT_parameterKey;
DROP TABLE &strusername..ParametersTable;
DROP TRIGGER &strusername..TRG_ParameterGroups_INS;
DROP SEQUENCE &strusername..SEQ_ParameterGroups_groupKey;
DROP TABLE &strusername..ParameterGroups;

-- Cleanup of the database has completed.

-- Dump out any objects still owned by the schema in the database.
SELECT object_type || '.' || object_name from all_objects where owner = UPPER('&strusername') order by object_type, object_name;

-- Default script to create external database for external historical time series, parameters and locations
-- Names of tables and column are configurable in root config file database.xml
-- all nullable columns are not required in the external database when they are not configured in database.xml
 
CREATE TABLE &strusername..ParameterGroups(
    groupKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    description VARCHAR2(255),
    parameterType VARCHAR2(64) NOT NULL, -- instantaneous/accumulative/mean
    unit VARCHAR2(64) ,
    displayUnit VARCHAR2(64),
    CONSTRAINT PK_ParameterGroups
        PRIMARY KEY(groupKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_ParameterGroups_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the groupKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_ParameterGroups_groupKey;
CREATE TRIGGER &strusername..TRG_ParameterGroups_INS
  BEFORE INSERT ON &strusername..ParameterGroups
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_ParameterGroups_groupKey.NEXTVAL
      INTO :NEW.groupKey
      FROM dual;
  END; 
  /

	
CREATE TABLE &strusername..ParametersTable(
    parameterKey INTEGER NOT NULL,
    groupKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    shortName VARCHAR2(64),
    description VARCHAR2(255),
    valueResolution FLOAT,
    attributeA VARCHAR2(64), -- any number of parameters can by added with custom names, see database.xml
    attributeB FLOAT,
    CONSTRAINT PK_ParametersTable
        PRIMARY KEY(parameterKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_ParametersTable_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_ParametersT_groupKey
        FOREIGN KEY(groupKey)
        REFERENCES &strusername..ParameterGroups(groupKey))
    TABLESPACE &strtbsData;

-- Make sure the parameterKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_ParametersT_parameterKey;
CREATE TRIGGER &strusername..TRG_ParametersT_INS
  BEFORE INSERT ON &strusername..ParametersTable
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_ParametersT_parameterKey.NEXTVAL
      INTO :NEW.parameterKey
      FROM dual;
  END; 
  /


CREATE TABLE &strusername..Locations(
    locationKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    shortName VARCHAR2(64),
    description VARCHAR2(255),
    icon VARCHAR2(64),
    toolTip VARCHAR2(64),
    parentLocationId VARCHAR2(64),
    visibilityStartTime TIMESTAMP,
    visibilityEndTime TIMESTAMP,
    x FLOAT NOT NULL,  -- ANSI FLOAT = DOUBLE PRECISION
    y FLOAT NOT NULL, -- ANSI FLOAT = DOUBLE PRECISION
    z FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
    area FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
    relationALocationId VARCHAR2(64), -- any number of relations can be added with custom names, see database.xml
    relationBLocationId VARCHAR2(64),
    attributeA VARCHAR2(64), -- any number of parameters can by added with custom name, see database.xml
    attributeB FLOAT,
    CONSTRAINT PK_Locations
        PRIMARY KEY(locationKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_Locations_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the locationKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_Locations_locationKey;
CREATE TRIGGER &strusername..TRG_Locations_INS
  BEFORE INSERT ON &strusername..Locations
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_Locations_locationKey.NEXTVAL
      INTO :NEW.locationKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..Users(
    userKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    CONSTRAINT PK_Users
        PRIMARY KEY(userKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_Users_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the groupKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_Users_userKey;
CREATE TRIGGER &strusername..TRG_Users_INS
  BEFORE INSERT ON &strusername..Users
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_Users_userKey.NEXTVAL
      INTO :NEW.userKey
      FROM dual;
  END; 
  /	
  
  
CREATE TABLE &strusername..Qualifiers(
    qualifierKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    shortName VARCHAR2(64),
    description VARCHAR2(255),
    CONSTRAINT PK_Qualifiers
        PRIMARY KEY(qualifierKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_Qualifiers_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the qualifierKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_Qualifiers_qualifierKey;
CREATE TRIGGER &strusername..TRG_Qualifiers_INS
  BEFORE INSERT ON &strusername..Qualifiers
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_Qualifiers_qualifierKey.NEXTVAL
      INTO :NEW.qualifierKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..QualifierSets(
    qualifierSetKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    qualifierKey1 INTEGER NOT NULL,
    qualifierKey2 INTEGER,
    qualifierKey3 INTEGER,
    qualifierKey4 INTEGER,
    CONSTRAINT PK_QualifierSets
        PRIMARY KEY(qualifierSetKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_QualifierSets_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_QualifierSets_qualifierKey1
        FOREIGN KEY(qualifierKey1)
        REFERENCES &strusername..Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey2
        FOREIGN KEY(qualifierKey2)
        REFERENCES &strusername..Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey3
        FOREIGN KEY(qualifierKey3)
        REFERENCES &strusername..Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey4
        FOREIGN KEY(qualifierKey4)
        REFERENCES &strusername..Qualifiers(qualifierKey))
    TABLESPACE &strtbsData;

-- Make sure the qualifierSetKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_QualifierSets_qualSetKey;
CREATE TRIGGER &strusername..TRG_QualifierSets_INS
  BEFORE INSERT ON &strusername..QualifierSets
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_QualifierSets_qualSetKey.NEXTVAL
      INTO :NEW.qualifierSetKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..ModuleInstances(
    moduleInstanceKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64),
    description VARCHAR2(255),
    CONSTRAINT PK_ModuleInstances
        PRIMARY KEY(moduleInstanceKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_ModuleInstances_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the moduleInstanceKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_ModuleInstances_modInsKey;
CREATE TRIGGER &strusername..TRG_ModuleInstances_INS
  BEFORE INSERT ON &strusername..ModuleInstances
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_ModuleInstances_modInsKey.NEXTVAL
      INTO :NEW.moduleInstanceKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..TimeSteps(
    timeStepKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    label VARCHAR2(64),
    CONSTRAINT PK_TimeSteps
        PRIMARY KEY(timeStepKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_TimeSteps_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;

-- Make sure the timeStepKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_TimeSteps_timeStepKey;
CREATE TRIGGER &strusername..TRG_TimeSteps_INS
  BEFORE INSERT ON &strusername..TimeSteps
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_TimeSteps_timeStepKey.NEXTVAL
      INTO :NEW.timeStepKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..AggregationPeriods(
    aggregationPeriodKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    description VARCHAR2(255),
    CONSTRAINT PK_AggregationPer
        PRIMARY KEY(aggregationPeriodKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_AggregationPer_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;      

-- Make sure the aggregationPeriodKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_AggregationPer_aggPerKey;
CREATE TRIGGER &strusername..TRG_AggregationPer_INS
  BEFORE INSERT ON &strusername..AggregationPeriods
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_AggregationPer_aggPerKey.NEXTVAL
      INTO :NEW.aggregationPeriodKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..TimeSeriesKeys(
    seriesKey INTEGER NOT NULL,
    locationKey INTEGER NOT NULL,
    parameterKey INTEGER NOT NULL,
    qualifierSetKey INTEGER,
    moduleInstanceKey INTEGER NOT NULL,
    timeStepKey INTEGER NOT NULL,
    aggregationPeriodKey INTEGER,
    valueType INTEGER DEFAULT 0 NOT NULL, -- by default scalar
    modificationTime TIMESTAMP NOT NULL, --  every time a row is updated/added in the TimeSeriesValuesAndFlagsTable or TimeSeriesCommentsTable this time is updated
    CONSTRAINT PK_TimeSeriesKeys
        PRIMARY KEY(seriesKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_TimeSeriesKey_compound
        UNIQUE(locationKey, parameterKey, qualifierSetKey, moduleInstanceKey, timeStepKey, aggregationPeriodKey)
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_TimeSeriesKeys_locKey
        FOREIGN KEY(locationKey)
        REFERENCES &strusername..Locations(locationKey),
    CONSTRAINT FK_TimeSeriesKeys_paramKey
        FOREIGN KEY(parameterKey)
        REFERENCES &strusername..ParametersTable(parameterKey),
    CONSTRAINT FK_TimeSeriesKeys_qualSetKey
        FOREIGN KEY(qualifierSetKey)
        REFERENCES &strusername..QualifierSets(qualifierSetKey),
    CONSTRAINT FK_TimeSeriesKeys_modInsKey
        FOREIGN KEY(moduleInstanceKey)
        REFERENCES &strusername..ModuleInstances(moduleInstanceKey),
    CONSTRAINT FK_TimeSeriesKeys_timeStepKey
        FOREIGN KEY(timeStepKey)
        REFERENCES &strusername..TimeSteps(timeStepKey),
    CONSTRAINT FK_TimeSeriesKeys_aggPerKey
        FOREIGN KEY(aggregationPeriodKey)
        REFERENCES &strusername..AggregationPeriods(aggregationPeriodKey))
    TABLESPACE &strtbsData;    

-- Make sure the seriesKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_TimeSeriesKeys_seriesKey;
CREATE TRIGGER &strusername..TRG_TimeSeriesKeys_INS
  BEFORE INSERT ON &strusername..TimeSeriesKeys
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_TimeSeriesKeys_seriesKey.NEXTVAL
      INTO :NEW.seriesKey
      FROM dual;
  END; 
  /

  
-- required table, names of tables and columns are configurable
CREATE TABLE &strusername..TimeSeriesValuesAndFlags(
    seriesKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
    flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
    CONSTRAINT PK_TimeSeriesValuesAndFlags
        PRIMARY KEY(seriesKey, dateTime)
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_TimeSeriesValuesAndFlags
        FOREIGN KEY(seriesKey)
        REFERENCES &strusername..TimeSeriesKeys(seriesKey))
    TABLESPACE &strtbsData;
 
-- table is optional, when not available comments are not stored
-- names of tables and columns are configurable
CREATE TABLE &strusername..TimeSeriesComments(
    seriesKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    commentText VARCHAR2(64) NOT NULL,
    CONSTRAINT PK_TimeSeriesComments
        PRIMARY KEY(seriesKey, dateTime)
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_TimeSeriesComments
        FOREIGN KEY(seriesKey)
        REFERENCES &strusername..TimeSeriesKeys(seriesKey))
    TABLESPACE &strtbsData;
 
-- table is optional, when not available history of manual edits is not kept
-- names of tables and columns are configurable
CREATE TABLE &strusername..TimeSeriesManualEditsHistory(
    seriesKey INTEGER NOT NULL,
    editDateTime TIMESTAMP NOT NULL , -- 1970 Jan 1, 0:00 GMT for the backup of the original value before any edit, nullable column in PK not allowed
    dateTime TIMESTAMP NOT NULL,
    userKey INTEGER, -- Null for the backup of the original value before any edit
    scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
    flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
    commentText VARCHAR2(64),  -- column is optional
    CONSTRAINT PK_TimeSeriesManualEdits
        PRIMARY KEY(seriesKey, dateTime, editDateTime)
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_TimeSeriesManE_seriesKey
        FOREIGN KEY(seriesKey)
        REFERENCES &strusername..TimeSeriesKeys(seriesKey),
    CONSTRAINT FK_TimeSeriesManE_userKey
        FOREIGN KEY(userKey)
        REFERENCES &strusername..Users(userKey))
    TABLESPACE &strtbsData;
 
CREATE TABLE &strusername..Samples(
    locationKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    id VARCHAR2(64) NOT NULL,
    description VARCHAR2(255),  -- column is optional
    CONSTRAINT PK_Samples
        PRIMARY KEY(locationKey, dateTime)
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT FK_Samples_locationKey
        FOREIGN KEY(locationKey)
        REFERENCES &strusername..Locations(locationKey))
    TABLESPACE &strtbsData;
 
--  This table is only updated by FEWS and is a mirror of the Filters.xml
-- The time series in a filter can be controlled by changing the attributes of a location or sample parameter.
-- In the Filters.xml the referenced locations sets are based on constraints on attributes.
-- Sample parameters can be added to a filter based on parameter attributes
CREATE TABLE &strusername..Filters(
    filterKey INTEGER NOT NULL,
    id VARCHAR2(64) NOT NULL,
    name VARCHAR2(64), -- column is optional, id is used as name
    description VARCHAR2(255), -- column is optional
    parentFilterId  VARCHAR2(64), -- column is optional, list is used instead of tree
    validationIconsVisible INTEGER NOT NULL, -- column is optional
    mapExtentId VARCHAR2(64), -- column is optional
    viewPermission VARCHAR2(64), -- column is optional, set a permission to control who can view this filter
    editPermission VARCHAR2(64), -- Set a permission to control who can edit time series enumerated in this filter (only editable time series can be edited)
    CONSTRAINT PK_Filters
        PRIMARY KEY(filterKey) 
        USING INDEX TABLESPACE &strtbsIdx,
    CONSTRAINT UNIQ_Filters_id
        UNIQUE(id) 
        USING INDEX TABLESPACE &strtbsIdx)
    TABLESPACE &strtbsData;      

-- Make sure the filterKey is a unique identifier column
CREATE SEQUENCE &strusername..SEQ_Filters_filterKey;
CREATE TRIGGER &strusername..TRG_Filters_INS
  BEFORE INSERT ON &strusername..Filters
  FOR EACH ROW
  BEGIN
      SELECT &strusername..SEQ_Filters_filterKey.NEXTVAL
      INTO :NEW.filterKey
      FROM dual;
  END; 
  /

  
CREATE TABLE &strusername..FilterTimeSeriesKeys(
    filterKey INTEGER NOT NULL, -- reference to Filters table
    seriesKey INTEGER NOT NULL, -- reference to TimeSeriesKeys table
    CONSTRAINT PK_FilterTimeSeriesK
        PRIMARY KEY(filterKey, seriesKey)
        USING INDEX TABLESPACE &strtbsIdx,        
    CONSTRAINT FK_FilterTimeSeriesK_filterKey
        FOREIGN KEY(filterKey)
        REFERENCES &strusername..Filters(filterKey),
    CONSTRAINT FK_FilterTimeSeriesK_seriesKey
        FOREIGN KEY(seriesKey)
        REFERENCES &strusername..TimeSeriesKeys(seriesKey))
    TABLESPACE &strtbsData;    

COMMIT;
