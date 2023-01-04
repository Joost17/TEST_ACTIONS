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
:: $Revision: 55008 $  $Date: 2015-07-06 15:17:07 +0200 (ma, 06 jul. 2015) $   $Author: breugel $
::
:: Creates users and filegroups for an open database for Delft FEWS on MS SQL Server.
::  T-SQL script is wrapped in a Batch file as osql does not accept script 
::  commandline parameters
::
:: Invocation  : tbs_user_creation.bat <SERVER> <DATABASE> <USER> <PASSWORD>
:: Arguments   : %1 - Database server.
::               %2 - Database to use.
::               %3 - Database instance user.
::               %4 - Database instance password.
:: Return      : none
:: Variables   : none
::

:: Check input parameters
IF [%4] == [] GOTO Syntax 


:: Make the environment variables local to this batch file
SETLOCAL

:: Input parameters:
SET strserver=%1
SET strdatabase=%2
SET strusername=%3
SET struserpass=%4
:: Path to the directory were the SQL Server database files reside, please update accordingly
SET dbfilepath=d:\var\mssql\data

:: File name of T-SQL script
SET tmpfilename= _tmp_tbs_user_creation.sql

:: Start of T-SQL script, which will be echoed to a temporary file
:: Escape character ^ has to be used when echoing ( ) > <
(
ECHO -- File: %tmpfilename%
ECHO --  Automatically created from batch file: %0
ECHO -- Should be automatically deleted if batch file has finished correctly
ECHO.
ECHO.
ECHO USE %strdatabase%
ECHO.
ECHO EXEC sp_dropuser '%strusername%'
ECHO GO
ECHO.
ECHO EXEC sp_droplogin '%strusername%'
ECHO GO
ECHO.
ECHO -- Tablespace Creation
ECHO -- Approach:
ECHO --      A tablespace will be created for the following items:
ECHO --           1. Data tables
ECHO --           2. Indexes Data tables
ECHO --      Datafiles for data and indexes on that data will be stored in different directories.
ECHO.      
ECHO ALTER DATABASE %strdatabase%
ECHO ADD FILEGROUP %strusername%_Dat01
ECHO GO
ECHO ALTER DATABASE %strdatabase%
ECHO ADD FILE
ECHO  ^(NAME = '%strusername%_Dat01',
ECHO   FILENAME = '%dbfilepath%\%strusername%.Dat01_01.ndf',
ECHO   SIZE = 300MB,
ECHO   MAXSIZE = 20480MB,
ECHO   FILEGROWTH = 4MB^)
ECHO  TO FILEGROUP %strusername%_Dat01
ECHO GO
ECHO.      
ECHO ALTER DATABASE %strdatabase%
ECHO ADD FILEGROUP %strusername%_Idx01
ECHO GO
ECHO ALTER DATABASE %strdatabase%
ECHO ADD FILE
ECHO  ^(NAME = '%strusername%_Idx01',
ECHO   FILENAME = '%dbfilepath%\%strusername%.Idx01_01.ndf',
ECHO   SIZE = 150MB,
ECHO   MAXSIZE = 5120MB,
ECHO   FILEGROWTH = 128KB^)
ECHO  TO FILEGROUP %strusername%_Idx01
ECHO GO
ECHO.      
ECHO EXEC sp_addlogin '%strusername%', '%struserpass%', '%strdatabase%'
ECHO GO
ECHO.
ECHO EXEC sp_grantdbaccess '%strusername%'
ECHO GO
ECHO.
ECHO EXEC sp_addrolemember 'db_owner', '%strusername%'
ECHO GO
ECHO.
ECHO.
) > %tmpfilename%
:: End of T-SQL script, write to temp file


:: Run the script on the database
ECHO Please enter the password for 'sa' on server '%1'
osql -S %1 -d %2 -U sa -n -i %tmpfilename%

:: Remove the temporary file
del %tmpfilename%

:: And finish this script
GOTO Endscript

:Syntax
:: Explain the syntax to the user
ECHO.
ECHO  %0: missing parameters
ECHO.
ECHO Creates users and filegroups for an open database 
ECHO for Delft FEWS on MS SQL Server.
ECHO  T-SQL script is wrapped in a Batch file as osql does not accept script 
ECHO  commandline parameters
ECHO.
ECHO Invocation  : %0 ^<SERVER^> ^<DATABASE^> ^<USER^> ^<PASSWORD^>
ECHO.
ECHO Arguments   : ^<SERVER^>   - Database server
ECHO               ^<DATABASE^> - Database to use
ECHO               ^<USER^>     - Database instance user
ECHO               ^<PASSWORD^> - Database instance password
ECHO.
ECHO Return      : none
ECHO.

GOTO Endscript

:Endscript
@echo on
