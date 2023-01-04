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
-- tbs_user_creation.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2019, by Deltares
-- ----------------------------------------------------------------
-- Creates tablespaces and users for Delft-FEWS system with version v2021.01_20200415_1

-- Log on the Oracle server.
--1. Oracle must be running with an instance created and a listener present, see lsnrctl status
--2. Ensure sqlplus is available on the PATH
--3. When not already set, set the ORACLE_HOME variable, e.g.
--Linux: export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
--Windows: SETX /M ORACLE_HOME=C:\app\oracle\product\19.0.0\dbhome_1
--4. When not already set, set the ORACLE_SID variable, e.g.
--Linux: export ORACLE_SID=fewsmc00
--Windows: SETX /M ORACLE_SID=fewsmc00
--5 create a suitable password composed of the characters A-Za-z0-9@%+\/"@%+\/^?:,(){}[]~-_. The default length required by Oracle is 4-30 characters long.
--6. Connect as oracle user
-- a> sqlplus /nolog
-- b> connect SYS as sysdba
--7. Run the @tbs_user_creation script option with (a) all the required parameters or (b) with the full path to an XML file containing the required parameters.
-- a.
-- @tbs_user_creation <fewsSchemaOwnerUser> <pass01word> [storagedir1] [storagedir2] [datTableSpaceMaxSize] [lobTableSpaceMaxSize] [idxTableSpaceMaxSize]
-- e.g. @tbs_user_creation mc00 mc00SecretPassword
-- @tbs_user_creation mc00 mc00SecretPassword D:\oracle18\data\dbfiles01 D:\oracle18\data\dbfiles02 10G 10G 1G
-- b. Pass the full path to an XML file as the single argument
-- Usage 2: Pass the full path to an XML file
--> @tbs_user_creation <fewsSchemaOwnerUser> <pass01word> [storagedir1] [storagedir2] [datTableSpaceMaxSize] [lobTableSpaceMaxSize] [idxTableSpaceMaxSize]
-- e.g.
--> @tbs_user_creation mc00 mc00SecretPassword D:\oracle18\data\dbfiles01 D:\oracle18\data\dbfiles02 10G 10G 1G
--
-- PS. scripting is also possible, e.g.:
--linux: echo EXIT| rlwrap sqlplus "/ AS SYSDBA" -NOLOGINTIME -M "CSV ON" -S "SYS"/"SECRETPASSWORD"\\localhost:1521 AS SYSDBA @tbs_user_creation <arguments as in 7a. and 7b.>

--<?xml version="1.0" encoding="UTF-8"?>
--<mcs xmlns="http://www.wldelft.nl/fews" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.wldelft.nl/fews
--  http://fews.wldelft.nl/schemas/version1.0/mcInstall.xsd">
--    <mc id="fewsmc00" databaseIntId="0">
--        <databaseServer>
--            <url>jdbc:oracle:thin:@localhost:1521/mc00</url>
--            <user>fewsmc00</user>
--            <password>secretPassword</password>
--        </databaseServer>
--        <!-- The following elements are optional, when not specified the default storage directories will be used -->
--        <datTablespaceDir>d:/oracle19/oradata/dbfiles01</datTablespaceDir>
--        <lobIdxTablespaceDir>d:/oracle19/oradata/dbfiles02</lobIdxTablespaceDir>
--        <datTablespaceMaxSize>10G</datTablespaceMaxSize>
--        <lobTablespaceMaxSize>10G</lobTablespaceMaxSize>
--        <idxTablespaceMaxSize>1G</idxTablespaceMaxSize>
--    </mc>
--</mcs>

SET VERIFY OFF

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK;

ALTER SESSION SET "_ORACLE_SCRIPT"=true;

DEFINE defDatTableSpaceMaxSize=10G
DEFINE defLobTableSpaceMaxSize=10G
DEFINE defIdxTableSpaceMaxSize=1G

-- skip substitution for 7 arguments, instead print usage and exit when not enough parameters are passed
SET VERIFY OFF
SET SERVEROUTPUT OFF
SET TERMOUT OFF
SET SERVEROUTPUT ON FORMAT WRAPPED


COLUMN 1 NEW_VALUE 1
COLUMN 2 NEW_VALUE 2
COLUMN 3 NEW_VALUE 3
COLUMN 4 NEW_VALUE 4
COLUMN 5 NEW_VALUE 5
COLUMN 6 NEW_VALUE 6
COLUMN 7 NEW_VALUE 7
SELECT 1, 2, 3, 4, 5, 6, 7 FROM DUAL WHERE NULL IS NOT NULL;

