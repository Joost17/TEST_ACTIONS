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
-- Delft-FEWS:
-- A platform for real time forecasting and water resources management,
-- expert data handling and model integration software for flood forecasting,
-- drought and seasonal forecasting, and real-time water resources management.
--
-- ----------------------------------------------------------------------------
-- File: db_user_creation.sql
-- ----------------------------------------------------------------------------
-- Description:
-- (re-)creates a user, database, and tablespaces and makes the new user the database owner with privileges to write into the tablespaces.
-- ----------------------------------------------------------------------------
\set data_tbs :database'_dat01'
\set index_tbs :database'_idx01'

-- Drop the database if it exists
DROP DATABASE :database;

-- Drop any existing tablespaces for this FEWS database
DROP TABLESPACE :data_tbs;
DROP TABLESPACE :index_tbs;

-- Drop the user if the account exists
DROP USER :username;

-- Create the user and grant database creation privileges
CREATE USER :username LOGIN PASSWORD :password;
CREATE DATABASE :database WITH OWNER = :username ENCODING = 'UTF8';
CREATE TABLESPACE :data_tbs OWNER :username LOCATION :data_path;
CREATE TABLESPACE :index_tbs OWNER :username LOCATION :index_path;
GRANT ALL PRIVILEGES ON TABLESPACE :data_tbs TO :username;
GRANT ALL PRIVILEGES ON TABLESPACE :index_tbs TO :username;

ALTER ROLE :username SET search_path TO :username;