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
-- clonedb_import.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares
--

USE master;

--find database files and their location
RESTORE FILELISTONLY FROM DISK = '$(dump_file)';
GO

ALTER DATABASE $(dst_database) SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

USE master;

--All items listed by above query must be relocated using move
PRINT 'MOVE $(src_database)_Data TO $(dbfilepath)\$(dst_database)_Data.mdf';
PRINT 'MOVE $(strusername)_MCDat01 TO $(dbfilepath)\$(strusername).MCDat01_01.ndf';
PRINT 'MOVE $(strusername)_MCIdx01 TO $(dbfilepath)\$(strusername).MCIdx01_01.ndf';
PRINT 'MOVE $(strusername)_ModDat01 TO $(dbfilepath)\$(strusername).ModDat01_01.ndf';
PRINT 'MOVE $(src_database)_Log TO $(logfilepath)\$(dst_database)_log.ldf';
GO

RESTORE DATABASE $(dst_database) FROM  DISK = N'$(dump_file)'
  WITH
    FILE = 1,
    MOVE N'$(src_database)_Data' TO N'$(dbfilepath)\$(dst_database)_clone_Data.mdf',
    MOVE N'$(strusername)_MCDat01' TO N'$(dbfilepath)\$(strusername)_clone.MCDat01_01.ndf',
    MOVE N'$(strusername)_MCIdx01' TO N'$(dbfilepath)\$(strusername)_clone.MCIdx01_01.ndf',
    MOVE N'$(strusername)_ModDat01' TO N'$(dbfilepath)\$(strusername)_clone.ModDat01_01.ndf',
    MOVE N'$(src_database)_Log' TO N'$(logfilepath)\$(dst_database)_clone_log.ldf',
    NOUNLOAD, REPLACE, STATS = 5;
GO

ALTER DATABASE $(dst_database) SET MULTI_USER;
GO
