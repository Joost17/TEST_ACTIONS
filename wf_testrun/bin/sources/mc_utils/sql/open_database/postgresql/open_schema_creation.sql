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
--
-- Creates a schema and tables for the FEWS open database for PostgreSQL 8.x and newer
--
-- Invocation  : psql -f schema_creation.sql -d $1 -v database=$2 -v username=$3 
-- Arguments   : $1 - Database instance
--               $2 - Database instance
--               $3 - Database owner user
-- Return      : Crnone
-- Variables   : none
--


-- Input parameters:
--- user/schema name
\set strusername :username
--- tablespace name for data tablespace
\set strtbsData :database'_dat01'
--- tablespace name for index tablespace
\set strtbsIdx :database'_idx01'

-- Set the message level a bit higher to avoid lots of messages (default is NOTICE)
set client_min_messages='WARNING';

-- Drop the schema; this will remove all objects contained in the schema.
-- This allows the script to be rerun to clear the database.
DROP SCHEMA :strusername CASCADE;

-- Create the schema in which all objects will be created.
-- The schema name is identical to the username to make sure it
-- is in the default search path and to ensure similarity with 
-- implementations on other RDBMSs
CREATE SCHEMA :strusername;

--
-- A dummy view to enable "SELECT 123 FROM dual" to work like on Oracle
--
CREATE VIEW :strusername.dual AS
  SELECT current_date;

-- Default script to create external database for external historical time series, parameters and locations
-- Names of tables and column are configurable in root config file database.xml
-- all nullable columns are not required in the external database when they are not configured in database.xml
 