SET SERVEROUTPUT ON FEEDBACK ON HEAD ON TERMOUT ON
SET LINESIZE 220;
SET PAGESIZE 50000;
SET LONG 50000;

--allow script name to be read
SET APPINFO ON
DECLARE
  v_exe VARCHAR2(255);
  v_module_name varchar2(100);
  v_action_name varchar2(100);
BEGIN
  dbms_application_info.read_module(v_module_name, v_action_name);
  IF INSTR(v_module_name, ' ') > 0 THEN
    v_module_name := SUBSTR(v_module_name, 1 + INSTR(v_module_name, ' '));
  END IF;
  v_exe := 'echo exit | sqlplus -NOLOGINTIME -M "CSV ON" -S "<SYS"/"**********"\\<host>:<port> AS SYSDBA @' || v_module_name;
  IF '&1' IS NULL OR UPPER('&1')='EXIT' THEN
    RAISE_APPLICATION_ERROR(-20000, CHR(10) ||
      'Usage 1: ' || v_exe || ' <user> <password> [datTablespaceDir] [lobIdxTablespaceDir] [datTablespaceMaxSize] [lobTablespaceMaxSize] [idxTablespaceMaxSize]' || CHR(10) ||
      'Usage 2: '|| CHR(10) || v_exe || ' <xmlfile>');
  END IF;
END;
/

CREATE OR REPLACE FUNCTION get_dir(p_path IN VARCHAR2) RETURN varchar2 IS
  v_index1 INTEGER;
  v_index2 INTEGER;
