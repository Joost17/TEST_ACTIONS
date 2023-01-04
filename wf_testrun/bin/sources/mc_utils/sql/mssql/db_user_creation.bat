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
:: db_user_creation.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2019, by Deltares
::
:: Creates database and fews user for the Delft-FEWS system for version v2021.01_20200415_1.
::
:: sqlcmd script   - see https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
:: password policy - see https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy
::
:: Invocation  : db_user_creation.bat <SERVER> <DATABASE> <USER> <DBFILEPATH> <LOGFILEPATH> [<PASSWORD> [<SA_PASSWORD>]]
:: Arguments   : %1 - sqlserver host
::               %2 - database name
::               %3 - fews user
::               %4 - dbfilepath
::               %5 - logfilepath
:: Command-line input1: fews user password
:: Command-line input2: sa password

:: Check input parameters
IF [%5] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Clean quotes from input parameters:
SET server=%~1
SET database=%~2
SET username=%~3
SET dbfilepath=%~4
SET logfilepath=%~5

IF NOT [%6] == [] (
  SET password=%~6
) ELSE (
  SET /P password=Please enter fews password ^(must comply to password policy^):
)

IF NOT [%7] == [] (
  SET sa_password=%~7
) ELSE (
  SET /P sa_password=Please enter sa password:
)

:: Other variables
SET schema=dbo
SET schemaversion=@dbversion@

ECHO.
ECHO Installing database for version %schemaversion%
ECHO.
ECHO   SERVER=%server%
ECHO   DATABASE: %database%
ECHO   USER: %username%
ECHO   SCHEMA: %schema%
ECHO   DBFILEPATH: %dbfilepath%
ECHO   LOGFILEPATH: %logfilepath%
ECHO.

sqlcmd -V 17 -I -S "%server%" -U sa -P "%sa_password%" -i db_user_creation.sql -v database="%database%" -v username="%username%" -v schema="%schema%" -v password="%password%" -v db_version="%schemaversion%" -v dbfilepath="%dbfilepath%" -v logfilepath="%logfilepath%"

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates a database and user for the Delft-FEWS system on MS SQL Server for version v2021.01_20200415_1.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^<DBFILEPATH^> ^<LOGFILEPATH^> ^[^<PASSWORD^> ^[^<SA_PASSWORD^>^]^]
ECHO.
ECHO Arguments   : ^<SERVER^>        - sqlserver name
ECHO               ^<DATABASE^>      - database name
ECHO               ^<USER^>          - fews user
ECHO               ^<DBFILEPATH^>    - directory of the MS SQLServer database files, surround with double quotes
ECHO               ^<LOGFILEPATH^>   - directory of the MS SQLServer log files, surround with double quotes
ECHO               ^[^<PASSWORD^>^]    - fews password
ECHO               ^[^<SA_PASSWORD^>^] - sa password
ECHO.
ECHO When prompted, enter first the Delft-FEWS user password ^(must comply to password policy^) and secondly the sa password.
ECHO Clear command history using ALT-F7.
ECHO.
GOTO Endscript

:Endscript
