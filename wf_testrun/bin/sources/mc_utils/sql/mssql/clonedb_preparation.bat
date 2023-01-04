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
:: clonedb_preparation.sql
:: ----------------------------------------------------------------
:: (C) Copyright 2008, by Deltares
::
:: Check input parameters
IF [%5] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET server=%1
SET server=%server:"=%

SET dst_database=%2
SET dst_database=%dst_database:"=%

SET username=%3
SET username=%username:"=%

SET dbfilepath=%4
SET dbfilepath=%dbfilepath:"=%

SET logfilepath=%5
SET logfilepath=%logfilepath:"=%

ECHO.
ECHO Installing clone database:
ECHO   SERVER:      %server%
ECHO   DATABASE:    %dst_database%
ECHO   USER:        %username%
ECHO   DBFILEPATH:  %dbfilepath%
ECHO   LOGFILEPATH: %logfilepath%
ECHO.

SET /P password=Please enter sa password:

ECHO sqlcmd -V 17 -I -S "%server%" -U sa -P "%password%" -i clonedb_preparation.sql -v dst_database="%dst_database%" -v username="%username%" -v dbfilepath="%dbfilepath%" -v logfilepath="%logfilepath%"

sqlcmd -V 17 -I -S "%server%" -U sa -P"%password%" -i clonedb_preparation.sql -v dst_database="%dst_database%" -v username="%username%" -v dbfilepath="%dbfilepath%" -v logfilepath="%logfilepath%"

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates a database and user for the Delft-FEWS system on MS SQL Server for version v2021.01_20200415_1.
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DST_DATABASE^> ^<USER^> ^<DBFILEPATH^> ^<LOGFILEPATH^>
ECHO.
ECHO Arguments   : ^<SERVER^>       - Database server
ECHO               ^<DST_DATABASE^> - Name of the FEWS database to update
ECHO               ^<USER^>     - Fews db userid
ECHO               ^<DBFILEPATH^>   - Directory of the MS SQL Server database files
ECHO               ^<LOGFILEPATH^>  - Directory of the MS SQL Server log files
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on
