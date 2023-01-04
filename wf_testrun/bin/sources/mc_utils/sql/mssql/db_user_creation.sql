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
-- db_user_creation.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2019, by Deltares


DROP USER $(username);
GO
DROP LOGIN $(username);
GO
DROP DATABASE $(database);
GO

CREATE DATABASE $(database) ON (
  NAME = N'$(database)_Data',
  FILENAME = N'$(dbfilepath)\$(database)_data.mdf'
) LOG ON (
  NAME = N'$(database)_Log',
  FILENAME = N'$(logfilepath)\$(database)_log.ldf'
);
GO

ALTER DATABASE $(database) SET ALLOW_SNAPSHOT_ISOLATION ON;
GO
ALTER DATABASE $(database) SET SINGLE_USER;
GO
ALTER DATABASE $(database) SET READ_COMMITTED_SNAPSHOT ON;
GO
ALTER DATABASE $(database) SET MULTI_USER;
GO

USE $(database)
GO

--CREATE LOGIN $(username) WITH PASSWORD=N'$(password)', DEFAULT_DATABASE=$(database), DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
CREATE LOGIN $(username) WITH PASSWORD=N'$(password)', DEFAULT_DATABASE=$(database), DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF;
GO
CREATE USER $(username) WITH DEFAULT_SCHEMA=$(schema);
GO
ALTER ROLE db_owner ADD MEMBER $(username);
GO


USE master;
GO

GRANT VIEW SERVER STATE TO $(username);
GO
