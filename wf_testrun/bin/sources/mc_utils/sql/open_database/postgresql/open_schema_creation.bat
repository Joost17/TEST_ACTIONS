@echo off
::
:: Delft FEWS
:: Copyright (c) 2003-2012 Deltares. All Rights Reserved.
::
:: Developed by:
:: Tessella
:: Tauro Kantorencentrum
:: President Kennedylaan 19
:: 2517 JK Den Haag
:: The Netherlands
:: email: info@tessella.com
:: web:   www.tessella.com
::
:: Project Ref: Tessella/NPD/7488
::
:: File history
:: Version           Date                           Author
:: $Revision: 38183 $     $Date: 2012-11-23 17:56:23 +0100 (vr, 23 nov. 2012) $                       $Author: broek_f $
::
:: Description:
:: 
:: Wrapper script for the creation of schema and tables for a FEWS open database on PostgreSQL.
:: It is assumed the psql executable is located in the user's PATH
:: 
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database for FEWS system
::  $2: database owner user
::   
::

:: Check if we have the right number of arguments
IF [%2] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Run the sql sqript
psql -f open_schema_creation.sql -d %1 -U %2 -v database=%1 -v username=%2 

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the creation of schema and tables
ECHO for a FEWS open database on PostgreSQL.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^>
ECHO   where:
ECHO     ^<database^>: database for FEWS open database
ECHO     ^<username^>: database owner user
ECHO.

GOTO EndScript

:EndScript
@echo on
