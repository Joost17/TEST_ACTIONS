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
:: setmaintenancemode.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2019, by Deltares
::
:: maintenance mode activation and deactivation script for SqlServer before running data_update.
:: It is assumed the sqlcmd executable is located in the user's PATH.
::
:: Invocation  : setmaintenancemode.bat <SERVER> <DATABASE> <USER> <SCHEMA> <MAINTENANCE_MODE>
:: Arguments   : %1 - sqlserver name
::               %2 - fews database to update
::               %3 - fews user
::               %4 - either dbo or fews user
::               %5 - 1 for on or 0 for off
ECHO.
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
SET maintenancemode=%~5

IF NOT [%6] == [] (
  SET password=%~6
) ELSE (
  SET /P password=Please enter fews password:
)

:: Other variables
SET schemaversion=v2021.01_20200415_1

echo sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i setmaintenancemode.sql -v schema="%schema%" -v maintenancemode=%maintenancemode%
sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i setmaintenancemode.sql -v schema="%schema%" -v maintenancemode=%maintenancemode%

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Script to maintenance mode activation and deactivation script for SqlServer before running data_update.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^<SCHEMA^> ^<MAINTANCE_MODE^> ^[^<PASSWORD^>^]
ECHO.
ECHO Arguments   : ^<SERVER^>           - database server
ECHO               ^<DATABASE^>         - fews database to update
ECHO               ^<USER^>             - fews user
ECHO               ^<SCHEMA^>           - depends on the database schema ^(select schema_name^(^)^), e.g. dbo or fews user
ECHO               ^<MAINTENANCE_MODE^> - 1 for on or 0 for off
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on
