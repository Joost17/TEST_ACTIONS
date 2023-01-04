-- Delft-FEWS
-- ================================================================
--
-- Software Info: http://www.delft-fews.com
-- Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
--
-- (C) Copyright 2008, by Deltares
--                        P.O. Box 177
--                        2600 MH  Delft
--                        The Netherlands
--                        http://www.deltares.nl
--
-- DELFT-FEWS: A platform for real time forecasting and water
-- resources management. Delft-FEWS is expert data handling and
-- model integration software for flood forecasting, drought and
-- seasonal forecasting, and real-time water resources management.
--
-- ----------------------------------------------------------------
-- clonedb_preparation.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares

USE master;
GO

PRINT 'Creating database $(dst_database) NAME = ''$(dst_database)_Data'', FILENAME = ''$(dbfilepath)\$(dst_database)_data.mdf'') LOG ON (NAME = ''$(dst_database)_Log'', FILENAME = ''$(logfilepath)\$(dst_database)_log.ldf)''';

CREATE DATABASE $(dst_database) ON (
  NAME = '$(dst_database)_Data',
  FILENAME = '$(dbfilepath)\$(dst_database)_data.mdf'
) LOG ON (
  NAME = '$(dst_database)_Log', 
  FILENAME = '$(logfilepath)\$(dst_database)_log.ldf'
)
GO

ALTER DATABASE $(dst_database) SET ALLOW_SNAPSHOT_ISOLATION ON;
GO
ALTER DATABASE $(dst_database) SET SINGLE_USER;
GO
ALTER DATABASE $(dst_database) SET READ_COMMITTED_SNAPSHOT ON;
GO
ALTER DATABASE $(dst_database) SET MULTI_USER;
GO

USE $(dst_database)
GO

EXEC sp_grantdbaccess '$(strusername)'
GO

EXEC sp_addrolemember 'db_owner', '$(strusername)'
GO

USE master;
GO

GRANT VIEW SERVER STATE TO $(strusername);
GO