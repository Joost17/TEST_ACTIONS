@echo off
:: Delft-FEWS
:: ================================================================
::
:: Software Info: http://www.delft-fews.com
:: Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
::
:: (C) Copyright 2008, by Deltares
::                        P.O. Box 177
::                        2600 MH  Delft
::                        The Netherlands
::                        http://www.deltares.nl
::
:: DELFT-FEWS: A platform for real time forecasting and water
:: resources management. Delft-FEWS is expert data handling and
:: model integration software for flood forecasting, drought and
:: seasonal forecasting, and real-time water resources management.
::
:: ----------------------------------------------------------------
:: data_update.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2019, by Deltares
::
:: Script to update the FEWS database schema from version v2020.02_20201026_1 to v2021.01_20200415_1
:: sqlcmd script
::  commandline parameters
::
:: Invocation  : data_update.bat <SERVER> <DATABASE> <USER> <SCHEMA>
:: Arguments   : %1 - sqlserver name
::               %2 - fews database to update
::               %3 - fews user
::               %4 - either dbo or fews user
:: Return      : none
:: Variables   : none
::

:: Check input parameters
IF [%4] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET server=%~1
SET database=%~2
SET username=%~3
SET schema=%~4
SET mcId=%~5

IF NOT [%6] == [] (
  SET password=%~6
) ELSE (
  SET /P password=Please enter fews password:
)

:: Other variables
SET schemaversion=v2021.01_20200415_1

echo  sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i data_update.sql -v strschema="%schema%" -v db_version="%schemaversion%"
sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i data_update.sql -v strschema="%schema%" -v db_version="%schemaversion%"

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Script to update the FEWS database schema from version v2020.02_20201026_1 to v2021.01_20200415_1.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^<SCHEMA^> ^[^<PASSWORD^>^]
ECHO.
ECHO Arguments   : ^<SERVER^>   - database server
ECHO               ^<DATABASE^> - fews database to update
ECHO               ^<USER^>     - fews user
ECHO               ^<SCHEMA^>   - depends on the database schema ^(select schema_name^(^)^) dbo or fews user
ECHO               ^[PASSWORD^] - optional password, if missing a command prompt is presented 
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on
