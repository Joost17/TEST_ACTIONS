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
:: Wrapper script for the creation of tablespaces for a FEWS open database on PostgreSQL.
:: It is assumed the psql executable is located in the user's PATH
:: 
::
:: Return Values:
::  none
::
:: Command line options and arguments
::  $1: database for FEWS system
::  $2: database owner user
::  $3: directory for data tablespace
::  $4: directory for index tablespace
::   
::

:: Check if we have the right number of arguments
IF [%4] == [] GOTO Syntax 

:: Make the environment variables local to this batch file
SETLOCAL

:: Run the sql sqript
psql -f tbs_creation.sql -d %1 -U "postgres" -v database=%1 -v db_owner=%2 -v data_path='%3' -v index_path='%4'
:: And finish the script
GOTO EndScript

:Syntax
:: Explain the syntax to the user
ECHO Wrapper script for the creation of tablespaces 
ECHO for a FEWS open database on PostgreSQL.
ECHO It is assumed the psql executable is located in the user's PATH.
ECHO.
ECHO Usage: %0 ^<database^> ^<username^> ^<tbs_path1^> ^<tbs_path2^>
ECHO   where:
ECHO     ^<database^>: database for FEWS system
ECHO     ^<username^>: database owner user
ECHO     ^<tbs_path1^>: directory for data tablespace (use '/' instead of '\')
ECHO     ^<tbs_path2^>: directory for index tablespace (use '/' instead of '\')
ECHO.

GOTO EndScript

:EndScript
@echo on
