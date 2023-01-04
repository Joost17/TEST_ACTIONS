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
:: Wrapper script for the creation of an open database and user on PostgreSQL for use with FEWS.
:: It is assumed the psql executable is located in the user's PATH
:: 
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database to create in database cluster
::  $2: user to create in database cluster
::  $3: new password of the user
::

:: Check if we have the right number of arguments
IF [%3] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Run the sql sqript
psql -f db_user_creation.sql -d "postgres" -U "postgres" -v database=%1 -v username=%2 -v user_password='%3'

:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the creation of an open database 
ECHO and user on PostgreSQL for use with FEWS.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^> ^<password^>
ECHO   where:
ECHO     ^<database^>: database to create in database cluster
ECHO     ^<username^>: user to create in database cluster
ECHO     ^<password^>: new password of the user
ECHO.

GOTO EndScript

:EndScript
@echo on
