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
CONNECT / AS SYSDBA

DEFINE strusername = &1
DEFINE dump_directory = &2

DROP DIRECTORY FEWSDB_DUMP_DIRECTORY;
GRANT CREATE ANY DIRECTORY TO &strusername;
GRANT EXP_FULL_DATABASE TO &strusername;
CREATE DIRECTORY FEWSDB_DUMP_DIRECTORY as '&dump_directory'; 

PROMPT 'FEWSDB_DUMP_DIRECTORY:';
SELECT directory_path FROM all_directories WHERE directory_name='FEWSDB_DUMP_DIRECTORY';

EXIT