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
-- rebuild_indexes.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2008, by Deltares
-- Usage:
-- 1. Navigate to a directory with write permissions.
-- 2. Ensure the environment variable ORACLE_SID points to the correct database instance.
-- 3. Ensure the sqlplus executable can be found in your path.
-- 4. sqlplus <username>/<password>@<server>:<port>/<servicename> @rebuild_indexes
--    NB. Use the credentials of the fews schema owner, never of the sys dba or system user.

-- Known issues:
-- If an index is rebuild for which a write process has locked the table, the following error will appear and the index has not been rebuilt:
-- ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

SPOOL temp_rebuild_indexes.sql
SET TERMOUT OFF
SELECT 'PROMPT ' || index_name || ';' || chr(10) || 'ALTER INDEX ' || index_name || ' REBUILD;' FROM user_indexes WHERE NOT index_name LIKE '%$%' ORDER BY index_name;
SPOOL OFF

SET TERMOUT ON
SET TIMING ON
@temp_rebuild_indexes.sql
SET TIMING OFF

SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON

EXIT