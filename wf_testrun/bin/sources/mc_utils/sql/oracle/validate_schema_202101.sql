-- Delft-FEWS
-- ================================================================
--
-- Software Info: http://www.delft-fews.com
-- Contact Info:  Delft-FEWS Product Management (fews-pm@deltares.nl)
--
-- (C) Copyright 2019, by Deltares
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
-- validate_schema_202101.sql
-- ----------------------------------------------------------------
-- (C) Copyright 2019, by Deltares

-- Usage:
-- 1. Navigate to a directory with write permissions.
-- 2. Ensure the environment variable ORACLE_SID points to the correct database instance.
-- 3. Ensure the sqlplus executable can be found in your path.
-- 4. sqlplus <username>/<password>@<server>:<port>/<servicename> @validate_schema_202101.sql
--    NB. Use the credentials of the fews schema owner, never of the sys dba or system user.
-- 5. the query actually lists the differences with a specific database schema version. When the query yields zero results, this means the database schema matches the version completely.

SET SERVEROUTPUT OFF
SET TERMOUT OFF

DEFINE validateVersion=validate_schema_202101

-- generate a filename for the spool output file
DEFINE spool_filename = ''

VARIABLE var_spool_filename VARCHAR2(255);
DECLARE 
BEGIN
  SELECT 'validation_results_' || user || '_&validateVersion..txt' INTO :var_spool_filename FROM DUAL;
END;
/
COLUMN X new_val spool_filename
SELECT :var_spool_filename X from dual;
DEFINE spool_filename

SET SERVEROUTPUT ON

PROMPT Listing all the differences with Delft-FEWS database that has been migrated to 2021.01. Writing validation results to &spool_filename. This may take a several minutes...;

SPOOL '&spool_filename.'

SET LINESIZE 400

COLUMN ELEMENT_TYPE FORMAT A12;
COLUMN ELEMENT_NAME FORMAT A60;
COLUMN EXPECTED FORMAT A65;
COLUMN ACTUAL FORMAT A65;
COLUMN EXPECTED_ELEMENT_INFO FORMAT A80;
COLUMN ACTUAL_ELEMENT_INFO FORMAT A80;

