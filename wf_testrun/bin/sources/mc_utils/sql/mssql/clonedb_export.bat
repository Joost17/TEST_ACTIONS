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
@ECHO OFF

SET server=%1
SET src_database=%2
SET dump_file=%3

SET /P password=Please enter SA password:

sqlcmd -I -S%server% -d%src_database% -Usa -P "%password%" -iclonedb_export.sql -v src_database="%src_database%" -v dump_file="%dump_file%"
