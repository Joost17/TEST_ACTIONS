:: ================================================================
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
:: DELFT-FEWS: A platform for real time forecasting and water resources management.
:: Delft-FEWS is expert data handling and model integration software for flood forecasting, 
:: drought and seasonal forecasting, and real-time water resources management
::
:: ----------------------------------------------------------------
:: Description:
:: Wrapper script for the creation of a FEWS database and user on PostgreSQL.
:: It is assumed the psql executable is located in the user's PATH
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database schema to create in database
::  $2: user
::  $3: storage directory for the data tablespace
::  $4: storage directory for the index tablespace
::

@echo off

:: Check if we have the right number of arguments
IF [%4] == [] GOTO Syntax

:: Make the environment variables local to this batch file
SETLOCAL

:: Run the sql sqript

SET database=%1
SET username=%2
SET data_path=%3
SET data_path=%data_path:"=%
SET index_path=%4
SET index_path=%index_path:"=%

IF NOT [%5] == [] (
  SET password=%~5
) ELSE (
  SET /P password=Please enter fews user password:
)

IF NOT [%6] == [] (
  SET PGPASSWORD=%~6
)
echo psql -f %~dp0db_user_creation.sql -d "postgres" -U "postgres" -v database=%database% -v username=%username% -v password='%password%' -v data_path='%data_path%' -v index_path='%index_path%'
psql -f %~dp0db_user_creation.sql -d "postgres" -U "postgres" -v database=%database% -v username=%username% -v password='%password%' -v data_path='%data_path%' -v index_path='%index_path%'

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the creation of a Delft-FEWS database and user on PostgreSQL.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^> ^<data_path^> ^<index_path^> 
ECHO   where:
ECHO     ^<database^>: database to create in PostgreSQL
ECHO     ^<username^>: user
ECHO     ^<data_path^>: storage directory for the data tablespace
ECHO     ^<index_path^>: storage directory for the index tablespace
ECHO.

GOTO EndScript

:EndScript
@echo on