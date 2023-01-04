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
:: (C) Copyright 2008, by Deltares
::
:: Description:
::
:: maintenance mode activation and deactivation script for PostgreSQL before running data_update..
:: It is assumed the psql executable is located in the user's PATH
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database for FEWS system
::  $2: database owner user
::  $3: maintenancemode 1 for activating maintancemode, 0 for deactivating maintenancemode
::

:: Check if we have the right number of arguments
IF [%3] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

IF NOT [%4] == [] (
  SET PGPASSWORD=%~4
)

:: Run the sql sqript
psql -f %~dp0setmaintenancemode.sql -d %1 -U %2 -v database=%1 -v username=%2 -v schema=%2 -v maintenancemode="%3"

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO maintenance mode activation and deactivation script for PostgreSQL before running data_update.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^> ^<maintenancemode^>
ECHO   where:
ECHO     ^<database^>: database for FEWS system
ECHO     ^<username^>: database owner user
ECHO     ^<maintenancemode^>: 1 for activating maintancemode, 0 for deactivating maintenancemode
ECHO.

:EndScript
@echo on
