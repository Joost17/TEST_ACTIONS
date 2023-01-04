@echo off
::
:: Delft FEWS
:: Copyright (c) 2003-2012 Deltares. All Rights Reserved.
::
:: Developed by:
:: Tessella
:: Tauro Kantorencentrum
:: President Kennedylaan 19
:: 2517 JK Den Haag
:: The Netherlands
:: email: info@tessella.com
:: web:   www.tessella.com
::
:: Project Ref: Tessella/NPD/7488
::
:: File history
:: Version           Date                           Author
:: $Revision: 45196 $  $Date: 2014-02-19 10:05:44 +0100 (wo, 19 feb. 2014) $   $Author: breugel $
::
:: Creates tables for a FEWS open database on MS SQL Server.
::  T-SQL script is wrapped in a Batch file as osql does not accept script 
::  command-line parameters
::
:: Invocation  : open_schema_creation.bat <SERVER> <DATABASE> <USER>
:: Arguments   : %1 - Database server.
::               %2 - Database to use.
::               %3 - Database instance user.
:: Return      : none
:: Variables   : none
::

:: Check input parameters
IF [%3] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET strserver=%1
SET strdatabase=%2
SET strusername=%3

:: Other variables
SET strtbsData=%strusername%_Dat01
SET strtbsIdx=%strusername%_Idx01

:: File name of T-SQL script
SET tmpfilename= _tmp_open_schema_creation.sql

