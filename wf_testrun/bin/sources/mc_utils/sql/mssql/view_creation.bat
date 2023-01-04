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
:: view_creation.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2019, by Deltares
::
:: Creates views in the FEWS database schema from version v2021.01_20200415_1.
::
:: sqlcmd script   - see https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
::
:: Invocation  : view_creation.bat <SERVER> <DATABASE> <USER> [<PASSWORD>]
:: Arguments   : %1 - database server
::               %2 - database to update
::               %3 - fews user
::
:: Command-line input: fews user password
::

:: Check input parameters
IF [%3] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET server=%~1
SET database=%~2
SET username=%~3

IF NOT [%4] == [] (
  SET password=%~4
) ELSE (
  SET /P password=Please enter fews password:
)

SET schema=dbo

:: Other variables
SET schemaversion=v2021.01_20200415_1

sqlcmd -V 17 -I -S "%server%" -d "%database%" -U "%username%" -P "%password%" -i view_creation.sql -v database="%database%" -v strusername="%schema%" -v db_version="%schemaversion%"

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates views in the FEWS database schema from version v2021.01_20200415_1.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^[^<PASSWORD^>^]
ECHO.
ECHO Arguments   : ^<SERVER^>        - database server
ECHO               ^<DATABASE^>      - name of the FEWS database to update
ECHO               ^<USER^>          - fews user
ECHO               ^[^<PASSWORD^>^]    - password ^(if not specified it will be asked by prompt^)
ECHO.
ECHO When prompted, enter the Delft-FEWS user password.
ECHO Clear command history using ALT-F7.
ECHO.

GOTO Endscript

:Endscript
@echo on
