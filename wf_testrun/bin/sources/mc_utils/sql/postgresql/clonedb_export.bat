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
:: clonedb_export.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2008, by Deltares
::
:: Description:
:: Wrapper script for the dump file creation of a FEWS database on PostgreSQL.
:: It is assumed
:: 1. the pg_dump executable is located in the user's PATH
:: 2. when using this script for migration to a newer Postgres database, the tooling of the newer Postgres version is used
:: 3. location for the dump file has sufficient disk space
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: Delft-FEWS database to create a dump of
::  $2: dump file to create
::

@echo off

:: Check if we have the right number of arguments
IF [%2] == [] GOTO Syntax

IF NOT [%3] == [] (
  SET PGPASSWORD=%~3
)

:: Make the environment variables local to this batch file
SETLOCAL

SET src_database=%1
SET dump_file=%2

pg_dump -U postgres --format c --blobs --dbname=%src_database% --file=%dump_file%

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the dump file creation of a Delft-FEWS database on PostgreSQL.
ECHO It is assumed the pg_dump executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<src_database^> ^<dump_file^>
ECHO   where:
ECHO     ^<src_database^>: database to create a dump file of
ECHO     ^<dump_file^>: file to store the dump file in
ECHO.

GOTO EndScript

:EndScript
@echo on