:: Start of T-SQL script, which will be echoed to a temporary file
:: Escape character ^ has to be used when echoing ( ) > <
::
:: NOTE: Unlike Oracle, SQL Server does not automatically create an index when
::   creating a foreign key. So for every foreign key, also create the corresponding 
::   index, if it is not referencing a primary key column.
::
:: NOTE: For every column that is marked UNIQUE in Oracle, Oracle creates an index 
::   automatically. SQL Server does not allow multiple NULLs when a column is UNIQUE, 
::   so when not using UNIQUE for SQL Server, create an index for every UNIQUE column 
::   in the Oracle schema. 
::
(
ECHO -- File: %tmpfilename%
ECHO --  Automatically created from batch file: %0
ECHO -- Should be automatically deleted if batch file has finished correctly
ECHO.
ECHO USE %strdatabase%
ECHO.
ECHO DROP TABLE %strusername%.FilterTimeSeriesKeys
ECHO GO
ECHO DROP TABLE %strusername%.Filters
ECHO GO
ECHO DROP TABLE %strusername%.Samples
ECHO GO
ECHO DROP TABLE %strusername%.TimeSeriesManualEditsHistory
ECHO GO
ECHO DROP TABLE %strusername%.TimeSeriesComments
ECHO GO
ECHO DROP TABLE %strusername%.TimeSeriesValuesAndFlags
ECHO GO
ECHO DROP TABLE %strusername%.TimeSeriesKeys
ECHO GO
ECHO DROP TABLE %strusername%.AggregationPeriods
ECHO GO
ECHO DROP TABLE %strusername%.TimeSteps
ECHO GO
ECHO DROP TABLE %strusername%.ModuleInstances
ECHO GO
ECHO DROP TABLE %strusername%.QualifierSets
ECHO GO
ECHO DROP TABLE %strusername%.Qualifiers
ECHO GO
ECHO DROP TABLE %strusername%.Users
ECHO GO
ECHO DROP TABLE %strusername%.Locations
ECHO GO
ECHO DROP TABLE %strusername%.ParametersTable
ECHO GO
ECHO DROP TABLE %strusername%.ParameterGroups
ECHO GO
ECHO DROP TABLE %strusername%.dual
ECHO GO
ECHO ------------------
ECHO.
ECHO -- To have Oracle's dual Table which is not needed in SQL Server,
ECHO -- create a dummy table here
ECHO CREATE TABLE %strusername%.dual ^(
ECHO   dummy    VARCHAR^(1^)
ECHO    ^)
ECHO GO
ECHO. 
ECHO INSERT INTO %strusername%.dual ^(dummy^) VALUES ^('X'^)
ECHO GO
ECHO.
ECHO.
ECHO -- Default script to create external database for external historical time series, parameters and locations
ECHO -- Names of tables and column are configurable in root config file database.xml
ECHO -- all nullable columns are not required in the external database when they are not configured in database.xml
ECHO.  
ECHO CREATE TABLE %strusername%.ParameterGroups^(
ECHO     groupKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     description VARCHAR^(255^),
ECHO     parameterType VARCHAR^(64^) NOT NULL, -- instantaneous/accumulative/mean
ECHO     unit VARCHAR^(64^) ,
ECHO     displayUnit VARCHAR^(64^),
ECHO     CONSTRAINT PK_ParameterGroups
ECHO         PRIMARY KEY^(groupKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_ParameterGroups_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.ParametersTable^(
ECHO     parameterKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     groupKey INTEGER NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     shortName VARCHAR^(64^),
ECHO     description VARCHAR^(255^),
ECHO     valueResolution FLOAT,
ECHO     attributeA VARCHAR^(64^), -- any number of parameters can by added with custom names, see database.xml
ECHO     attributeB FLOAT,
ECHO      CONSTRAINT PK_ParametersTable
ECHO         PRIMARY KEY^(parameterKey^) 
ECHO         ON %strtbsIdx%,
ECHO      CONSTRAINT UNIQ_ParametersTable_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_ParametersT_groupKey
ECHO         FOREIGN KEY^(groupKey^)
ECHO         REFERENCES %strusername%.ParameterGroups^(groupKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.Locations^(
ECHO     locationKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     shortName VARCHAR^(64^),
ECHO     description VARCHAR^(255^),
ECHO     icon VARCHAR^(64^),
ECHO     toolTip VARCHAR^(64^),
ECHO     parentLocationId VARCHAR^(64^),
ECHO     visibilityStartTime DATETIME,
ECHO     visibilityEndTime DATETIME,
ECHO     x FLOAT NOT NULL,  -- ANSI FLOAT = DOUBLE PRECISION
ECHO     y FLOAT NOT NULL, -- ANSI FLOAT = DOUBLE PRECISION
ECHO     z FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
ECHO     area FLOAT, -- ANSI FLOAT = DOUBLE PRECISION
ECHO     relationALocationId VARCHAR^(64^), -- any number of relations can be added with custom names, see database.xml
ECHO     relationBLocationId VARCHAR^(64^),
ECHO     attributeA VARCHAR^(64^), -- any number of parameters can by added with custom name, see database.xml
ECHO     attributeB FLOAT,
ECHO     CONSTRAINT PK_Locations
ECHO         PRIMARY KEY^(locationKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_Locations_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.Users^(
ECHO     userKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     CONSTRAINT PK_Users
ECHO         PRIMARY KEY^(userKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_Users_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.Qualifiers^(
ECHO     qualifierKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     shortName VARCHAR^(64^),
ECHO     description VARCHAR^(255^),
ECHO     CONSTRAINT PK_Qualifiers
ECHO         PRIMARY KEY^(qualifierKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_Qualifiers_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.QualifierSets^(
ECHO     qualifierSetKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     qualifierKey1 INTEGER NOT NULL,
ECHO     qualifierKey2 INTEGER,
ECHO     qualifierKey3 INTEGER,
ECHO     qualifierKey4 INTEGER,
ECHO     CONSTRAINT PK_QualifierSets
ECHO         PRIMARY KEY^(qualifierSetKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_QualifierSets_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_QualifierSets_qualifierKey1
ECHO         FOREIGN KEY^(qualifierKey1^)
ECHO         REFERENCES %strusername%.Qualifiers^(qualifierKey^),
ECHO     CONSTRAINT FK_QualifierSets_qualifierKey2
ECHO         FOREIGN KEY^(qualifierKey2^)
ECHO         REFERENCES %strusername%.Qualifiers^(qualifierKey^),
ECHO     CONSTRAINT FK_QualifierSets_qualifierKey3
ECHO         FOREIGN KEY^(qualifierKey3^)
ECHO         REFERENCES %strusername%.Qualifiers^(qualifierKey^),
ECHO     CONSTRAINT FK_QualifierSets_qualifierKey4
ECHO         FOREIGN KEY^(qualifierKey4^)
ECHO         REFERENCES %strusername%.Qualifiers^(qualifierKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.ModuleInstances^(
ECHO     moduleInstanceKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^),
ECHO     description VARCHAR^(255^),
ECHO     CONSTRAINT PK_ModuleInstances
ECHO         PRIMARY KEY^(moduleInstanceKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_ModuleInstances_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.TimeSteps^(
ECHO     timeStepKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     label VARCHAR^(64^),
ECHO     CONSTRAINT PK_TimeSteps
ECHO         PRIMARY KEY^(timeStepKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_TimeSteps_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.AggregationPeriods^(
ECHO     aggregationPeriodKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     description VARCHAR^(255^),
ECHO     CONSTRAINT PK_AggregationPer
ECHO         PRIMARY KEY^(aggregationPeriodKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_AggregationPer_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO      
ECHO.  
ECHO CREATE TABLE %strusername%.TimeSeriesKeys^(
ECHO     seriesKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     locationKey INTEGER NOT NULL,
ECHO     parameterKey INTEGER NOT NULL,
ECHO     qualifierSetKey INTEGER,
ECHO     moduleInstanceKey INTEGER NOT NULL,
ECHO     timeStepKey INTEGER NOT NULL,
ECHO     aggregationPeriodKey INTEGER,
ECHO     valueType INTEGER NOT NULL DEFAULT 0, -- by default scalar
ECHO     modificationTime DATETIME NOT NULL, --  every time a row is updated/added in the TimeSeriesValuesAndFlagsTable or TimeSeriesCommentsTable this time is updated
ECHO     CONSTRAINT PK_TimeSeriesKeys
ECHO         PRIMARY KEY^(seriesKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_TimeSeriesKey_compound
ECHO         UNIQUE^(locationKey, parameterKey, qualifierSetKey, moduleInstanceKey, timeStepKey, aggregationPeriodKey^)
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_TimeSeriesKeys_locKey
ECHO         FOREIGN KEY^(locationKey^)
ECHO         REFERENCES %strusername%.Locations^(locationKey^),
ECHO     CONSTRAINT FK_TimeSeriesKeys_paramKey
ECHO         FOREIGN KEY^(parameterKey^)
ECHO         REFERENCES %strusername%.ParametersTable^(parameterKey^),
ECHO     CONSTRAINT FK_TimeSeriesKeys_qualSetKey
ECHO         FOREIGN KEY^(qualifierSetKey^)
ECHO         REFERENCES %strusername%.QualifierSets^(qualifierSetKey^),
ECHO     CONSTRAINT FK_TimeSeriesKeys_modInsKey
ECHO         FOREIGN KEY^(moduleInstanceKey^)
ECHO         REFERENCES %strusername%.ModuleInstances^(moduleInstanceKey^),
ECHO     CONSTRAINT FK_TimeSeriesKeys_timeStepKey
ECHO         FOREIGN KEY^(timeStepKey^)
ECHO         REFERENCES %strusername%.TimeSteps^(timeStepKey^),
ECHO     CONSTRAINT FK_TimeSeriesKeys_aggPerKey
ECHO         FOREIGN KEY^(aggregationPeriodKey^)
ECHO         REFERENCES %strusername%.AggregationPeriods^(aggregationPeriodKey^)^)
ECHO     ON %strtbsData%
ECHO GO    
ECHO.  
ECHO -- required table, names of tables and columns are configurable
ECHO CREATE TABLE %strusername%.TimeSeriesValuesAndFlags^(
ECHO     seriesKey INTEGER NOT NULL,
ECHO     dateTime DATETIME NOT NULL,
ECHO     scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
ECHO     flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
ECHO     CONSTRAINT PK_TimeSeriesValuesAndFlags
ECHO         PRIMARY KEY^(seriesKey, dateTime^)
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_TimeSeriesValuesAndFlags
ECHO         FOREIGN KEY^(seriesKey^)
ECHO         REFERENCES %strusername%.TimeSeriesKeys^(seriesKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO -- table is optional, when not available comments are not stored
ECHO -- names of tables and columns are configurable
ECHO CREATE TABLE %strusername%.TimeSeriesComments^(
ECHO     seriesKey INTEGER NOT NULL,
ECHO     dateTime DATETIME NOT NULL,
ECHO     commentText VARCHAR^(64^) NOT NULL,
ECHO     CONSTRAINT PK_TimeSeriesComments
ECHO         PRIMARY KEY^(seriesKey, dateTime^)
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_TimeSeriesComments
ECHO         FOREIGN KEY^(seriesKey^)
ECHO         REFERENCES %strusername%.TimeSeriesKeys^(seriesKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO -- table is optional, when not available history of manual edits is not kept
ECHO -- names of tables and columns are configurable
ECHO CREATE TABLE %strusername%.TimeSeriesManualEditsHistory^(
ECHO     seriesKey INTEGER NOT NULL,
ECHO     editDateTime DATETIME NOT NULL, -- 1970 Jan 1, 0:00 GMT for the backup of the original value before any edit, nullable column in PK not allowed
ECHO     dateTime DATETIME NOT NULL,
ECHO     userKey INTEGER, -- Null for the backup of the original value before any edit
ECHO     scalarValue FLOAT,  -- required column. NULLABLE to store a NaN value, NaN not supported by most databases
ECHO     flags INTEGER NOT NULL, -- flag + valueSource * 10 + flagSource * 100 + outOfDetectionRangeFlag * 1000 + state * 10000
ECHO     commentText VARCHAR^(64^),  -- column is optional
ECHO     CONSTRAINT PK_TimeSeriesManualEdits
ECHO         PRIMARY KEY^(seriesKey, dateTime, editDateTime^)
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_TimeSeriesManE_seriesKey
ECHO         FOREIGN KEY^(seriesKey^)
ECHO         REFERENCES %strusername%.TimeSeriesKeys^(seriesKey^),
ECHO     CONSTRAINT FK_TimeSeriesManE_userKey
ECHO         FOREIGN KEY^(userKey^)
ECHO         REFERENCES %strusername%.Users^(userKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO CREATE TABLE %strusername%.Samples^(
ECHO     locationKey INTEGER NOT NULL,
ECHO     dateTime DATETIME NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     description VARCHAR^(255^),  -- column is optional
ECHO     CONSTRAINT PK_Samples
ECHO         PRIMARY KEY^(locationKey, dateTime^)
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT FK_Samples_locationKey
ECHO         FOREIGN KEY^(locationKey^)
ECHO         REFERENCES %strusername%.Locations^(locationKey^)^)
ECHO     ON %strtbsData%
ECHO GO
ECHO.  
ECHO --  This table is only updated by FEWS and is a mirror of the Filters.xml
ECHO  -- The time series in a filter can be controlled by changing the attributes of a location or sample parameter.
ECHO -- In the Filters.xml the referenced locations sets are based on constraints on attributes.
ECHO -- Sample parameters can be added to a filter based on parameter attributes
ECHO CREATE TABLE %strusername%.Filters^(
ECHO     filterKey INTEGER IDENTITY ^(1,1^) NOT NULL,
ECHO     id VARCHAR^(64^) NOT NULL,
ECHO     name VARCHAR^(64^), -- column is optional, id is used as name
ECHO     description VARCHAR^(255^), -- column is optional
ECHO     parentFilterId  VARCHAR^(64^), -- column is optional, list is used instead of tree
ECHO     validationIconsVisible INTEGER NOT NULL, -- column is optional
ECHO     mapExtentId VARCHAR^(64^), -- column is optional
ECHO     viewPermission VARCHAR^(64^), -- column is optional, set a permission to control who can view this filter
ECHO     editPermission VARCHAR^(64^), -- Set a permission to control who can edit time series enumerated in this filter ^(only editable time series can be edited^)
ECHO     CONSTRAINT PK_Filters
ECHO         PRIMARY KEY^(filterKey^) 
ECHO         ON %strtbsIdx%,
ECHO     CONSTRAINT UNIQ_Filters_id
ECHO         UNIQUE^(id^) 
ECHO         ON %strtbsIdx%^)
ECHO     ON %strtbsData%
ECHO GO      
ECHO.  
ECHO CREATE TABLE %strusername%.FilterTimeSeriesKeys^(
ECHO     filterKey INTEGER NOT NULL, -- reference to Filters table
ECHO     seriesKey INTEGER NOT NULL, -- reference to TimeSeriesKeys table
ECHO     CONSTRAINT PK_FilterTimeSeriesK
ECHO         PRIMARY KEY^(filterKey, seriesKey^)
ECHO         ON %strtbsIdx%,        
ECHO     CONSTRAINT FK_FilterTimeSeriesK_filterKey
ECHO         FOREIGN KEY^(filterKey^)
ECHO         REFERENCES %strusername%.Filters^(filterKey^),
ECHO     CONSTRAINT FK_FilterTimeSeriesK_seriesKey
ECHO         FOREIGN KEY^(seriesKey^)
ECHO         REFERENCES %strusername%.TimeSeriesKeys^(seriesKey^)^)
ECHO     ON %strtbsData%
ECHO GO    
ECHO.
ECHO.

) > %tmpfilename%
:: End of T-SQL script, write to temp file


:: Run the script on the database
ECHO Please enter the password for 'sa' on server '%1'
osql -S %1 -d %2 -U sa -n -i %tmpfilename%

:: Remove the temporary file
del %tmpfilename%

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates tables for a FEWS open database on MS SQL Server.
ECHO  T-SQL script is wrapped in a Batch file as osql does not accept script 
ECHO  commandline parameters
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> 
ECHO.
ECHO Arguments   : ^<SERVER^>   - Database server
ECHO               ^<DATABASE^> - Database to use
ECHO               ^<USER^>     - Database instance user
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on

