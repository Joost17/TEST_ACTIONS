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
:: $Revision: 42335 $  $Date: 2013-09-24 11:43:24 +0200 (di, 24 sep. 2013) $   $Author: breugel $
::
:: Creates an open database for Delft FEWS on MS SQL Server.
::  T-SQL script is wrapped in a Batch file as osql does not accept script 
::  commandline parameters
::
:: Invocation  : database_creation.bat <SERVER> <DATABASE> 
:: Arguments   : %1 - Database server.
::               %2 - Database to create.
:: Return      : none
:: Variables   : none
::

:: Check input parameters
IF [%2] == [] GOTO Syntax 


:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET strserver=%1
SET strdatabase=%2
:: Path to the directory were the SQL Server database files reside, please update accordingly
SET dbfilepath=d:\var\mssql\data
:: Path to the directory were the SQL Server log files reside, please update accordingly
SET logfilepath=d:\var\mssql\data

:: File name of T-SQL script
SET tmpfilename=_tmp_database_creation.sql

:: Start of T-SQL script, which will be echoed to a temporary file
:: Escape character ^ has to be used when echoing ( ) > <
(
ECHO -- File: %tmpfilename%
ECHO --  Automatically created from batch file: %0
ECHO -- Should be automatically deleted if batch file has finished correctly
ECHO DROP DATABASE  %strdatabase%
ECHO.
ECHO. 
ECHO CREATE DATABASE %strdatabase% ON
ECHO ^( NAME = %strdatabase%_Data,
ECHO    FILENAME = '%dbfilepath%\%strdatabase%_data.mdf' ^)
ECHO LOG ON
ECHO ^( NAME = %strdatabase%_Log,
ECHO    FILENAME = '%logfilepath%\%strdatabase%_log.ldf' ^)
ECHO GO
ECHO.
ECHO.
) > %tmpfilename%
:: End of T-SQL script, write to temp file

ECHO.
ECHO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO WARNING:
ECHO If a database with name '%strdatabase%' already exists
ECHO on server '%1', it will be deleted. 
ECHO Press Ctrl-C to abort.
ECHO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO.
ECHO Please enter the password for 'sa' on server '%1'
osql -S %1 -U sa -n -i %tmpfilename%

:: Remove the temporary file
del %tmpfilename%

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates an open database for Delft FEWS on MS SQL Server.
ECHO  T-SQL script is wrapped in a Batch file as osql does not accept script 
ECHO  commandline parameters
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> 
ECHO.
ECHO Arguments   : ^<SERVER^>   - Database server
ECHO               ^<DATABASE^> - Name of the FEWS open database to create
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on
