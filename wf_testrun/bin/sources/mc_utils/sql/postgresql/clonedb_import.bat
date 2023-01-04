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
:: restore_db.bat
:: ----------------------------------------------------------------
::
:: Description:
:: Wrapper script for creating a clone of a FEWS database using a dump file on PostgreSQL.
:: It is assumed 
:: 1. the psql executable is located in the user's PATH
:: 2. the database to restore it in has the same encoding
:: 3. the dump file is in a location with sufficient disk space
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: Delft-FEWS database to restore the dump file into
::  $2: dump file to restore
::

@echo off

:: Check if we have the right number of arguments
IF [%2] == [] GOTO Syntax 

IF NOT [%3] == [] (
  SET PGPASSWORD=%~3
)
:: Make the environment variables local to this batch file
SETLOCAL

SET dst_database=%1
SET dump_file=%2

pg_restore -U "postgres" --dbname=%dst_database% %dump_file%

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for restoring a FEWS database dump on PostgreSQL.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<dst_database^> ^<dump_file^>
ECHO   where:
ECHO     ^<dst_database^>: database to import the dump file into
ECHO     ^<dump_file^>: file containing a dump of a Delft-FEWS database
ECHO.

GOTO EndScript

:EndScript
@echo on
