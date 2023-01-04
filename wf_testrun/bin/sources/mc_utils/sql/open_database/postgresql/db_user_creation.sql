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
-- $Revision: 38183 $  $Date: 2012-11-23 17:56:23 +0100 (vr, 23 nov. 2012) $   $Author: broek_f $
--

--
-- Creates a database and user for the Delft Fews system for PostgreSQL 8.x and newer
--
-- Invocation  : psql -f user_creation.sql -v username=$1 -v user_password=$2
-- Arguments   : $1 - Database owner user
--               $2 - Password for the user
-- Return      : none
-- Variables   : none
--

-- Drop the database if it exists
DROP DATABASE :database;

-- Drop any existing tablespaces for this database
\set data_tbs :database'_dat01'
\set index_tbs :database'_idx01'
DROP TABLESPACE :data_tbs;
DROP TABLESPACE :index_tbs;

-- Drop the user if the account exists
DROP USER :username;

-- Create the user and grant database creation privileges
CREATE USER :username LOGIN PASSWORD :user_password; 
CREATE DATABASE :database WITH OWNER = :username ENCODING = 'UTF8';
