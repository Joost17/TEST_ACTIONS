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
-- Creates tablespaces and users for an open database for Delft FEWS 
--
-- Invocation  : @tbs_user_creation <USERNAME> <PASSWORD>
-- Arguments   :
--      &1 - User/schema name to create
--		&2 - Password for database user.
-- Return      : none
-- Variables   : none
--

set verify off

-- Input parameters:
define strusername = &1
define struserpass = &2

-- Get SID into bind variable then substitution variable and
-- finally define the two data directories for the instance.
define strtmpSID=''
col strtmpSID new_value strSID
variable bndSID varchar2(20)
begin
   select instance_name into :bndSID from v$instance;
end;
/
select :bndSID strtmpSID from dual;
--define stroradat1=/oracle/data/&strSID/dbfiles01
--define stroradat2=/oracle/data/&strSID/dbfiles02
define stroradat1=d:/var/oracle/data/dbfiles01
define stroradat2=d:/var/oracle/data/dbfiles02

drop user &strusername cascade;
drop tablespace &strusername.Dat01;
drop tablespace &strusername.Idx01;

-- Tablespace Creation
-- Approach:
--      A tablespace will be created for the following items:
--           1. Data tables
--           2. Indexes Data tables
--      Datafiles for data and indexes on that data will be stored in different directories.


-- Tablespace for data.
create tablespace &strusername.Dat01
   datafile '&stroradat1/&strusername.Dat01_01.dbf' size 307234K reuse
      autoextend on next 4M maxsize 20971520K
      extent management local uniform size 4M;
      
-- Index tablespace
create tablespace &strusername.Idx01
   datafile '&stroradat2/&strusername.Idx01_01.dbf' size 153664K reuse
      autoextend on next 128K maxsize 5243520K
      extent management local uniform size 128k;
      
-- Create the application user.
create user &strusername identified by &struserpass
   temporary tablespace TEMP
   default tablespace &strusername.Dat01;

-- Some useful grants for this user.
grant connect, resource to &strusername;

-- Ensure that it has sufficient access to the application 
-- tablespaces.
--
-- Please note that granting QUOTA on temporary tablespaces does
-- not work any more on Oracle 10g R2, so no QUOTA UNLIMITED ON TEMP here
-- (the fact that it worked was a bug in Oracle 9 and 10g R1). 
alter user &strusername
   QUOTA UNLIMITED ON &strusername.DAT01
   QUOTA UNLIMITED ON &strusername.IDX01;
   