SELECT element_type, element_name, expected, actual, expected_element_info, actual_element_info FROM (
SELECT CASE WHEN t1.element_name IS NULL THEN t2.element_type ELSE t1.element_type END AS element_type, 
  CASE WHEN t1.element_name IS NULL THEN t2.element_name ELSE t1.element_name END AS element_name, t1.element_content AS expected, t2.element_content AS actual,
   t1.element_info AS expected_element_info, t2.element_info as actual_element_info FROM (
  SELECT 'FOREIGN KEY' AS element_type, 'ACCESSKEYHASHES.USERENTRYID#USERS.ENTRYID' AS element_name, '2' AS element_content, 'FK_ACCESSKEYHASHES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'ACCESSKEYHASHES.USERMCID#USERS.MCID' AS element_name, '1' AS element_content, 'FK_ACCESSKEYHASHES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'ARCHIVEMETADATA.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_ARCHIVEMETADATA' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'ATTRIBUTEMODIFIERS.MODIFIERID#MODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'FK_ATTRIBMODIFIERSMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'ATTRIBUTEMODIFIERS.TASKRUNID#MODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_ATTRIBMODIFIERSMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_COMPONENTLOGFILESNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FEWSSESSIONS.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_FEWSSESSIONS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FEWSWEBSERVICES.LOGTASKRUNID#COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID' AS element_name, '1' AS element_content, 'FK_WEBSERVICES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FLOODPERIODS.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_PERIODS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FORECASTINGSHELLS.FSSGROUPENTRYID#FSSGROUPS.ENTRYID' AS element_name, '2' AS element_content, 'FK_FORECASTINGSHELLS2' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FORECASTINGSHELLS.LOGTASKRUNID#COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID' AS element_name, '1' AS element_content, 'FK_FORECASTINGSHELLS3' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FORECASTINGSHELLS.MCENTRYID#MASTERCONTROLLERS.ENTRYID' AS element_name, '2' AS element_content, 'FK_FORECASTINGSHELLS1' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FORECASTINGSHELLS.MCID#FSSGROUPS.MCID' AS element_name, '1' AS element_content, 'FK_FORECASTINGSHELLS2' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'FORECASTINGSHELLS.MCID#MASTERCONTROLLERS.MCID' AS element_name, '1' AS element_content, 'FK_FORECASTINGSHELLS1' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'HISTORICALEVENTS.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_HISTORICALEVENTS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'LOGENTRIES.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_LOGENTRIES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MASTERCONTROLLERS.LOGTASKRUNID#COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID' AS element_name, '1' AS element_content, 'FK_MASTERCONTROLLERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODIFIERS.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_MODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODIFIERS.WHATIFID#WHATIFSCENARIOS.WHATIFID' AS element_name, '1' AS element_content, 'FK_MODWHATIF' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODULEINSTANCERUNS.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_MODULEINSTANCERUNS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODULEPARAMETERMODIFIERS.MODIFIERID#MODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'FK_MODULEPARAMETERMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODULEPARAMETERMODIFIERS.TASKRUNID#MODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_MODULEPARAMETERMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'MODULERUNTABLES.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_MODULERUNTABLES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'REPORTS.MODULEINSTANCEID#MODULEINSTANCERUNS.MODULEINSTANCEID' AS element_name, '2' AS element_content, 'FK_REPORTSRUN' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'REPORTS.TASKRUNID#MODULEINSTANCERUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_REPORTSRUN' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'SAMPLES.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_SAMPLES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_TASKRUNCOMPLETIONS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TASKRUNS.TASKID#TASKS.TASKID' AS element_name, '1' AS element_content, 'FK_TASKRUNSTASK' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TASKRUNS.TASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_TASKRUNS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TASKS.WHATIFID#WHATIFSCENARIOS.WHATIFID' AS element_name, '1' AS element_content, 'FK_TASKSWHATIF' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TIMESERIES.CREATORTASKRUNID#MODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_TIMESERIES_MODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TIMESERIES.CREATORTASKRUNID#SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'FK_TIMESERIES_SYSTEMACTIVITIES' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TIMESERIES.MODIFIERID#MODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'FK_TIMESERIES_MODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'TIMESERIES.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_TIMESERIES_TASKRUNS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'USERSETTINGS.USERENTRYID#USERS.ENTRYID' AS element_name, '2' AS element_content, 'FK_USERSETTINGS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'USERSETTINGS.USERMCID#USERS.MCID' AS element_name, '1' AS element_content, 'FK_USERSETTINGS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'USERTOGROUPSMAPPINGS.USERENTRYID#USERS.ENTRYID' AS element_name, '2' AS element_content, 'FK_USERTOGROUPSMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'USERTOGROUPSMAPPINGS.USERMCID#USERS.MCID' AS element_name, '1' AS element_content, 'FK_USERTOGROUPSMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'FOREIGN KEY' AS element_type, 'WARMSTATES.TASKRUNID#TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'FK_WARMSTATES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACCESSKEYHASHES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ACCESSKEYHASHES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACTIONCONFIGURATIONS.ACTIONID' AS element_name, '2' AS element_content, 'IDX_ACTCONF_MCID_ACT_VER' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACTIONCONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_ACTIONCONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACTIONCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ACTIONCONFIGURATIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACTIONCONFIGURATIONS.MCID' AS element_name, '1' AS element_content, 'IDX_ACTCONF_MCID_ACT_VER' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ACTIONCONFIGURATIONS.VERSION' AS element_name, '3' AS element_content, 'IDX_ACTCONF_MCID_ACT_VER' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'AISERVLETUSERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_AISERVLETUSERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ARCHIVEMETADATA.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_ARCHIVEMETADATA_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ARCHIVEMETADATA.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ARCHIVEMETADATA_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ATTRIBUTEMODIFIERS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_ATTRIBMODS_EXPIRYTIME' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ATTRIBUTEMODIFIERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ATTRIBUTEMODIFIERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ATTRIBUTEMODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'IDX_ATTRMODIID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ATTRIBUTEMODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'IDX_ATTRMODIID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILES.HASH' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILESETS.BUILDNUMBER' AS element_name, '3' AS element_content, 'IDX_BASEBUILDFILESETS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILESETS.BUILDTYPE' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILESETS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILESETS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILESETS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILESETS.IMPLEMENTATIONVERSION' AS element_name, '2' AS element_content, 'IDX_BASEBUILDFILESETS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'BASEBUILDFILESETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILESETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CMCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_CMCONFIGFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COEFFICIENTSETS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_COEFFICIENTSETS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COEFFICIENTSETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_COEFFICIENTSETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COLDSTATES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_COLDSTATES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COLDSTATES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_COLDSTATES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_CMPLOGFILESNAPSHOTS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_CMPLOGFILESNAPSHOTS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CONFIGREVISIONSETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_CONFIGREVISIONSETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CORRELATIONEVENTSETS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_CORRELATIONEVENTSETS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CORRELATIONEVENTSETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_CORRELATIONEVENTSETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CORRELATIONTRAVELTIMES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_CORRELATIONTRAVELTIMES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'CORRELATIONTRAVELTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_CORRELATIONTRAVELTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'DATABASESCHEMAINFO.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_DATABASESCHEMAINFO_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'DELETEDROWS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_DELETEDROWS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'DELETEDROWS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_DELETEDROWS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'DISPLAYCONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_DISPLAYCONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'DISPLAYCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_DISPLAYCONFIGURATIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EVENTACTIONMAPPINGS.ACTIONID' AS element_name, '3' AS element_content, 'IDX_EVEACTMAP_MCID_EV_ACT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EVENTACTIONMAPPINGS.EVENTCODE' AS element_name, '2' AS element_content, 'IDX_EVEACTMAP_MCID_EV_ACT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EVENTACTIONMAPPINGS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_EVENTACTIONMAPPINGS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EVENTACTIONMAPPINGS.MCID' AS element_name, '1' AS element_content, 'IDX_EVEACTMAP_MCID_EV_ACT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EXTERNALFORECASTVISIBILITY.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_EXTFORVIS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'EXTERNALFORECASTVISIBILITY.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_EXTFORVIS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FEWSSESSIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FEWSSESSIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FEWSSESSIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FEWSSESSIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FEWSWEBSERVICES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FEWSWEBSERVICES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FEWSWEBSERVICES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FEWSWEBSERVICES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FLAGCONVERSIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FLAGCONVERSIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FLAGCONVERSIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FLAGCONVERSIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FLOODPERIODS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FLOODPERIOD_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FLOODPERIODS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FLOODPERIODS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FORECASTINGSHELLS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FORECASTINGSHELLS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FORECASTINGSHELLS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FORECASTINGSHELLS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSGROUPS.FSSGROUPID' AS element_name, '2' AS element_content, 'IDX_FSSGROUPS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSGROUPS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FSSGROUPS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSGROUPS.MCID' AS element_name, '1' AS element_content, 'IDX_FSSGROUPS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSRESOURCES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FSSRESOURCES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSRESOURCES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FSSRESOURCES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSSTATUS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_FSSSTATUS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'FSSSTATUS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_FSSSTATUS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'HISTORICALEVENTS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_HISTORICALEVENTS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'HISTORICALEVENTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_HISTORICALEVENTS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ICONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_ICONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ICONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ICONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IDMAPS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_IDMAPS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IDMAPS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_IDMAPS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IMPORTSTATUS.DATAFEEDID' AS element_name, '2' AS element_content, 'IDX_IMPORTSTATUS_MCID_DATAFEED' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IMPORTSTATUS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_IMPORTSTATUS_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IMPORTSTATUS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_IMPORTSTATUS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'IMPORTSTATUS.MCID' AS element_name, '1' AS element_content, 'IDX_IMPORTSTATUS_MCID_DATAFEED' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'INDEXFILESSNAPSHOTS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_INDEXFILESSNAPSHOTS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'INDEXFILESSNAPSHOTS.FORMATVERSION' AS element_name, '2' AS element_content, 'IDX_INDEXFILESSNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'INDEXFILESSNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_INDEXFILESSNAPSHOTS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'INDEXFILESSNAPSHOTS.MCID' AS element_name, '1' AS element_content, 'IDX_INDEXFILESSNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LASTISSUEDTIMESTAMP.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LASTISSUEDTIMESTAMP_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LIVEMCAVAILABILITIES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LIVEMCAVAILABILITIES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LIVEMCAVAILABILITIES.MCID' AS element_name, '1' AS element_content, 'IDX_LIVEMCAVAILABILITIES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALMCID.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LOCALMCID_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALSYNCHTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LOCALSYNCHTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALSYNCHTIMES.MCID' AS element_name, '1' AS element_content, 'IDX_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALSYNCHTIMES.REMOTEMCID' AS element_name, '2' AS element_content, 'IDX_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALSYNCHTIMES.SYNCHLEVEL' AS element_name, '4' AS element_content, 'IDX_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOCALSYNCHTIMES.TABLENAME' AS element_name, '3' AS element_content, 'IDX_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.CREATIONTIME' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_CT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.EVENTCODE' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_EVENTCODE' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.EVENTPROCESSED' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_PROCESSED' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGENTRIES.LOGLEVEL' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_LOGLEVEL' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'LOGEVENTPROCESSORTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_LOGEVENTPROCESSORTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MAPLAYERS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MAPLAYERS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MAPLAYERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MAPLAYERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MASTERCONTROLLERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MASTERCONTROLLERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MCCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MCCONFIGFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MCFAILOVERPRIORITIES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MCFAILOVERPRIORITIES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MCFAILOVERPRIORITIES.MCID' AS element_name, '1' AS element_content, 'IDX_MCFAILOVERPRIORITIES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MCFAILOVERPRIORITIES.PRIORITY' AS element_name, '2' AS element_content, 'IDX_MCFAILOVERPRIORITIES' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MCSYNCHSTATUS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MCSYNCHSTATUS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODIFIERS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODIFIERS_EXPIRYTIME' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODIFIERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODIFIERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODIFIERS.WHATIFID' AS element_name, '1' AS element_content, 'IDX_MODIFIERS_WHATIFID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCECONFIGS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCECONFIGS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCECONFIGS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCECONFIGS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCEDATASETS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCEDATASETS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCEDATASETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCEDATASETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCERUNS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCERUNS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEINSTANCERUNS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCERUNS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEPARAMETERMODIFIERS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODPARMODS_EXPIRYTIME' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEPARAMETERMODIFIERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODUPARAMODI_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEPARAMETERS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODULEPARAMETERS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULEPARAMETERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULEPARAMETERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULERUNTABLES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_MODULERUNTABLES_EXPIRYTIME' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULERUNTABLES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULERUNTABLES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULERUNTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_MODULERUNTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULERUNTIMES.MODULEINSTANCEID' AS element_name, '2' AS element_content, 'IDX_MODULERUNTIMES_WORKFLOWID_' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'MODULERUNTIMES.WORKFLOWID' AS element_name, '1' AS element_content, 'IDX_MODULERUNTIMES_WORKFLOWID_' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PICLIENTCONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_PICLIENTCONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PICLIENTCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_PICLIENTCONFIGURATIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PICLIENTDATASETS.CLIENTID' AS element_name, '2' AS element_content, 'IDX_PICLIENTDATASETS_DATASETID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PICLIENTDATASETS.DATASETID' AS element_name, '1' AS element_content, 'IDX_PICLIENTDATASETS_DATASETID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PICLIENTDATASETS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_PICLIENTDATASETS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PISERVICECONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_PISERVICECONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PISERVICECONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_PISERVCONF_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PROCESSEDDELETEDROWS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_PROCESSEDDELETEDROWS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PROCESSEDDELETEDROWS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_PROCESSEDDELETEDROWS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PRODUCTINFO.ENDFORECASTTIME' AS element_name, '3' AS element_content, 'IDX_PRODUCTINFO_ID_START_END' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PRODUCTINFO.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_PRODUCTINFO_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PRODUCTINFO.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_PRODUCTINFO_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PRODUCTINFO.PRODUCTID' AS element_name, '1' AS element_content, 'IDX_PRODUCTINFO_ID_START_END' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'PRODUCTINFO.STARTFORECASTTIME' AS element_name, '2' AS element_content, 'IDX_PRODUCTINFO_ID_START_END' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REGIONCONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_REGIONCONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REGIONCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_REGIONCONFIGURATIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTIMAGES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_REPORTIMAGES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTIMAGES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_REPORTIMAGES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_REPORTS_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_REPORTS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTTEMPLATES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_REPORTTEMPLATES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'REPORTTEMPLATES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_REPORTTEMPLATES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ROLLINGBARRELTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ROLLINGBARRELTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ROOTCONFIGFILES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_ROOTCONFIGFILES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'ROOTCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_ROOTCONFIGFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SAMPLES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_SAMPLES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SAMPLES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_SAMPLES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SYSTEMACTIVITIES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_SYSTEMACTIVITIES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SYSTEMACTIVITIES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_SYSTEMACTIVITIES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SYSTEMCONFIGURATIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_SYSTEMCONFIGURATIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'SYSTEMCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_SYSTEMCONFIGURATIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TABLELOCALMODIFICATIONTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TABLLOCAMODITIME_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNCOMPLETIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNCOMPLETIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNCOMPLETIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNCOMPLETIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNDISPATCHERTIMES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNDISPATCHERTIMES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNLOGFILES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNLOGFILES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNLOGFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNLOGFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNS_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TASKRUNS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNS.TASKID' AS element_name, '1' AS element_content, 'IDX_TASKRUNS_TASKID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKRUNS.TASKRUNSTATUS' AS element_name, '1' AS element_content, 'IDX_TASKRUNS_STATUS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_TASKS_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TASKS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKS.TASKSTATUS' AS element_name, '1' AS element_content, 'IDX_TASKS_TASKSTATUS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TASKS.WHATIFID' AS element_name, '1' AS element_content, 'IDX_TASKS_WHATIFID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'THRESHOLDEVENTS.CREATIONTIME' AS element_name, '1' AS element_content, 'IDX_THRESHOLDEVENTS_CT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'THRESHOLDEVENTS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_THRESHOLDEV_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'THRESHOLDEVENTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_THRESHOLDEVENTS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'THRESHOLDEVENTS.MODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_THRESHOLDEVENTS_MT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TIMESERIES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_TIMESERIES_EXPIRYTIME' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TIMESERIES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TIMESERIES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TIMESERIES.TASKRUNID' AS element_name, '1' AS element_content, 'IDX_TIMESERIES_TASKRUNID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_TIMESERISTATSNAP_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.MCID' AS element_name, '1' AS element_content, 'IDX_TIMESERISTATSNAP_MCID' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'UNITCONVERSIONS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_UNITCONVERSIONS_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'UNITCONVERSIONS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_UNITCONVERSIONS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'USERS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_USERS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'USERS.USERNAME' AS element_name, '1' AS element_content, 'IDX_USERS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'USERSETTINGS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_USERSETTINGS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'USERTOGROUPSMAPPINGS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_USERTOGROUPSMAPPINGS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'VERSIONMANAGEMENT.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_VERSIONMANAGEMENT_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'VERSIONRUNNING.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_VERSIONRUNNING_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WARMSTATES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_WARMSTATES_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WARMSTATES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_WARMSTATES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WHATIFSCENARIOS.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_WHATIFSCENARIOS_EXPIRY' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WHATIFSCENARIOS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_WHATIFSCENARIOS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWFILES.EXPIRYTIME' AS element_name, '1' AS element_content, 'IDX_WORKFLOWFILES_ET' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWFILES.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_WORKFLOWFILES_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWTARGETFSSS.FSSGROUPID' AS element_name, '3' AS element_content, 'IDX_WORKFLOWTARGETFSSS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWTARGETFSSS.LOCALMODIFICATIONTIME' AS element_name, '1' AS element_content, 'IDX_WORKFLOWTARGETFSSS_LMT' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWTARGETFSSS.MCID' AS element_name, '1' AS element_content, 'IDX_WORKFLOWTARGETFSSS' AS element_info FROM DUAL UNION
  SELECT 'INDEX' AS element_type, 'WORKFLOWTARGETFSSS.WORKFLOWID' AS element_name, '2' AS element_content, 'IDX_WORKFLOWTARGETFSSS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ACCESSKEYHASHES.ENTRYID' AS element_name, '2' AS element_content, 'PK_ACCESSKEYHASHES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ACCESSKEYHASHES.MCID' AS element_name, '1' AS element_content, 'PK_ACCESSKEYHASHES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ACTIONCONFIGURATIONS.ENTRYID' AS element_name, '2' AS element_content, 'PK_ACTIONCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ACTIONCONFIGURATIONS.MCID' AS element_name, '1' AS element_content, 'PK_ACTIONCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'AISERVLETUSERS.USERNAME' AS element_name, '1' AS element_content, 'PK_AISERVLETUSERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ARCHIVEMETADATA.TASKRUNID' AS element_name, '1' AS element_content, 'PK_ARCHIVEMETADATA' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTEMODIFIERID' AS element_name, '2' AS element_content, 'PK_ATTRIBUTEMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ATTRIBUTEMODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_ATTRIBUTEMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'BASEBUILDFILES.ENTRYID' AS element_name, '2' AS element_content, 'PK_BASEBUILDFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'BASEBUILDFILES.MCID' AS element_name, '1' AS element_content, 'PK_BASEBUILDFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'BASEBUILDFILESETS.ENTRYID' AS element_name, '2' AS element_content, 'PK_BASEBUILDFILESETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'BASEBUILDFILESETS.MCID' AS element_name, '1' AS element_content, 'PK_BASEBUILDFILESETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CMCONFIGFILES.ENTRYID' AS element_name, '2' AS element_content, 'PK_CMCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CMCONFIGFILES.MCID' AS element_name, '1' AS element_content, 'PK_CMCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'COEFFICIENTSETS.COEFFICIENTSETSID' AS element_name, '1' AS element_content, 'PK_COEFFICIENTSETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'COEFFICIENTSETS.VERSION' AS element_name, '2' AS element_content, 'PK_COEFFICIENTSETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'COLDSTATES.COLDSTATEID' AS element_name, '1' AS element_content, 'PK_COLDSTATES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'COLDSTATES.VERSION' AS element_name, '2' AS element_content, 'PK_COLDSTATES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID' AS element_name, '1' AS element_content, 'PK_COMPONENTLOGFILESNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CONFIGREVISIONSETS.REVISIONID' AS element_name, '1' AS element_content, 'PK_CONFIGREVISIONSETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CORRELATIONEVENTSETS.EVENTSETSID' AS element_name, '1' AS element_content, 'PK_CORREVSET' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CORRELATIONEVENTSETS.VERSION' AS element_name, '2' AS element_content, 'PK_CORREVSET' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CORRELATIONTRAVELTIMES.TRAVELTIMESID' AS element_name, '1' AS element_content, 'PK_CORRTRTIME' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'CORRELATIONTRAVELTIMES.VERSION' AS element_name, '2' AS element_content, 'PK_CORRTRTIME' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'DATABASESCHEMAINFO.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_DATABASESCHEMAINFO' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'DELETEDROWS.GLOBALROWID' AS element_name, '1' AS element_content, 'PK_DELETEDROWS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'DISPLAYCONFIGURATIONS.CONFIGTYPEID' AS element_name, '1' AS element_content, 'PK_DISPLAYCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'DISPLAYCONFIGURATIONS.VERSION' AS element_name, '2' AS element_content, 'PK_DISPLAYCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'EVENTACTIONMAPPINGS.ENTRYID' AS element_name, '2' AS element_content, 'PK_EVENTACTIONMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'EVENTACTIONMAPPINGS.MCID' AS element_name, '1' AS element_content, 'PK_EVENTACTIONMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'EXTERNALFORECASTVISIBILITY.ENTRYID' AS element_name, '2' AS element_content, 'PK_EXTERNALFORECASTVISIBILITY' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'EXTERNALFORECASTVISIBILITY.MCID' AS element_name, '1' AS element_content, 'PK_EXTERNALFORECASTVISIBILITY' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FEWSSESSIONS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_FEWSSESSIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FEWSWEBSERVICES.MCID' AS element_name, '1' AS element_content, 'PK_WEBSERVICES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FEWSWEBSERVICES.WEBSERVICEID' AS element_name, '2' AS element_content, 'PK_WEBSERVICES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FLAGCONVERSIONS.FLAGCONVERSIONID' AS element_name, '1' AS element_content, 'PK_FLAGCONVERSIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FLAGCONVERSIONS.VERSION' AS element_name, '2' AS element_content, 'PK_FLAGCONVERSIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FLOODPERIODS.PERIODID' AS element_name, '2' AS element_content, 'PK_FLOODPERIODS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FLOODPERIODS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_FLOODPERIODS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FORECASTINGSHELLS.FSSID' AS element_name, '2' AS element_content, 'PK_FORECASTINGSHELLS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FORECASTINGSHELLS.MCID' AS element_name, '1' AS element_content, 'PK_FORECASTINGSHELLS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FSSGROUPS.ENTRYID' AS element_name, '2' AS element_content, 'PK_FSSGROUPS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FSSGROUPS.MCID' AS element_name, '1' AS element_content, 'PK_FSSGROUPS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FSSRESOURCES.FSSROWID' AS element_name, '1' AS element_content, 'PK_FSSRESOURCE' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'FSSSTATUS.FSSROWID' AS element_name, '1' AS element_content, 'PK_FSSSTATUS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'HISTORICALEVENTS.EVENTID' AS element_name, '2' AS element_content, 'PK_HISTORICALEVENTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'HISTORICALEVENTS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_HISTORICALEVENTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ICONS.ICONID' AS element_name, '1' AS element_content, 'PK_ICONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ICONS.VERSION' AS element_name, '2' AS element_content, 'PK_ICONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'IDMAPS.IDMAPID' AS element_name, '1' AS element_content, 'PK_IDMAPS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'IDMAPS.VERSION' AS element_name, '2' AS element_content, 'PK_IDMAPS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'IMPORTSTATUS.ENTRYID' AS element_name, '2' AS element_content, 'PK_IMPORTSTATUS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'IMPORTSTATUS.MCID' AS element_name, '1' AS element_content, 'PK_IMPORTSTATUS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'INDEXFILESSNAPSHOTS.ENTRYID' AS element_name, '2' AS element_content, 'PK_INDEXFILESSNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'INDEXFILESSNAPSHOTS.MCID' AS element_name, '1' AS element_content, 'PK_INDEXFILESSNAPSHOTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LASTISSUEDTIMESTAMP.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_LASTISSUEDTIMESTAMP' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LIVEMCAVAILABILITIES.ENTRYID' AS element_name, '2' AS element_content, 'PK_LIVEMCAVAILABILITIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LIVEMCAVAILABILITIES.MCID' AS element_name, '1' AS element_content, 'PK_LIVEMCAVAILABILITIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOCALMCID.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_LOCALMCID' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOCALSYNCHTIMES.ENTRYID' AS element_name, '2' AS element_content, 'PK_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOCALSYNCHTIMES.MCID' AS element_name, '1' AS element_content, 'PK_LOCALSYNCHTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOGENTRIES.LOGENTRYID' AS element_name, '2' AS element_content, 'PK_LOGENTRIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOGENTRIES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_LOGENTRIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'LOGEVENTPROCESSORTIMES.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_LOGEVENTPROCESSORTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MAPLAYERS.MAPLAYERID' AS element_name, '1' AS element_content, 'PK_MAPLAYERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MAPLAYERS.VERSION' AS element_name, '2' AS element_content, 'PK_MAPLAYERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MASTERCONTROLLERS.ENTRYID' AS element_name, '2' AS element_content, 'PK_MASTERCONTROLLERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MASTERCONTROLLERS.MCID' AS element_name, '1' AS element_content, 'PK_MASTERCONTROLLERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCCONFIGFILES.ENTRYID' AS element_name, '2' AS element_content, 'PK_MCCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCCONFIGFILES.MCID' AS element_name, '1' AS element_content, 'PK_MCCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCFAILOVERPRIORITIES.ENTRYID' AS element_name, '2' AS element_content, 'PK_MCFAILOVERPRIORITIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCFAILOVERPRIORITIES.MCID' AS element_name, '1' AS element_content, 'PK_MCFAILOVERPRIORITIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCSYNCHSTATUS.ENTRYID' AS element_name, '2' AS element_content, 'PK_MCSYNCHSTATUS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MCSYNCHSTATUS.MCID' AS element_name, '1' AS element_content, 'PK_MCSYNCHSTATUS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'PK_MODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_MODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCECONFIGS.MODULEINSTANCEID' AS element_name, '1' AS element_content, 'PK_MODULEINSTANCECONFIGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCECONFIGS.VERSION' AS element_name, '2' AS element_content, 'PK_MODULEINSTANCECONFIGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCEDATASETS.MODULEINSTANCEID' AS element_name, '1' AS element_content, 'PK_MODULEINSTANCEDATASETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCEDATASETS.VERSION' AS element_name, '2' AS element_content, 'PK_MODULEINSTANCEDATASETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCERUNS.MODULEINSTANCEID' AS element_name, '2' AS element_content, 'PK_MODULEINSTANCERUNS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEINSTANCERUNS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_MODULEINSTANCERUNS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEPARAMETERMODIFIERS.MODIFIERID' AS element_name, '2' AS element_content, 'PK_MODULEPARAMETERMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEPARAMETERMODIFIERS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_MODULEPARAMETERMODIFIERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEPARAMETERS.MODULEPARAMETERID' AS element_name, '1' AS element_content, 'PK_MODPARAMS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULEPARAMETERS.VERSION' AS element_name, '2' AS element_content, 'PK_MODPARAMS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULERUNTABLES.FILEID' AS element_name, '2' AS element_content, 'PK_MODULERUNTABLES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULERUNTABLES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_MODULERUNTABLES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULERUNTIMES.ENTRYID' AS element_name, '2' AS element_content, 'PK_MODULERUNTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'MODULERUNTIMES.MCID' AS element_name, '1' AS element_content, 'PK_MODULERUNTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PICLIENTCONFIGURATIONS.CLIENTID' AS element_name, '1' AS element_content, 'PK_PICLIENTCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PICLIENTCONFIGURATIONS.VERSION' AS element_name, '2' AS element_content, 'PK_PICLIENTCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PICLIENTDATASETS.ENTRYID' AS element_name, '2' AS element_content, 'PK_PICLIENTDATASETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PICLIENTDATASETS.MCID' AS element_name, '1' AS element_content, 'PK_PICLIENTDATASETS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PISERVICECONFIGURATIONS.CLIENTID' AS element_name, '1' AS element_content, 'PK_PISERVICECONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PISERVICECONFIGURATIONS.VERSION' AS element_name, '2' AS element_content, 'PK_PISERVICECONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PROCESSEDDELETEDROWS.PROCESSEDGLOBALROWID' AS element_name, '1' AS element_content, 'PK_PROCESSEDDELETEDROWS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PRODUCTINFO.ENTRYID' AS element_name, '2' AS element_content, 'PK_PRODUCTINFO' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'PRODUCTINFO.MCID' AS element_name, '1' AS element_content, 'PK_PRODUCTINFO' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REGIONCONFIGURATIONS.CONFIGTYPEID' AS element_name, '1' AS element_content, 'PK_REGIONCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REGIONCONFIGURATIONS.VERSION' AS element_name, '2' AS element_content, 'PK_REGIONCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTIMAGES.REPORTIMAGEID' AS element_name, '1' AS element_content, 'PK_REPORTIMAGES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTIMAGES.VERSION' AS element_name, '2' AS element_content, 'PK_REPORTIMAGES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTS.MODULEINSTANCEID' AS element_name, '3' AS element_content, 'PK_REPORTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTS.REPORTID' AS element_name, '1' AS element_content, 'PK_REPORTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTS.TASKRUNID' AS element_name, '2' AS element_content, 'PK_REPORTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTTEMPLATES.CONFIGTYPEID' AS element_name, '1' AS element_content, 'PK_REPTEMP' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'REPORTTEMPLATES.VERSION' AS element_name, '2' AS element_content, 'PK_REPTEMP' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ROLLINGBARRELTIMES.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_ROLLINGBARRELTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ROOTCONFIGFILES.ROOTCONFIGFILEID' AS element_name, '1' AS element_content, 'PK_ROOTCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'ROOTCONFIGFILES.VERSION' AS element_name, '2' AS element_content, 'PK_ROOTCONFIGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'SAMPLES.SAMPLEID' AS element_name, '2' AS element_content, 'PK_SAMPLES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'SAMPLES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_SAMPLES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'SYSTEMACTIVITIES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_SYSTEMACTIVITIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'SYSTEMCONFIGURATIONS.CONFIGTYPEID' AS element_name, '1' AS element_content, 'PK_SYSTEMCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'SYSTEMCONFIGURATIONS.VERSION' AS element_name, '2' AS element_content, 'PK_SYSTEMCONFIGURATIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TABLELOCALMODIFICATIONTIMES.TABLENAME' AS element_name, '1' AS element_content, 'PK_TABLELOCALMODIFICATIONTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_TASKRUNCOMPLETIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TASKRUNDISPATCHERTIMES.SINGLEROWKEY' AS element_name, '1' AS element_content, 'PK_TASKRUNDISPATCHERTIMES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TASKRUNLOGFILES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_TASKRUNLOGFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TASKRUNS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_TASKRUNS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TASKS.TASKID' AS element_name, '1' AS element_content, 'PK_TASKS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'THRESHOLDEVENTS.EVENTENTRYID' AS element_name, '2' AS element_content, 'PK_THRESHOLDEVENTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'THRESHOLDEVENTS.TASKRUNID' AS element_name, '1' AS element_content, 'PK_THRESHOLDEVENTS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TIMESERIES.BLOBID' AS element_name, '2' AS element_content, 'PK_TIMESERIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TIMESERIES.CREATORTASKRUNID' AS element_name, '1' AS element_content, 'PK_TIMESERIES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.ENTRYID' AS element_name, '2' AS element_content, 'PK_TIMESERIESSTATUSSNAPSHOT' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.MCID' AS element_name, '1' AS element_content, 'PK_TIMESERIESSTATUSSNAPSHOT' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'UNITCONVERSIONS.UNITCONVERSIONID' AS element_name, '1' AS element_content, 'PK_UNITCONVERSIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'UNITCONVERSIONS.VERSION' AS element_name, '2' AS element_content, 'PK_UNITCONVERSIONS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERS.ENTRYID' AS element_name, '2' AS element_content, 'PK_USERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERS.MCID' AS element_name, '1' AS element_content, 'PK_USERS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERSETTINGS.ENTRYID' AS element_name, '2' AS element_content, 'PK_USERSETTINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERSETTINGS.MCID' AS element_name, '1' AS element_content, 'PK_USERSETTINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERTOGROUPSMAPPINGS.ENTRYID' AS element_name, '2' AS element_content, 'PK_USERTOGROUPSMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'USERTOGROUPSMAPPINGS.MCID' AS element_name, '1' AS element_content, 'PK_USERTOGROUPSMAPPINGS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'VERSIONMANAGEMENT.COMPONENTID' AS element_name, '2' AS element_content, 'PK_VERSIONMANAGEMENT' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'VERSIONMANAGEMENT.ENTRYID' AS element_name, '3' AS element_content, 'PK_VERSIONMANAGEMENT' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'VERSIONMANAGEMENT.VERSIONID' AS element_name, '1' AS element_content, 'PK_VERSIONMANAGEMENT' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'VERSIONRUNNING.COMPONENTID' AS element_name, '2' AS element_content, 'PK_VERSIONRUNNING' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'VERSIONRUNNING.VERSIONID' AS element_name, '1' AS element_content, 'PK_VERSIONRUNNING' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WARMSTATES.STATEID' AS element_name, '2' AS element_content, 'PK_WARMSTATES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WARMSTATES.TASKRUNID' AS element_name, '1' AS element_content, 'PK_WARMSTATES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WHATIFSCENARIOS.WHATIFID' AS element_name, '1' AS element_content, 'PK_WHATIFSCENAIOS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WORKFLOWFILES.VERSION' AS element_name, '2' AS element_content, 'PK_WORKFLOWFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WORKFLOWFILES.WORKFLOWID' AS element_name, '1' AS element_content, 'PK_WORKFLOWFILES' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WORKFLOWTARGETFSSS.ENTRYID' AS element_name, '2' AS element_content, 'PK_WORKFLOWTARGETFSSS' AS element_info FROM DUAL UNION
  SELECT 'PRIMARY KEY' AS element_type, 'WORKFLOWTARGETFSSS.MCID' AS element_name, '1' AS element_content, 'PK_WORKFLOWTARGETFSSS' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'CONFIGREVISIONSETSIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'ENTRYIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'FEWSWEBSERVICESIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'FORECASTINGSHELLIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'GLOBALROWIDSEQUENCE' AS element_name, 'INCREMENT_BY=100' AS element_content, 'MIN_VALUE=0, MAX_VALUE=9223372036854775807, CACHE_SIZE=10, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'TASKIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'SEQUENCE' AS element_type, 'TASKRUNIDSEQUENCE' AS element_name, 'INCREMENT_BY=1' AS element_content, 'MIN_VALUE=1, MAX_VALUE=9223372036854775807, CACHE_SIZE=20, LAST_VALUE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.ACCESSKEYHASH' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.USERENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACCESSKEYHASHES.USERMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.ACTIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ACTIONCONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.FULLNAME' AS element_name, 'VARCHAR(32) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.PASSWORD' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'AISERVLETUSERS.USERNAME' AS element_name, 'VARCHAR(16) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ARCHIVEMETADATA.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTEBOOLEAN' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTEMODIFIERID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTENUMBER' AS element_name, 'FLOAT(126)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTETEXT' AS element_name, 'VARCHAR(2000)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.ATTRIBUTETIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.LOCATIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.MODIFIERID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ATTRIBUTEMODIFIERS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.COMPRESSEDFILE' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.HASH' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.BUILDNUMBER' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.BUILDTYPE' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.COMMENTTEXT' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.COMPRESSEDXML' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.IMPLEMENTATIONVERSION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'BASEBUILDFILESETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.BUILDNUMBER' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.BUILDTYPE' AS element_name, 'VARCHAR(255) NOT NULL DEFAULT ''none''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.COMMENTTEXT' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.COMPRESSEDXML' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL DEFAULT ''none''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.IMPLEMENTATIONVERSION' AS element_name, 'VARCHAR(255) NOT NULL DEFAULT ''none''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CMCONFIGFILES.PATCHFILEBLOB' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.COEFFICIENTSETSID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COEFFICIENTSETS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.COLDSTATEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COLDSTATES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.LOGTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.SNAPSHOTCOMPLETEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.SNAPSHOTREQUESTEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.SNAPSHOTZIP' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.COMMENTTEXT' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.DATASET' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.ENCODEDPARTITIONSEQUENCESXML' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.MCUPDATEREQUESTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.NUMBEROFCHANGES' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CONFIGREVISIONSETS.REVISIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.EVENTSETSID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONEVENTSETS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.TRAVELTIMESID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'CORRELATIONTRAVELTIMES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.GLOBALROWIDREGENERATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.MAINTENANCERUNNING' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.SCHEMAMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DATABASESCHEMAINFO.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.COMPONENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.DELETEDGLOBALROWIDS' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DELETEDROWS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.CONFIGTYPEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'DISPLAYCONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.ACTIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.EVENTCODE' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EVENTACTIONMAPPINGS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.EXTERNALFORECASTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.PRODUCTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'EXTERNALFORECASTVISIBILITY.VISIBLE' AS element_name, 'BIT' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.CLIENTSYSTEMINFO' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.DESCRIPTION' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.LASTREQUESTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.LOGINTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.OCADDRESS' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.PID' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.SESSIONMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.SESSIONTYPE' AS element_name, 'TINYINT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSSESSIONS.USERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.CPU' AS element_name, 'FLOAT(126) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.DISKSPACEMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.HOSTNAME' AS element_name, 'VARCHAR(128) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.LOGTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.MEMORYMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FEWSWEBSERVICES.WEBSERVICEID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.FLAGCONVERSIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLAGCONVERSIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.AREAID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.BEGINTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.DESCRIPTION' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.ENDTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.EVENTLOCATIONID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.EVENTPARAMETERID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.EVENTTHRESHOLDID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.EVENTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.PERIODID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.PERIODSTATUS' AS element_name, 'TINYINT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.PERSISTENTBEGINTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FLOODPERIODS.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.AWAKENEDBYINDEXATHOST' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.CPU' AS element_name, 'FLOAT(126) NOT NULL DEFAULT ''0''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.DISKSPACEMB' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.FSSGROUPENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.FSSID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.HOSTNAME' AS element_name, 'VARCHAR(128) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.HOSTSLOTCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.INDEXATHOST' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.LOGTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.MCENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.MEMORYMB' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FORECASTINGSHELLS.REGIONHOME' AS element_name, 'VARCHAR(1000) NOT NULL DEFAULT ''/opt/fews/fss/1''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.ALLOWUNMAPPED' AS element_name, 'BIT NOT NULL DEFAULT ''1''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.DESCRIPTION' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.FSSGROUPID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.FSSGROUPSTATUS' AS element_name, 'VARCHAR(1) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.GOTOSLEEPSECONDS' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.MAXAWAKECOUNT' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.PRIORITY' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.READYCOUNT' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''1''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSGROUPS.RELEASESLOTSSECONDS' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.CLAIMEDSLOTS' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.CPU' AS element_name, 'FLOAT(126) NOT NULL DEFAULT ''0''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.CPUUSAGE' AS element_name, 'FLOAT(126) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.DBCONNECTIONCOUNT' AS element_name, 'FLOAT(126) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.DISKSPACEMB' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.DISKSPACEUSAGEMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.FREESLOTS' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.FSSROWID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.JAVAHEAPSPACEUSAGEMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.MEMORYMB' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.MEMORYUSAGEMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSRESOURCES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.FSSROWID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.FSSSTATUS' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.LASTFSSSTATUSTRANSITIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.PROGRESSPERCENTAGE' AS element_name, 'TINYINT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'FSSSTATUS.WORKFLOWNODEINDEX' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.BEGINTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.ENDTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.EVENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.EVENTXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'HISTORICALEVENTS.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.ICONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ICONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.IDMAPID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IDMAPS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.DATAFEEDID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.DIRECTORY' AS element_name, 'VARCHAR(128) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.FILESFAILEDCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.FILESREADCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.IMPORTSTATE' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.LASTFILEIMPORTED' AS element_name, 'VARCHAR(128) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.LASTIMPORTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.LOG' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'IMPORTSTATUS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.FORMATVERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.FULLREBUILDREQUESTED' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.GLOBALROWIDREGENERATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.SNAPSHOTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.UPDATEINPROGRESSHEARTBEAT' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'INDEXFILESSNAPSHOTS.ZIPBLOB' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.DATETIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LASTISSUEDTIMESTAMP.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.ISFAILOVER' AS element_name, 'TINYINT' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LIVEMCAVAILABILITIES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALMCID.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.LASTFAILEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.LASTSUCCESSFULSYNCHSTARTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.MAXAGEMILLIS' AS element_name, 'NUMERIC(19)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.REMOTEMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TABLENAME' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHDOWNDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHINSERTEDBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHINSERTEDFAILEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHINSERTEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHNETWORKBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHUPDATEDBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHUPDATEDFAILEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.THISMONTHUPDATEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALDOWNDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALINSERTEDBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALINSERTEDFAILEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALINSERTEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALNETWORKBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALUPDATEDBYTES' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALUPDATEDFAILEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOCALSYNCHTIMES.TOTALUPDATEDROWS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.BUILDNUMBER' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.EVENTACKNOWLEDGED' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.EVENTCODE' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.EVENTPROCESSED' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.LOGENTRYID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.LOGLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.LOGMESSAGE' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGENTRIES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.LASTSTARTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'LOGEVENTPROCESSORTIMES.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.MAPLAYERID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MAPLAYERS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.CPU' AS element_name, 'FLOAT(126) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.DATABASEINTID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.DISKSPACEMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.HOSTNAME' AS element_name, 'VARCHAR(128) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.LOGTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.MCSTATUS' AS element_name, 'NUMERIC(10) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.MEMORYMB' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MASTERCONTROLLERS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.COMPRESSEDXML' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCCONFIGFILES.PATCHFILEBLOB' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.ACTIVE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.PRIORITY' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCFAILOVERPRIORITIES.VISIBLE' AS element_name, 'BIT NOT NULL DEFAULT ''0''' AS element_content, 'default_constraint_name=DEF_MCFAILPRIOVISI, DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.ENABLED' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MCSYNCHSTATUS.REMOTEMCID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.CREATORUSERID' AS element_name, 'VARCHAR(30)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.ENABLED' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.ENABLEDINENSEMBLERUN' AS element_name, 'BIT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.ENABLEDPERIODENDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.ENABLEDPERIODSTARTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.MODIFIERID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.MODTYPE' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.PREVIOUSMODIFIERID' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.PREVIOUSTASKRUNID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.PRIORITY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.USERCREATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.USERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.USERMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.VALIDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODIFIERS.WHATIFID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCECONFIGS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCEDATASETS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.PREVIOUSTASKRUNID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.RUNSTATUS' AS element_name, 'TINYINT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEINSTANCERUNS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.MODIFIERID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERMODIFIERS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.MODULEPARAMETERID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULEPARAMETERS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.FILEBLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.FILEID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTABLES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.MAXPARTITION' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.MINPARTITION' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.PENDINGDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.RUNDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'MODULERUNTIMES.WORKFLOWID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.CLIENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTCONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.CLIENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.DATASET' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.DATASETID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.NODEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PICLIENTDATASETS.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.CLIENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PISERVICECONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.DELETEDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.DURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.FAILEDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.FIRSTFAILEDTABLE' AS element_name, 'VARCHAR(30)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PROCESSEDDELETEDROWS.PROCESSEDGLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.ENDFORECASTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.PRODUCTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.PRODUCTINFOXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'PRODUCTINFO.STARTFORECASTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.CONFIGTYPEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REGIONCONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.REPORTIMAGEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTIMAGES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.REPORTID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.SUBDIRNAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.SUBJECTTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.CONFIGTYPEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'REPORTTEMPLATES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.LASTFAILEDTABLE' AS element_name, 'VARCHAR(30)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.LASTFAILEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.LASTSTARTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHDOWNDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHEXPIREDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHEXTENDEDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHFAILEDCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHFAILEDRUNCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.THISMONTHSTARTEDCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALDOWNDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALEXPIREDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALEXTENDEDROWCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALFAILEDCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALSTARTEDCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROLLINGBARRELTIMES.TOTALSUCCESSCOUNT' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.ROOTCONFIGFILEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'ROOTCONFIGFILES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.DATETIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.EXTERNALSAMPLEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.LOCATIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.SAMPLEID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.SAMPLEPROPERTIES' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SAMPLES.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMACTIVITIES.TASKRUNTYPE' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.CONFIGTYPEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'SYSTEMCONFIGURATIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TABLELOCALMODIFICATIONTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TABLELOCALMODIFICATIONTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TABLELOCALMODIFICATIONTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TABLELOCALMODIFICATIONTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TABLELOCALMODIFICATIONTIMES.TABLENAME' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.APPROVEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNCOMPLETIONSTATUS' AS element_name, 'VARCHAR(1) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNCOMPLETIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNCOMPLETIONS.TASKRUNPROPERTIES' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.LASTHEARTBEATTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.LASTSTARTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNDISPATCHERTIMES.SINGLEROWKEY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.COMPRESSEDLOGFILE' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNLOGFILES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.SCHEDULEDDISPATCHTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKDISPATCHFSSID' AS element_name, 'VARCHAR(30)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKDISPATCHMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKDISPATCHTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKRUNCOMPLETIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TASKRUNSTATUS' AS element_name, 'VARCHAR(1) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TERMINATEREQUESTED' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKRUNS.TIMEZERO' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.CANCELPENDINGONDISPATCH' AS element_name, 'BIT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.CANRUNONFAILOVER' AS element_name, 'TINYINT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.CREATIONTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.DESCRIPTION' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.ENCODEDTASKREPEATTIME' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.LASTCOMPLETEDDURATIONMILLIS' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.LASTCOMPLETEDTASKRUNID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.OWNERMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKFIRSTDUETIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKPENDINGSINCETIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKPRIORITY' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKPROPERTIES' AS element_name, 'CLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKREPEATTIME' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKREPEATUNTILTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKSTATUS' AS element_name, 'VARCHAR(1) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.TASKTAG' AS element_name, 'VARCHAR(146)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.WAITWHENALREADYRUNNING' AS element_name, 'BIT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.WHATIFID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TASKS.WORKFLOWID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.ACKNOWLEDGEDBY' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.ACKNOWLEDGEDTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EVENTACTIONID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EVENTENTRYID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EVENTISSUED' AS element_name, 'BIT' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EVENTTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EVENTVALUE' AS element_name, 'FLOAT(126) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.EXPORTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.LOCATIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.PARAMETERID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.RATEOFCHANGE' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.TARGETLOCATIONID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.TASKRUNIDTIMEZERO' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.THRESHOLDID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.THRESHOLDINTID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.THRESHOLDVALUESETID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.TIMESERIESTYPE' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'THRESHOLDEVENTS.UNITFROMTIMESTEP' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.A' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.AGGREGATIONPERIOD' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.AZGZIPCOMPRESSIONRATIO' AS element_name, 'SMALLINT NOT NULL DEFAULT ''0''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.B' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.BEGINTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.BLOBGZIPCOMPRESSIONRATIO' AS element_name, 'SMALLINT NOT NULL DEFAULT ''0''' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.BLOBID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.C' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.CONSTANTFLAG' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.CREATORTASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.D' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.E' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.ENDTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.ENSEMBLEMEMBERID' AS element_name, 'VARCHAR(2000)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.EXTERNALFORECASTINGSTARTTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.F' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.G' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.H' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.I' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.J' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.K' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.L' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.LOCATIONID' AS element_name, 'VARCHAR(2000) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.M' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.MAXVALUE' AS element_name, 'FLOAT(126)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.MODIFIERID' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.N' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.O' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.P' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.PARAMETERID' AS element_name, 'VARCHAR(2000)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.Q' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.QUALIFIERSETID' AS element_name, 'VARCHAR(2000)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.R' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.REPEATCYCLEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.S' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.SAMPLEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.T' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.TASKRUNID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.TIMESERIESTYPE' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.TIMESTEPID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.U' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.V' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.VALUETYPE' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.W' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.X' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.Y' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIES.Z' AS element_name, 'BLOB' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.TIMEZERO' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.UNITCONVERSIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'UNITCONVERSIONS.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.EMAILADDRESS' AS element_name, 'VARCHAR(512)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.USERDISPLAYNAME' AS element_name, 'VARCHAR(128)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERS.USERNAME' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.COMPRESSEDUSERSETTINGSFILE' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.USERENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERSETTINGS.USERMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.USERENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.USERGROUP' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'USERTOGROUPSMAPPINGS.USERMCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.COMPONENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.ENTRYID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONMANAGEMENT.VERSIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.COMPONENTID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'VERSIONRUNNING.VERSIONID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.BLOB' AS element_name, 'BLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.DESCRIPTION' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.NAME' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.STATEID' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.STATETIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.TASKRUNID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WARMSTATES.WARMSTATETYPE' AS element_name, 'TINYINT NOT NULL DEFAULT ''0''' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=3, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.CREATIONTASKRUNID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.DESCRIPTION' AS element_name, 'VARCHAR(255)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.NAME' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.PARENTWHATIFID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.PENDINGDELETION' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.PERSISTENT' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.USERDEFINEDID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.VISIBLE' AS element_name, 'BIT NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=1, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.WHATIFCONFIG' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WHATIFSCENARIOS.WHATIFID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.CONFIGXML' AS element_name, 'CLOB NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.CREATIONUSERID' AS element_name, 'VARCHAR(30) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.DESCRIPTION' AS element_name, 'VARCHAR(255) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.EXPIRYTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.HASH' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.NAME' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.SYNCHLEVEL' AS element_name, 'NUMERIC(10) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.VERSION' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWFILES.WORKFLOWID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.CREATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.ENTRYID' AS element_name, 'NUMERIC(19) NOT NULL' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.FSSGROUPID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.FSSPENDINGRUNSTATUS' AS element_name, 'NUMERIC(10)' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=10, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.GLOBALROWID' AS element_name, 'NUMERIC(19) NOT NULL DEFAULT NEXT VALUE FOR GLOBALROWIDSEQUENCE' AS element_content, 'DATA_TYPE=NUMBER, DATA_PRECISION=19, DATA_SCALE=0' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.MCID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'TABLE_COLUMN' AS element_type, 'WORKFLOWTARGETFSSS.WORKFLOWID' AS element_name, 'VARCHAR(64) NOT NULL' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ACCESSKEYHASHES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ACCESSKEYHASHES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ACTIONCONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ACTIONCONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'AISERVLETUSERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_AISERVLETUSERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ARCHIVEMETADATA.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ARCHIVEMETADATA_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ATTRIBUTEMODIFIERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ATTRIBUTEMODIFIERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'BASEBUILDFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'BASEBUILDFILESETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_BASEBUILDFILESETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'CMCONFIGFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_CMCONFIGFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'COEFFICIENTSETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_COEFFICIENTSETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'COLDSTATES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_COLDSTATES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'COMPONENTLOGFILESNAPSHOTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_COMPONENTLOGFILESNAPSHOTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'CONFIGREVISIONSETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_CONFIGREVISIONSETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'CORRELATIONEVENTSETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_CORRELATIONEVENTSETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'CORRELATIONTRAVELTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_CORRELATIONTRAVELTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'DATABASESCHEMAINFO.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_DATABASESCHEMAINFO_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'DISPLAYCONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_DISPLAYCONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'EVENTACTIONMAPPINGS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_EVENTACTIONMAPPINGS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'EXTERNALFORECASTVISIBILITY.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_EXTERNALFORECASTVISIBILITY_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FEWSSESSIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FEWSSESSIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FEWSWEBSERVICES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FEWSWEBSERVICES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FLAGCONVERSIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FLAGCONVERSIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FLOODPERIODS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FLOODPERIODS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FORECASTINGSHELLS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FORECASTINGSHELLS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FSSGROUPS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FSSGROUPS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FSSRESOURCES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FSSRESOURCES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'FSSSTATUS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_FSSSTATUS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'HISTORICALEVENTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_HISTORICALEVENTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ICONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ICONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'IDMAPS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_IDMAPS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'IMPORTSTATUS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_IMPORTSTATUS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'INDEXFILESSNAPSHOTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_INDEXFILESSNAPSHOTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'LIVEMCAVAILABILITIES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_LIVEMCAVAILABILITIES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'LOCALMCID.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_LOCALMCID_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'LOCALSYNCHTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_LOCALSYNCHTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'LOGENTRIES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_LOGENTRIES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'LOGEVENTPROCESSORTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_LOGEVENTPROCESSORTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MAPLAYERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MAPLAYERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MASTERCONTROLLERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MASTERCONTROLLERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MCCONFIGFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MCCONFIGFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MCFAILOVERPRIORITIES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MCFAILOVERPRIORITIES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MCSYNCHSTATUS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MCSYNCHSTATUS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODIFIERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODIFIERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULEINSTANCECONFIGS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCECONFIGS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULEINSTANCEDATASETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCEDATASETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULEINSTANCERUNS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULEINSTANCERUNS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULEPARAMETERMODIFIERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULEPARAMETERMODIFIERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULEPARAMETERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULEPARAMETERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULERUNTABLES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULERUNTABLES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'MODULERUNTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_MODULERUNTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'PICLIENTCONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_PICLIENTCONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'PICLIENTDATASETS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_PICLIENTDATASETS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'PISERVICECONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_PISERVICECONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'PROCESSEDDELETEDROWS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_PROCESSEDDELETEDROWS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'PRODUCTINFO.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_PRODUCTINFO_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'REGIONCONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_REGIONCONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'REPORTIMAGES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_REPORTIMAGES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'REPORTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_REPORTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'REPORTTEMPLATES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_REPORTTEMPLATES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ROLLINGBARRELTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ROLLINGBARRELTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'ROOTCONFIGFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_ROOTCONFIGFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'SAMPLES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_SAMPLES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'SYSTEMACTIVITIES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_SYSTEMACTIVITIES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'SYSTEMCONFIGURATIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_SYSTEMCONFIGURATIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TABLELOCALMODIFICATIONTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TABLELOCALMODIFICATIONTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TASKRUNCOMPLETIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TASKRUNCOMPLETIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TASKRUNDISPATCHERTIMES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TASKRUNDISPATCHERTIMES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TASKRUNLOGFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TASKRUNLOGFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TASKRUNS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TASKRUNS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TASKS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TASKS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'THRESHOLDEVENTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_THRESHOLDEVENTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TIMESERIES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TIMESERIES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'TIMESERIESSTATUSSNAPSHOTS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_TIMESERIESSTATUSSNAPSHOTS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'UNITCONVERSIONS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_UNITCONVERSIONS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'USERS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_USERS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'USERSETTINGS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_USERSETTINGS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'USERTOGROUPSMAPPINGS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_USERTOGROUPSMAPPINGS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'VERSIONMANAGEMENT.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_VERSIONMANAGEMENT_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'VERSIONRUNNING.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_VERSIONRUNNING_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'WARMSTATES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_WARMSTATES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'WHATIFSCENARIOS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_WHATIFSCENARIOS_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'WORKFLOWFILES.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_WORKFLOWFILES_ID' AS element_info FROM DUAL UNION
  SELECT 'UNIQUE INDEX' AS element_type, 'WORKFLOWTARGETFSSS.GLOBALROWID' AS element_name, '1' AS element_content, 'IDX_WORKFLOWTARGETFSSS_ID' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'GLOBALROWIDS.CREATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'GLOBALROWIDS.GLOBALROWID' AS element_name, 'NUMERIC(19)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'GLOBALROWIDS.LOCALMODIFICATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'GLOBALROWIDS.MODIFICATIONTIME' AS element_name, 'TIMESTAMP(3)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'GLOBALROWIDS.TABLENAME' AS element_name, 'VARCHAR(27)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'TIMESERIESSIZES.MAXEXPIRYDURATIONINSEC' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'TIMESERIESSIZES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'TIMESERIESSIZES.NUMRECORDS' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'TIMESERIESSIZES.SUMBLOBSIZEKB' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'WARMSTATESSIZES.MAXEXPIRYDURATIONINSEC' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'WARMSTATESSIZES.MODULEINSTANCEID' AS element_name, 'VARCHAR(64)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'WARMSTATESSIZES.NUMRECORDS' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL UNION
  SELECT 'VIEW_COLUMN' AS element_type, 'WARMSTATESSIZES.SUMBLOBSIZEKB' AS element_name, 'NUMERIC(10)' AS element_content, '' AS element_info FROM DUAL
  ) t1 FULL OUTER JOIN (
  SELECT tmp1.element_type, tmp1.table_name || '.' || tmp1.column_name AS element_name,
    tmp1.element_content || CASE WHEN tmp2.data_default IS NULL THEN '' ELSE
    ' DEFAULT ' || CASE
        WHEN UPPER(tmp2.data_default) NOT LIKE '%NEXTVAL%'
        THEN tmp2.data_default ELSE 'NEXT VALUE FOR ' || UPPER(substr(tmp2.data_default, instr(tmp2.data_default, '.') + 1, instr(UPPER(tmp2.data_default), '.NEXTVAL', -1) - 1 - instr(tmp2.data_default, '.'))) END
    END AS element_content, element_info FROM (
  SELECT CASE WHEN view_name IS NOT NULL THEN 'VIEW_COLUMN' ELSE 'TABLE_COLUMN' END AS element_type, CASE WHEN view_name IS NULL THEN element_content || element_content_not_null ELSE element_content END AS element_content, utc.table_name, column_name, element_info FROM (
  SELECT utc.table_name, utc.column_name,
    CASE
      WHEN data_type='BLOB' THEN 'BLOB'
      WHEN data_type='CLOB' THEN 'CLOB'
      WHEN data_type LIKE 'TIMESTAMP(%)' THEN 'TIMESTAMP(' || data_scale || ')'
      WHEN data_type='VARCHAR2' AND data_length=char_col_decl_length THEN CASE WHEN char_length=1 THEN 'VARCHAR(1)' ELSE 'VARCHAR(' || char_length || ')' END
      WHEN data_type='FLOAT' THEN 'FLOAT' || '(' || data_precision || ')'
      WHEN data_type='RAW' THEN 'RAW(' || data_length || ')'
      WHEN data_type='NUMBER' THEN
        CASE WHEN data_scale IS NULL OR data_scale=0 THEN
          CASE
            WHEN data_precision=1 THEN 'BIT'
            WHEN data_precision=2 THEN 'TINYINT'
            WHEN data_precision=3 THEN 'SMALLINT'
            WHEN data_precision IN(19, 22) THEN 'NUMERIC(19)' ELSE 'NUMERIC(' || NVL(data_precision, 10) || ')'
          END
        ELSE 'NUMERIC(' || NVL(data_precision, 10) || ',' || data_scale || ')'
      END
      ELSE 'Unsupported data type ' || data_type || ' data_length=' || data_length || ' char_length=' || char_length || ' char_col_decl_length=' || char_col_decl_length END AS element_content,
        CASE WHEN NULLABLE='Y' THEN '' ELSE ' NOT NULL' END AS element_content_not_null,
        CASE WHEN data_type ='NUMBER' THEN 'DATA_TYPE=' || data_type || CASE WHEN data_precision IS NULL THEN '' ELSE ', DATA_PRECISION=' || data_precision END || CASE WHEN data_scale IS NULL THEN '' ELSE ', DATA_SCALE=' || data_scale END END AS element_info
    FROM user_tab_cols utc
    WHERE utc.hidden_column='NO'
  ) utc LEFT JOIN (SELECT table_name FROM user_tables) t ON utc.table_name=t.table_name  LEFT JOIN (SELECT view_name FROM user_views) v ON utc.table_name=v.view_name
 ) tmp1 LEFT JOIN (
  SELECT table_name, column_name, CASE WHEN data_default IS NULL OR data_default = 'NULL' THEN NULL ELSE TRIM(REGEXP_REPLACE(data_default, '"', '')) END AS data_default
  FROM
    XMLTable('$doc//ROWSET/ROW' PASSING (SELECT DBMS_XMLGEN.getXMLtype('SELECT table_name, column_name, data_default FROM user_tab_cols WHERE data_default IS NOT NULL') AS xml FROM DUAL) AS "doc"
    COLUMNS table_name VARCHAR2(30) path './TABLE_NAME/text()', column_name VARCHAR2(30) path './COLUMN_NAME/text()', data_default VARCHAR2(4000) path './DATA_DEFAULT/text()'
  )
  )  tmp2 ON tmp1.table_name=tmp2.table_name AND tmp1.column_name=tmp2.column_name
 UNION
  SELECT 'FOREIGN KEY' AS element_type, uc.table_name || '.' || cols.column_name || '#' || (SELECT table_name FROM user_constraints WHERE constraint_name = uc.r_constraint_name) || '.' ||
    (SELECT column_name FROM user_cons_columns WHERE constraint_name = uc.r_constraint_name AND position = cols.position) AS element_name,
    CAST (cols.position AS VARCHAR2(2)) AS element_content,
    uc.constraint_name AS element_info
  FROM user_constraints uc INNER JOIN user_cons_columns cols ON uc.constraint_name = cols.constraint_name WHERE constraint_type = 'R' AND status='ENABLED'
UNION
SELECT CASE WHEN uniqueness='NONUNIQUE' THEN 'INDEX' WHEN constraint_type='P' THEN 'PRIMARY KEY' ELSE 'UNIQUE INDEX' END AS element_type,
 element_name, element_content, element_info FROM (
  SELECT
  uic.table_name, uniqueness, uic.table_name || '.' || uic.column_name AS element_name, TO_CHAR(uic.column_position) AS element_content, uic.index_name  || CASE WHEN index_type='FUNCTION-BASED NORMAL' THEN '(1)' ELSE '' END AS element_info
  FROM user_indexes ui, user_ind_columns  uic
  WHERE ui.table_name=uic.table_name AND ui.index_name=uic.index_name
  AND uic.column_name NOT LIKE '%$'
) tmp1 LEFT JOIN(
SELECT table_name,constraint_name,constraint_type FROM user_constraints c WHERE constraint_type='P'
) tmp2 ON tmp1.table_name = tmp2.table_name AND tmp1.element_info = tmp2.constraint_name
UNION
  SELECT 'SEQUENCE' AS element_type, sequence_name AS element_name,
    'INCREMENT_BY=' || increment_by AS element_content,
    'MIN_VALUE=' || min_value || ', MAX_VALUE=' || max_value || ', CACHE_SIZE=' || cache_size || ', LAST_VALUE=' || last_number AS element_info
  FROM user_sequences
) t2 ON t1.element_type=t2.element_type AND t1.element_name=t2.element_name
) tmp WHERE CASE WHEN expected = actual OR actual = expected || ' DEFAULT null' THEN 0 ELSE 1 END = 1 AND NOT element_name LIKE '%$%' AND NOT REGEXP_LIKE(element_name, '^(REDO_|SCHEDULER_JOB_ARGS|PRODUCT_PRIVS|LOGMNR|MVIEW_|HELP.|REPCAT_LOG_SEQUENCE|SCHEDULER_PROGRAM_ARGS|SQLPLUS_PRODUCT_PROFILE|ALL_OBJECTS)') AND UPPER(element_name) NOT LIKE 'ARCHIVES.%'
ORDER BY element_type, element_name, expected, actual, expected_element_info, actual_element_info;

SPOOL OFF
PROMPT Validation results have been written to &spool_filename;
PROMPT;

EXIT