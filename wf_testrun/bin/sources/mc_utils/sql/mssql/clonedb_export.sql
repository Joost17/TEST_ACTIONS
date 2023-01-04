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
-- clonedb_export.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares

PRINT 'BACKUP DATABASE $(src_database) TO DISK = $(dump_file)';
BACKUP DATABASE $(src_database) TO DISK = '$(dump_file)';