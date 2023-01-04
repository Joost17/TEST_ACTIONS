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
:: schema_creation.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2019, by Deltares
::
:: Creates tables in the FEWS database schema from version v2021.01_20200415_1.
::
:: sqlcmd script   - see https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
::
:: Invocation  : schema_creation.bat <SERVER> <DATABASE> <USER> <MCID> <DATABASEINTID> [<PASSWORD>]
:: Arguments   : %1 - sqlserver name
::               %2 - database name
::               %3 - fews user
::               %4 - mcId
::               %5 - databaseintid - unique offset in the synchronisation pool 0-97 for generating globalRowIds

:: Check input parameters
IF [%5] == [] GOTO Syntax

:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET server=%~1
SET database=%~2
SET username=%~3
SET mcId=%~4
SET databaseintid=%~5

SET schema=dbo

IF NOT [%6] == [] (
  SET password=%~6
) ELSE (
  SET /P password=Please enter fews password:
)

:: Other variables
SET schemaversion=v2021.01_20200415_1

sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i schema_creation.sql -v database="%database%" -v strschema="%schema%" -v mcId="%mcId%" -v databaseIntId="%databaseIntId%" -v db_version="%schemaversion%"

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates tables in the FEWS database schema from version v2021.01_20200415_1.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^<MCID^> ^<DATABASEINTID^> ^[^<PASSWORD^>^]
ECHO.
ECHO Arguments   : ^<SERVER^>        - database server
ECHO               ^<DATABASE^>      - name of the FEWS database to update
ECHO               ^<USER^>          - fews user
ECHO               ^<MCID^>          - mcId
ECHO               ^<DATABASEINTID^> - unique offset in the synchronisation pool 0-97 for generating globalRowIds
ECHO               ^[^<PASSWORD^>^]    - password ^(if not specified it will be asked by prompt^)
ECHO When prompted, enter the Delft-FEWS user password.
ECHO Clear command history using ALT-F7.
ECHO.

GOTO Endscript

:Endscript