BEGIN
  v_index1 := INSTR(p_path, '/', -1, 1);
  v_index2 := INSTR(p_path, '\', -1, 1);
  IF v_index1 > v_index2 THEN
    return SUBSTR(p_path, 1, v_index1);
  END IF;
  IF v_index2 > 0 THEN
    return SUBSTR(p_path, 1, v_index2);
  END IF;
  return p_path;
END;
/

CREATE OR REPLACE FUNCTION get_file(p_path IN VARCHAR2) RETURN varchar2 IS
  v_index1 INTEGER;
  v_index2 INTEGER;
BEGIN
  v_index1 := INSTR(p_path, '/', -1, 1);
  v_index2 := INSTR(p_path, '\', -1, 1);
  IF v_index1 > v_index2 THEN
    return SUBSTR(p_path, v_index1 + 1, length(p_path));
  END IF;
  IF v_index2 > 0 THEN
    return SUBSTR(p_path, v_index2 + 1, length(p_path));
  END IF;
  return p_path;
END;
/

CREATE OR REPLACE PROCEDURE execute_with_log(p_cmd VARCHAR2) AS
  v_cmd VARCHAR2(1000);
BEGIN
  DBMS_OUTPUT.PUT_LINE(p_cmd || ';');
  EXECUTE IMMEDIATE p_cmd;
END;
/

CREATE OR REPLACE PROCEDURE create_or_replace_user(p_user IN VARCHAR2, p_password IN VARCHAR2,
  p_datTablespace IN VARCHAR2, p_lobTablespace IN VARCHAR2, p_idxTablespace IN VARCHAR2) AS
BEGIN
  DBMS_OUTPUT.PUT_LINE(CHR(10) || '(Re-)creating user ' || p_user || '...');
  FOR x IN (SELECT COUNT(1) cnt FROM DUAL WHERE EXISTS(SELECT NULL FROM all_users WHERE UPPER(username)=UPPER(p_user))) LOOP
    IF (x.cnt = 1) THEN
      execute_with_log('DROP USER ' || p_user || ' CASCADE');
    END IF;
  END LOOP;
  execute_with_log('CREATE USER ' || p_user || ' IDENTIFIED BY "' || p_password || '" TEMPORARY TABLESPACE TEMP DEFAULT TABLESPACE ' || p_datTablespace);
  execute_with_log('GRANT CONNECT TO ' || p_user);
  execute_with_log('GRANT CREATE VIEW TO ' || p_user);
  execute_with_log('GRANT RESOURCE TO ' || p_user);
  execute_with_log('GRANT SELECT ON dba_data_files TO ' || p_user);
  execute_with_log('GRANT SELECT ON dba_free_space TO ' || p_user);
  execute_with_log('GRANT SELECT ON dba_stat_extensions TO ' || p_user);
  execute_with_log('GRANT SELECT ON v_$parameter TO ' || p_user);
  execute_with_log('GRANT SELECT ON v_$resource_limit TO ' || p_user);
  execute_with_log('GRANT SELECT ON v_$session TO ' || p_user);
  execute_with_log('ALTER USER ' || p_user || ' QUOTA UNLIMITED ON ' || p_datTablespace || ' QUOTA UNLIMITED ON ' || p_lobTablespace || ' QUOTA UNLIMITED ON ' || p_idxTablespace);
END;
/

CREATE OR REPLACE PROCEDURE create_tbs_and_user(p_user IN VARCHAR2, p_password IN VARCHAR2,
  p_datTablespaceDir IN VARCHAR2, p_lobIdxTablespaceDir IN VARCHAR2,
  p_datTablespaceMaxSize IN VARCHAR2, p_lobTablespaceMaxSize IN VARCHAR2, p_idxTablespaceMaxSize IN VARCHAR2) AS

  v_password VARCHAR2(128);
  v_separator VARCHAR2(1);
  v_defaultDataDir VARCHAR2(255);
  v_datTablespaceDir VARCHAR2(255);
  v_lobIdxTablespaceDir VARCHAR2(255);
  v_datTablespace VARCHAR2(30);
  v_lobTablespace VARCHAR2(30);
  v_idxTablespace VARCHAR2(30);
BEGIN
  IF (p_user IS NULL) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Missing <user> ');
  END IF;
  v_password := p_password;
  IF (v_password IS NULL) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Missing <password> ');
  END IF;

  SELECT SUBSTR(REPLACE(file_name, '\', '/'), 1, INSTR(REPLACE(file_name, '\', '/'), '/', -1, 1)) defaultDataDir INTO v_defaultDataDir
    FROM dba_data_files WHERE tablespace_name = (SELECT property_value FROM database_properties WHERE property_name='DEFAULT_PERMANENT_TABLESPACE');

  v_datTablespaceDir := NVL(p_datTablespaceDir, v_defaultDataDir);
  v_lobIdxTablespaceDir := NVL(p_lobIdxTablespaceDir, v_defaultDataDir);
  v_datTablespaceDir := REPLACE(v_datTablespaceDir, '\', v_separator);
  v_lobIdxTablespaceDir := REPLACE(v_lobIdxTablespaceDir, '\', v_separator);
  v_separator := SUBSTR(v_defaultDataDir, -1, 1);
  v_datTablespace := UPPER(p_user || 'Dat01');
  v_lobTablespace := UPPER(p_user || 'Lob01');
  v_idxTablespace := UPPER(p_user || 'Idx01');

  DBMS_OUTPUT.PUT_LINE(CHR(10) || '(Re-)creating tablespaces ' || v_datTablespace || ', ' || v_lobTablespace || ', ' || v_idxTablespace || ' for user ' || p_user || '...');
  FOR x IN (SELECT tablespace_name FROM user_tablespaces WHERE tablespace_name IN (v_datTablespace, v_lobTablespace, v_idxTablespace) AND tablespace_name NOT LIKE 'UNDOTBS%' AND tablespace_name NOT IN('SYSTEM', 'SYSAUX', 'TEMP', 'USERS')) LOOP
      execute_with_log('DROP TABLESPACE ' || x.tablespace_name);
  END LOOP;

  execute_with_log('CREATE TABLESPACE ' || v_lobTablespace || ' DATAFILE ''' || v_lobIdxTablespaceDir || '/' || p_user || 'ModDat01_01.dbf'' SIZE 307234K REUSE AUTOEXTEND ON NEXT 4M MAXSIZE ' || NVL(p_lobTablespaceMaxSize, '&defLobTableSpaceMaxSize.') || ' EXTENT MANAGEMENT LOCAL UNIFORM SIZE 4M');
  execute_with_log('CREATE TABLESPACE ' || v_datTablespace || ' DATAFILE ''' || v_datTablespaceDir || '/' || p_user || 'MCDat01_01.dbf'' SIZE 307234K REUSE AUTOEXTEND ON NEXT 4M MAXSIZE ' || NVL(p_datTablespaceMaxSize, '&defDatTableSpaceMaxSize.') || ' EXTENT MANAGEMENT LOCAL UNIFORM SIZE 4M');
  execute_with_log('CREATE TABLESPACE ' || v_idxTablespace || ' DATAFILE ''' || v_lobIdxTablespaceDir || '/' || p_user || 'ModIdx01_01.dbf'' SIZE 153664K REUSE AUTOEXTEND ON NEXT 128K MAXSIZE ' || NVL(p_idxTablespaceMaxSize, '&defIdxTableSpaceMaxSize.') || ' EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K');

  create_or_replace_user(p_user, v_password, v_datTablespace, v_lobTablespace, v_idxTablespace);

  DBMS_OUTPUT.PUT_LINE(CHR(10) || RPAD('TABLESPACE_NAME', 31) || RPAD('MAXBYTESIZEMB', 14) || RPAD('INCREMENTKB', 12) || RPAD('AUTOEXTENSIBLE', 15) || 'FILENAME');
  FOR x IN (SELECT tablespace_name, filename, maxByteSizeMb, increment_by * (SELECT DISTINCT bytes/blocks FROM user_segments where blocks != 0) /1024 AS incrementkb, autoextensible
    FROM (SELECT ddf.file_name AS filename, ddf.tablespace_name, ddf.increment_by , ddf.autoextensible,
       TRUNC(DECODE(autoextensible,'YES', ddf.bytes - SUM(dfs.bytes), 'NO', ddf.bytes) / 1024 / 1024) AS usedByteSizeMb,
            TRUNC(ddf.bytes / 1024 / 1024) AS allocatedByteSizeMb,
            TRUNC(DECODE(autoextensible,'YES', ddf.maxbytes - ddf.bytes + SUM(dfs.bytes), 'NO', SUM(dfs.bytes)) / 1024 / 1024) AS freeByteSizeMb,
            TRUNC(DECODE(autoextensible,'YES', ddf.maxbytes, 'NO', ddf.bytes) / 1024 / 1024) AS maxByteSizeMb
            FROM dba_data_files ddf, dba_free_space dfs
            WHERE ddf.file_id=dfs.file_id AND ddf.tablespace_name = dfs.tablespace_name AND ddf.relative_fno = dfs.relative_fno
              AND ddf.tablespace_name IN (v_datTablespace, v_lobTablespace, v_idxTablespace)
            GROUP BY ddf.file_id, ddf.file_name, ddf.tablespace_name, ddf.increment_by, ddf.autoextensible, ddf.bytes, ddf.maxbytes
          ) ORDER BY tablespace_name, maxByteSizeMb DESC, filename) LOOP
        DBMS_OUTPUT.put_line(RPAD(x.tablespace_name, 31) || RPAD(x.maxByteSizeMb, 14) || RPAD(x.incrementkb, 12) || RPAD(x.autoextensible, 15) || x.filename);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || RPAD('GRANTEE', 31) || RPAD('PRIVILEGE', 31));
  FOR x IN (SELECT grantee, granted_role AS role_or_privilege FROM dba_role_privs WHERE grantee = UPPER(p_user)
    UNION SELECT grantee, privilege FROM dba_sys_privs WHERE grantee = UPPER(p_user)
    UNION SELECT grantee, privilege || ' ON ' || table_name FROM dba_tab_privs WHERE grantee = UPPER(p_user)) LOOP
      DBMS_OUTPUT.put_line(RPAD(x.grantee, 31) || RPAD(x.role_or_privilege, 31));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(CHR(10) || RPAD('GRANTEE', 31) || RPAD('TABLESPACE', 31) || RPAD('QUOTA', 31));
  FOR x IN (SELECT username, tablespace_name, bytes, max_bytes FROM dba_ts_quotas WHERE UPPER(username) = UPPER(p_user)) LOOP
      DBMS_OUTPUT.put_line(RPAD(x.username, 31) || RPAD(x.tablespace_name, 31) || RPAD(CASE x.max_bytes WHEN -1 THEN 'UNLIMITED' ELSE '' || x.max_bytes END, 31));
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE create_tbs_and_user_xml(p_xml XMLType) AS
BEGIN
  FOR x IN (SELECT t.* FROM XMLTable(XMLNamespaces('http://www.wldelft.nl/fews' AS "fews"), 
        '$d//fews:mc' PASSING p_xml AS "d" COLUMNS 
          mcId VARCHAR2(30) PATH '@id',
          url VARCHAR2(255) PATH 'fews:databaseServer/fews:url',
          schemaOwnerUser VARCHAR2(30) PATH 'fews:databaseServer/fews:user',
          schemaOwnerPassword VARCHAR2(128) PATH 'fews:databaseServer/fews:password',
          fewsAdminUser VARCHAR2(30) PATH 'fews:databaseServer/fews:fewsAdminUser',
          fewsAdminPassword VARCHAR2(128) PATH 'fews:databaseServer/fews:fewsAdminPassword',
          datTablespaceMaxSize VARCHAR2(20) PATH 'fews:datTablespaceMaxSize',
          lobTablespaceMaxSize VARCHAR2(20) PATH 'fews:lobTablespaceMaxSize',
          idxTablespaceMaxSize VARCHAR2(20) PATH 'fews:idxTablespaceMaxSize',
          datTablespaceDir VARCHAR2(255) PATH 'fews:datTablespaceDir',
          lobIdxTablespaceDir VARCHAR2(255) PATH 'fews:lobIdxTablespaceDir'
        ) t) LOOP
    IF (x.url IS NULL OR SUBSTR(x.url, 1, 17) <> 'jdbc:oracle:thin:') THEN
      DBMS_OUTPUT.PUT_LINE('Skipping creation of mc database for ' || x.mcId || ' since url did not start with jdbc:oracle:thin:url, was ' || x.url);
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || LPAD('user: ', 24, ' ') || x.schemaOwnerUser);
    DBMS_OUTPUT.PUT_LINE(LPAD('datTablespaceMaxSize: ', 24, ' ') || x.datTablespaceMaxSize);
    DBMS_OUTPUT.PUT_LINE(LPAD('lobTablespaceMaxSize: ', 24, ' ') || x.lobTablespaceMaxSize);
    DBMS_OUTPUT.PUT_LINE(LPAD('datTablespaceDir: ', 24, ' ') || x.datTablespaceDir);
    DBMS_OUTPUT.PUT_LINE(LPAD('lobIdxTablespaceDir: ', 24, ' ') || x.lobIdxTablespaceDir);

    IF (x.schemaOwnerUser IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20000, 'Missing <user> for connection ' || x.mcId);
    END IF;
    create_tbs_and_user(x.schemaOwnerUser, x.schemaOwnerPassword, x.datTablespaceDir, x.lobIdxTablespaceDir, 
      x.datTablespaceMaxSize, x.lobTablespaceMaxSize, x.idxTablespaceMaxSize);
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Schema creation ' || x.schemaOwnerUser || ' completed successfully');
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE create_tbs_and_user_xmlfile(p_xmlfile varchar2) AS
  v_dir VARCHAR2(512);
  v_filename VARCHAR2(512);
BEGIN
  v_dir := get_dir(p_xmlfile);
  v_filename := get_file(p_xmlfile);
  EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY xml_dir AS ''' || v_dir || '''';
  EXECUTE IMMEDIATE 'GRANT ALL ON DIRECTORY xml_dir TO ' || user;
  create_tbs_and_user_xml(XMLTYPE(bfilename('XML_DIR', v_filename), NLS_CHARSET_ID('AL32UTF8')));
  EXECUTE IMMEDIATE 'DROP DIRECTORY xml_dir';
END;
/

PROMPT Please wait while (re-)creating tablespaces and user...;
DECLARE
  v_schemaOwnerUser VARCHAR2(30);
  v_password VARCHAR2(128);
  v_datStorageDir VARCHAR2(255);
  v_lobIdxStorageDir VARCHAR2(255);
  v_datTablespaceMaxSize VARCHAR2(20);
  v_lobTablespaceMaxSize VARCHAR2(20);
  v_idxTablespaceMaxSize VARCHAR2(20);
BEGIN
  IF UPPER('&1') LIKE '%.XML' THEN
    create_tbs_and_user_xmlfile(p_xmlfile => '&1');
    RETURN;
  END IF;
  v_schemaOwnerUser := '&1';
  v_password := '&2';
  v_datStorageDir := '&3';
  v_lobIdxStorageDir := '&4';
  v_datTablespaceMaxSize := '&5';
  v_lobTablespaceMaxSize := '&6';
  v_idxTablespaceMaxSize := '&7';
  create_tbs_and_user(v_schemaOwnerUser, v_password, v_datStorageDir, v_lobIdxStorageDir, v_datTablespaceMaxSize, v_lobTablespaceMaxSize, v_idxTablespaceMaxSize);
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Schema creation completed successfully ' || v_schemaOwnerUser);
END;
/

SET TERMOUT OFF
DROP PROCEDURE create_tbs_and_user_xmlfile;
DROP PROCEDURE create_tbs_and_user_xml;
DROP PROCEDURE create_tbs_and_user;
DROP PROCEDURE create_or_replace_user;
DROP PROCEDURE execute_with_log;
DROP FUNCTION get_password;
DROP FUNCTION get_file;
DROP FUNCTION get_dir;
