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

CONNECT / AS SYSDBA

DEFINE strusername=&1
DEFINE struserpass=&2
DEFINE datTableSpaceMaxSize=&3
DEFINE lobTableSpaceMaxSize=&4
DEFINE idxTableSpaceMaxSize=&5
DEFINE stroradat1=&6
DEFINE stroradat2=&7
DEFINE dump_directory = &8

-- Tablespace Creation
-- Approach:
--      A tablespace will be created for the following items:
--           1. Master Controller Data
--           2. Indexes on Master Controller Data tables
--           3. Module Data (tables assumed to be >128M <4G - check during development)
--	     4. Indexes on Module Data
--      Tablespace storage will be locally managed. Extent size will be determined as
--	follows:
--       a. Segments smaller than 128M should be placed in 128K extent tablespaces.
--       b. Segments between 128M and 4G should be placed in 4M extent tablespaces.
--       c. Segments larger than 4G should be placed in 128M extent tablespaces.
--      Datafiles will be a multiple of the extent size + 64k, which is the storage
--      overhead for locally managed tablespaces.
--      Datafiles for data and indexes on that data will be stored in different directories.


DROP USER &strusername CASCADE;
DROP TABLESPACE &strusername.Dat01;
DROP TABLESPACE &strusername.Idx01;
DROP TABLESPACE &strusername.Lob01;

-- Tablespace for most non-LOB data.
CREATE BIGFILE TABLESPACE &strusername.Dat01
    DATAFILE '&stroradat1/&strusername.MCDat01_01.dbf' SIZE 307234K REUSE
    AUTOEXTEND ON NEXT 4M MAXSIZE &datTableSpaceMaxSize.
    EXTENT MANAGEMENT LOCAL UNIFORM SIZE 4M;

-- Index tablespace
CREATE BIGFILE TABLESPACE &strusername.Idx01
    DATAFILE '&stroradat2/&strusername.MCIdx01_01.dbf' SIZE 153664K REUSE
    AUTOEXTEND ON NEXT 128K MAXSIZE &idxTableSpaceMaxSize.
    EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128k;

-- Tablespace used for LOB data
CREATE BIGFILE TABLESPACE &strusername.Lob01
    DATAFILE '&stroradat2/&strusername.ModDat01_01.dbf' SIZE 307234K REUSE
    AUTOEXTEND ON NEXT 4M MAXSIZE &lobTableSpaceMaxSize.
    EXTENT MANAGEMENT LOCAL UNIFORM SIZE 4M;

-- Create the clone user.
CREATE USER &strusername IDENTIFIED BY &struserpass
    TEMPORARY TABLESPACE TEMP DEFAULT TABLESPACE &strusername.Dat01;

GRANT IMP_FULL_DATABASE TO &strusername;

-- Some useful grants for this user.
GRANT connect, resource TO &strusername;

GRANT SELECT ON v_$session TO &strusername;
GRANT SELECT ON v_$parameter TO &strusername;
GRANT SELECT ON v_$resource_limit TO &strusername;
GRANT SELECT ON dba_data_files TO &strusername;
GRANT SELECT ON dba_free_space TO &strusername;

-- Ensure sufficient access to the application tablespaces.
-- Granting QUOTA on temporary tablespaces does not work any more on Oracle 10g R2, so no QUOTA UNLIMITED ON TEMP here
-- The fact that it worked was a bug in Oracle 9 and 10g R1. 
ALTER USER &strusername
   QUOTA UNLIMITED ON &strusername.DAT01
   QUOTA UNLIMITED ON &strusername.IDX01
   QUOTA UNLIMITED ON &strusername.LOB01;

DROP DIRECTORY FEWSDB_DUMP_DIRECTORY;
GRANT CREATE ANY DIRECTORY TO &strusername;
GRANT IMP_FULL_DATABASE TO &strusername;
GRANT EXP_FULL_DATABASE TO &strusername;
CREATE DIRECTORY FEWSDB_DUMP_DIRECTORY as '&dump_directory';

PROMPT 'FEWSDB_DUMP_DIRECTORY:';
SELECT directory_path FROM all_directories WHERE directory_name='FEWSDB_DUMP_DIRECTORY';

EXIT;