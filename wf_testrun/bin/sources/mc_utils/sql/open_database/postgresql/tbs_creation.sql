--
-- Delft FEWS
-- Copyright (c) 2003-2012 Deltares. All Rights Reserved.
--
-- Developed by:
-- Tessella
-- Tauro Kantorencentrum
-- President Kennedylaan 19
-- 2517 JK Den Haag
-- The Netherlands
-- email: info@tessella.com
-- web:   www.tessella.com
--
-- Project Ref: Tessella/NPD/7488
--
-- File history
-- Version           Date                           Author
-- $Revision: 55008 $  $Date: 2015-07-06 15:17:07 +0200 (ma, 06 jul. 2015) $   $Author: breugel $
--

--
-- Creates tablespaces for an open database for Delft FEWS for PostgreSQL 8.x and newer
-- Must be run as a postgreSQL superuser
--
-- Invocation  : psql -f tbs_creation.sql -d $1 -v database=$2 -v db_owner=$3 -v data_path=$4 -v index_path=$5 
-- Arguments   : $1 - Database instance
--               $2 - Database instance
--               $3 - Database owner user
--               $4 - Directory where to create the data tablespace
--               $5 - Directory where to create the index tablespace
-- Return      : none
-- Variables   : none
--

-- Define the tablespace names from the database instance name to provide uniqueness
\set data_tbs :database'_dat01'
\set index_tbs :database'_idx01'

-- Drop any existing tablespaces
DROP TABLESPACE :data_tbs;
DROP TABLESPACE :index_tbs;
  
-- Tablespace Creation
-- Approach:
--      A tablespace will be created for the following items:
--           1. Data tables
--           2. Indexes Data tables
--      Datafiles for data and indexes on that data will be stored in different directories.
--      A separate tablespace for LOB data will not be used by PostgreSQL

-- Tablespace for data.
CREATE TABLESPACE :data_tbs LOCATION :data_path;
      
-- Index tablespace
CREATE TABLESPACE :index_tbs LOCATION :index_path;
   
-- Ensure that the tablespace owner has sufficient access to the application 
-- tablespaces.
GRANT ALL PRIVILEGES ON TABLESPACE :data_tbs TO :db_owner;
GRANT ALL PRIVILEGES ON TABLESPACE :index_tbs TO :db_owner;   
