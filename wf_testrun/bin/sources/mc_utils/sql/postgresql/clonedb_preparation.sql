-- ================================================================
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
-- DELFT-FEWS: A platform for real time forecasting and water resources management.
-- Delft-FEWS is expert data handling and model integration software for flood forecasting, 
-- drought and seasonal forecasting, and real-time water resources management
--
-- ----------------------------------------------------------------
\set data_tbs :dst_database'_dat01'
\set index_tbs :dst_database'_idx01'

CREATE DATABASE :dst_database WITH OWNER = :username ENCODING = 'UTF8';

-- Create separate tablespaces for Master Controller Data and indexes, a separate tablespace for LOB data cannot be used by PostgreSQL.
CREATE TABLESPACE :data_tbs OWNER :username LOCATION :data_path;
CREATE TABLESPACE :index_tbs OWNER :username LOCATION :index_path;

-- Grant tablespace access to owner.
GRANT ALL PRIVILEGES ON TABLESPACE :data_tbs TO :username;
GRANT ALL PRIVILEGES ON TABLESPACE :index_tbs TO :username;