CREATE TABLE :strusername.ParameterGroups(
    groupKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    description VARCHAR(255),
    parameterType VARCHAR(64) NOT NULL, -- instantaneous/accumulative/mean
    unit VARCHAR(64) ,
    displayUnit VARCHAR(64),
    CONSTRAINT PK_ParameterGroups
        PRIMARY KEY(groupKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_ParameterGroups_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.ParametersTable(
    parameterKey SERIAL NOT NULL,
    groupKey INTEGER NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    shortName VARCHAR(64),
    description VARCHAR(255),
    valueResolution FLOAT,
    attributeA VARCHAR(64), -- any number of parameters can by added with custom names, see database.xml
    attributeB FLOAT,
    CONSTRAINT PK_ParametersTable
        PRIMARY KEY(parameterKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_ParametersTable_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_ParametersT_groupKey
        FOREIGN KEY(groupKey)
        REFERENCES :strusername.ParameterGroups(groupKey))
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.Locations(
    locationKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    shortName VARCHAR(64),
    description VARCHAR(255),
    icon VARCHAR(64),
    toolTip VARCHAR(64),
    parentLocationId VARCHAR(64),
    visibilityStartTime TIMESTAMP,
    visibilityEndTime TIMESTAMP,
    x FLOAT NOT NULL,  -- ANSI FLOAT = DOUBLE PRECISION
    y FLOAT NOT NULL, -- ANSI FLOAT = DOUBLE PRECISION
    z FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
    area FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
    relationALocationId VARCHAR(64), -- any number of relations can be added with custom names, see database.xml
    relationBLocationId VARCHAR(64),
    attributeA VARCHAR(64), -- any number of parameters can by added with custom name, see database.xml
    attributeB FLOAT,
    CONSTRAINT PK_Locations
        PRIMARY KEY(locationKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_Locations_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.Users(
    userKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    CONSTRAINT PK_Users
        PRIMARY KEY(userKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_Users_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.Qualifiers(
    qualifierKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    shortName VARCHAR(64),
    description VARCHAR(255),
    CONSTRAINT PK_Qualifiers
        PRIMARY KEY(qualifierKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_Qualifiers_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.QualifierSets(
    qualifierSetKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    qualifierKey1 INTEGER NOT NULL,
    qualifierKey2 INTEGER,
    qualifierKey3 INTEGER,
    qualifierKey4 INTEGER,
    CONSTRAINT PK_QualifierSets
        PRIMARY KEY(qualifierSetKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_QualifierSets_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_QualifierSets_qualifierKey1
        FOREIGN KEY(qualifierKey1)
        REFERENCES :strusername.Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey2
        FOREIGN KEY(qualifierKey2)
        REFERENCES :strusername.Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey3
        FOREIGN KEY(qualifierKey3)
        REFERENCES :strusername.Qualifiers(qualifierKey),
    CONSTRAINT FK_QualifierSets_qualifierKey4
        FOREIGN KEY(qualifierKey4)
        REFERENCES :strusername.Qualifiers(qualifierKey))
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.ModuleInstances(
    moduleInstanceKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64),
    description VARCHAR(255),
    CONSTRAINT PK_ModuleInstances
        PRIMARY KEY(moduleInstanceKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_ModuleInstances_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.TimeSteps(
    timeStepKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    label VARCHAR(64),
    CONSTRAINT PK_TimeSteps
        PRIMARY KEY(timeStepKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_TimeSteps_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.AggregationPeriods(
    aggregationPeriodKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    description VARCHAR(255),
    CONSTRAINT PK_AggregationPer
        PRIMARY KEY(aggregationPeriodKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_AggregationPer_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;      
 
CREATE TABLE :strusername.TimeSeriesKeys(
    seriesKey SERIAL NOT NULL,
    locationKey INTEGER NOT NULL,
    parameterKey INTEGER NOT NULL,
    qualifierSetKey INTEGER,
    moduleInstanceKey INTEGER NOT NULL,
    timeStepKey INTEGER NOT NULL,
    aggregationPeriodKey INTEGER,
    valueType INTEGER NOT NULL DEFAULT 0, -- by default scalar
    modificationTime TIMESTAMP NOT NULL, --  every time a row is updated/added in the TimeSeriesValuesAndFlagsTable or TimeSeriesCommentsTable this time is updated
    CONSTRAINT PK_TimeSeriesKeys
        PRIMARY KEY(seriesKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_TimeSeriesKey_compound
        UNIQUE(locationKey, parameterKey, qualifierSetKey, moduleInstanceKey, timeStepKey, aggregationPeriodKey)
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_TimeSeriesKeys_locKey
        FOREIGN KEY(locationKey)
        REFERENCES :strusername.Locations(locationKey),
    CONSTRAINT FK_TimeSeriesKeys_paramKey
        FOREIGN KEY(parameterKey)
        REFERENCES :strusername.ParametersTable(parameterKey),
    CONSTRAINT FK_TimeSeriesKeys_qualSetKey
        FOREIGN KEY(qualifierSetKey)
        REFERENCES :strusername.QualifierSets(qualifierSetKey),
    CONSTRAINT FK_TimeSeriesKeys_modInsKey
        FOREIGN KEY(moduleInstanceKey)
        REFERENCES :strusername.ModuleInstances(moduleInstanceKey),
    CONSTRAINT FK_TimeSeriesKeys_timeStepKey
        FOREIGN KEY(timeStepKey)
        REFERENCES :strusername.TimeSteps(timeStepKey),
    CONSTRAINT FK_TimeSeriesKeys_aggPerKey
        FOREIGN KEY(aggregationPeriodKey)
        REFERENCES :strusername.AggregationPeriods(aggregationPeriodKey))
    TABLESPACE :strtbsData;    
 
-- required table, names of tables and columns are configurable
CREATE TABLE :strusername.TimeSeriesValuesAndFlags(
    seriesKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
    flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
    CONSTRAINT PK_TimeSeriesValuesAndFlags
        PRIMARY KEY(seriesKey, dateTime)
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_TimeSeriesValuesAndFlags
        FOREIGN KEY(seriesKey)
        REFERENCES :strusername.TimeSeriesKeys(seriesKey))
    TABLESPACE :strtbsData;
 
-- table is optional, when not available comments are not stored
-- names of tables and columns are configurable
CREATE TABLE :strusername.TimeSeriesComments(
    seriesKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    commentText VARCHAR(64) NOT NULL,
    CONSTRAINT PK_TimeSeriesComments
        PRIMARY KEY(seriesKey, dateTime)
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_TimeSeriesComments
        FOREIGN KEY(seriesKey)
        REFERENCES :strusername.TimeSeriesKeys(seriesKey))
    TABLESPACE :strtbsData;
 
-- table is optional, when not available history of manual edits is not kept
-- names of tables and columns are configurable
CREATE TABLE :strusername.TimeSeriesManualEditsHistory(
    seriesKey INTEGER NOT NULL,
    editDateTime TIMESTAMP NOT NULL , -- 1970 Jan 1, 0:00 GMT for the backup of the original value before any edit, nullable column in PK not allowed
    dateTime TIMESTAMP NOT NULL,
    userKey INTEGER, -- Null for the backup of the original value before any edit
    scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
    flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
    commentText VARCHAR(64),  -- column is optional
    CONSTRAINT PK_TimeSeriesManualEdits
        PRIMARY KEY(seriesKey, dateTime, editDateTime)
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_TimeSeriesManE_seriesKey
        FOREIGN KEY(seriesKey)
        REFERENCES :strusername.TimeSeriesKeys(seriesKey),
    CONSTRAINT FK_TimeSeriesManE_userKey
        FOREIGN KEY(userKey)
        REFERENCES :strusername.Users(userKey))
    TABLESPACE :strtbsData;
 
CREATE TABLE :strusername.Samples(
    locationKey INTEGER NOT NULL,
    dateTime TIMESTAMP NOT NULL,
    id VARCHAR(64) NOT NULL,
    description VARCHAR(255),  -- column is optional
    CONSTRAINT PK_Samples
        PRIMARY KEY(locationKey, dateTime)
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT FK_Samples_locationKey
        FOREIGN KEY(locationKey)
        REFERENCES :strusername.Locations(locationKey))
    TABLESPACE :strtbsData;
 
--  This table is only updated by FEWS and is a mirror of the Filters.xml
 -- The time series in a filter can be controlled by changing the attributes of a location or sample parameter.
-- In the Filters.xml the referenced locations sets are based on constraints on attributes.
-- Sample parameters can be added to a filter based on parameter attributes
CREATE TABLE :strusername.Filters(
    filterKey SERIAL NOT NULL,
    id VARCHAR(64) NOT NULL,
    name VARCHAR(64), -- column is optional, id is used as name
    description VARCHAR(255), -- column is optional
    parentFilterId  VARCHAR(64), -- column is optional, list is used instead of tree
    validationIconsVisible INTEGER NOT NULL, -- column is optional
    mapExtentId VARCHAR(64), -- column is optional
    viewPermission VARCHAR(64), -- column is optional, set a permission to control who can view this filter
    editPermission VARCHAR(64), -- Set a permission to control who can edit time series enumerated in this filter (only editable time series can be edited)
    CONSTRAINT PK_Filters
        PRIMARY KEY(filterKey) 
        USING INDEX TABLESPACE :strtbsIdx,
    CONSTRAINT UNIQ_Filters_id
        UNIQUE(id) 
        USING INDEX TABLESPACE :strtbsIdx)
    TABLESPACE :strtbsData;      
 
CREATE TABLE :strusername.FilterTimeSeriesKeys(
    filterKey INTEGER NOT NULL, -- reference to Filters table
    seriesKey INTEGER NOT NULL, -- reference to TimeSeriesKeys table
    CONSTRAINT PK_FilterTimeSeriesK
        PRIMARY KEY(filterKey, seriesKey)
        USING INDEX TABLESPACE :strtbsIdx,        
    CONSTRAINT FK_FilterTimeSeriesK_filterKey
        FOREIGN KEY(filterKey)
        REFERENCES :strusername.Filters(filterKey),
    CONSTRAINT FK_FilterTimeSeriesK_seriesKey
        FOREIGN KEY(seriesKey)
        REFERENCES :strusername.TimeSeriesKeys(seriesKey))
    TABLESPACE :strtbsData;    
