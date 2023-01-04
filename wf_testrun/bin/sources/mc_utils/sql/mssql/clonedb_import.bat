@ECHO OFF
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
:: clonedb_import.bat
:: ----------------------------------------------------------------
:: (C) Copyright 2008, by Deltares
::
SET server=%1
SET dst_database=%2
SET username=%3
SET dump_file=%4
SET src_database=%5
SET src_database=%src_database:"=%
SET dbfilepath=%6
SET dbfilepath=%dbfilepath:"=%
SET logfilepath=%7
SET logfilepath=%logfilepath:"=%

SET /P userpass=Please enter sa password: 

ECHO sqlcmd -I -S%server% -d%dst_database% -Usa  -P "%userpass%" -iclonedb_import.sql -v dst_database=%dst_database% -v username=%username% -v dump_file="%dump_file%" -v src_database=%src_database% -v dbfilepath="%dbfilepath%" -v logfilepath="%logfilepath%"
sqlcmd -I -S%server% -d%dst_database% -Usa  -P "%userpass%" -iclonedb_import.sql -v dst_database=%dst_database% -v username=%username% -v dump_file="%dump_file%" -v src_database=%src_database% -v dbfilepath="%dbfilepath%" -v logfilepath="%logfilepath%"
