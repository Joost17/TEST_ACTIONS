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
:: (C) Copyright 2008, by Deltares
::
:: Description:
::
:: Wrapper script for the Database script to update the database schema on PostgreSQL.
:: It is assumed the psql executable is located in the user's PATH
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database for FEWS system
::  $2: database owner user

:: Check if we have the right number of arguments
IF [%2] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

IF NOT [%3] == [] (
  SET PGPASSWORD=%~3
)

:: Run the sql sqript
psql -f %~dp0data_update.sql -d %1 -U %2 -v database=%1 -v strusername=%2

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the Database script to update the database schema on PostgreSQL.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^>
ECHO   where:
ECHO     ^<database^>: database for FEWS system
ECHO     ^<username^>: database owner user
ECHO.

GOTO EndScript

:EndScript
@echo on
