# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 13:24:40 2020

@author: driebergen

"""

import pandas as pd
from utils_EFCIS import Utils as UtilsEFCIS
import logging
import sys
from pathlib import Path
import numpy as np
import json
import os

pd.options.mode.chained_assignment = None  # ignore warnings; default='warn'

def add_existing_columns(df,dict_kolommen):
    """
    Functie om extra kolommen aan een dataframe toe te voegen met standaard waarden
    Indien de kolom al bestaat, worden alleen lege cellen gevuld.
    dict_kolommen is een dictionary met kolommen en standaardwaarde:
    {extracol1:standaardvalue1,extracol2:standaardvalue2,etc..}
    """
    for kol in dict_kolommen.keys():
        if not(kol in df.columns):
            df[kol] = dict_kolommen[kol]
        else:
            df.loc[df[kol].isnull(),kol] = dict_kolommen[kol]
    return df

def add_new_columns(df,dict_kolommen):
    """
    Functie om extra kolommen aan een dataframe toe te voegen met standaard waarden
    Indien de kolom al bestaat, wordt deze overschreven.
    dict_kolommen is een dictionary met kolommen en standaardwaarde:
    {extracol1:standaardvalue1,extracol2:standaardvalue2,etc..}
    """
    for col in dict_kolommen.keys():
        df[col] = dict_kolommen[col]
    return df

def sort_dataframe(df,col_name):
    return df.sort_values(by = col_name)

def maak_param_FEWS(df,cols,unitcol,col_out,logger):
    """
    Functie om óf grootheid, óf typering samen te voegen met waarde uit kolom unitcol
    Dit wordt voor een geheel dataframe gedaan. Resultaat wordt in col_out geschreven
    """
    for idx,row in df.iterrows():
        if all([UtilsEFCIS.check_nan_empty_str(row[col]) for col in cols]):
            logger.error('Could not find a FEWS parameter for index {}'.format(idx))
            sys.exit(1)
        for concat_col in cols:
            if not(row[concat_col] == '' or pd.isnull(row[concat_col])):
                df.loc[idx,col_out] = row[concat_col]+'[{}]'.format(row[unitcol])
                break
    return df

def splits_kolom(df,col_in,cols_out,patterns,sep = ','):
    """
    Functie om een kolom col_in te splitsen gebasseerd op een pattern.
    Er wordt aangenomen dat de waarden in col_in zijn gesplitst gebasseerd op een seperator sep (standaard ',')
    Vervolgens wordt er een selectie gemaakt welke patronen voorkomen en deze worden in cols_out gezet
    """
    for col_out,pattern in zip(cols_out,patterns):
        subset = df[df[col_in].str.contains(pattern)]
        #subset = list(df[col_in])
        list_pattern = [[sub for sub in row[col_in].split(sep) if pattern in sub] for idx,row in subset.iterrows()]
        list_index   = [[idx for sub in row[col_in].split(sep) if pattern in sub] for idx,row in subset.iterrows()]
        list_pattern = [item for sublist in list_pattern for item in sublist]
        list_index = [item for sublist in list_index for item in sublist]
        df.loc[list_index,col_out] = list_pattern
    return df

def map_oms_code(kolom,dictionary,keys,logger):
    """
    Function to extract values from keys.
    If element in keys not in dictionary, nan is returned.
    """
    mapped = []
    for idx,key in enumerate(keys):
        if not(key in dictionary.keys()):
            mapped.append(np.nan)
            logger.error('Unknown key {} for column {} line {}, set nan'.format(key,kolom,idx))
            sys.exit(1)
        else:
            mapped.append(dictionary[key])
    return mapped
            

def check_valueproperty_list(df,col,options,samplecol,parcol,logger):
    """ 
    Function to check for a column col in dataframe df if the values in this column exist in the list options
    if not, log line number, warning en toevoegen dummy parameter MEETINSTANTIE_UNMAPPABLE voor gehele sample
    """
    df_subset = df[~df[col].isin(options)]
    for idx,row in df_subset.iterrows():
        if not(row[col] in options):
            logger.error('Value {} for column {} not in list of possible options for line number {}'.format(row[col],col,idx))
            sys.exit(1)
    df.loc[~df[col].isin(options),parcol] = 'MEETINSTANTIE_UNMAPPABLE'    
    return df


def splitmeetobjectcode(df, srccol, targetmeetobject, targetnamespace):
    """
    Functie om voor locaties de namespace te splitsen van de locatie
    """
    df[targetmeetobject] = [string.split('NL14_')[-1] for string in df[srccol]]
    df[targetnamespace] = [string.split('_')[0] for string in df[srccol]]
    return df


def make_resultaatdatumtijd(df, coldatumtijd, sourcepattern, coldatumout, coltijduit):
    """
    Splits kolom met datumtijd naar kolom met datum en kolom met tijd
    """
    df[coldatumout] = [datumtijd.date().strftime('%Y-%m-%d') for datumtijd in pd.to_datetime(df[coldatumtijd], format=sourcepattern)]
    df[coltijduit] = [datumtijd.time().strftime('%H:%M:%S') for datumtijd in pd.to_datetime(df[coldatumtijd], format=sourcepattern)]
    return df

def create_taxonnaamtype(df,biotaxoncol, taxontypecol, outcol):
    df[outcol] = df[biotaxoncol] + '_' + df[taxontypecol]
    return df


def make_taxontype(df, col, taxontype):
    if col in df.columns:
        df.loc[~df[col].isnull(), col] = taxontype
    else:
        df[col] = taxontype
    return df


def make_metingdatumtijd(df, coldatum, coltijd, colout):
    df[colout] = df[coldatum] + ' ' + df[coltijd]
    return df


def preprocessing(config_dir,config,import_folder,logger):
    #%%inlezen qualifier kolommen
    logger.info('Start reading Qualifier csv files')
    import_folder_bio    = import_folder / 'Biologie'
    import_files_bio    = [x for x in import_folder_bio.glob('*.csv') if x.is_file()]
    
    #import_files = glob.glob('import_folder/*')
    FEWS_typering           = config_dir / 'MapLayerFiles/Qualifiers/Typering.csv'
    FEWS_grootheid          = config_dir / 'MapLayerFiles/Qualifiers/Grootheid.csv'
    FEWS_parcode            = config_dir / 'MapLayerFiles/Qualifiers/Parametercode.csv'
    FEWS_waardebewerking    = config_dir / 'MapLayerFiles/Qualifiers/Waardebewerkingsmethode.csv'
    FEWS_hoedaningheid      = config_dir / 'MapLayerFiles/Qualifiers/Hoedanigheid.csv'
    FEWS_biotaxon           = config_dir / 'MapLayerFiles/Qualifiers/TWN_biotaxon.csv'
    FEWS_compartiment       = config_dir / 'MapLayerFiles/Qualifiers/Compartiment.csv'
    FEWS_meetinstantie      = config_dir / 'MapLayerFiles/Qualifiers/Meetinstantie.csv'
    FEWS_levensstadium      = config_dir / 'MapLayerFiles/Qualifiers/Levensstadium.csv'
    FEWS_gedrag             = config_dir / 'MapLayerFiles/Qualifiers/Gedrag.csv'
    FEWS_param              = config_dir / 'MapLayerFiles/Parameters/Parameters.csv'

    df_FEWS_typering        = UtilsEFCIS.read_pandas_csv(FEWS_typering,';',logger)
    df_FEWS_grootheid       = UtilsEFCIS.read_pandas_csv(FEWS_grootheid,';',logger)
    df_FEWS_parcode         = UtilsEFCIS.read_pandas_csv(FEWS_parcode,';',logger)
    df_FEWS_waardebewerking = UtilsEFCIS.read_pandas_csv(FEWS_waardebewerking,';',logger)
    df_FEWS_hoedaningheid   = UtilsEFCIS.read_pandas_csv(FEWS_hoedaningheid,';',logger)
    df_FEWS_biotaxon        = UtilsEFCIS.read_pandas_csv(FEWS_biotaxon,';',logger)
    df_FEWS_compartiment    = UtilsEFCIS.read_pandas_csv(FEWS_compartiment,';',logger)
    df_FEWS_meetinstantie   = UtilsEFCIS.read_pandas_csv(FEWS_meetinstantie,';',logger)
    df_FEWS_levensstadium   = UtilsEFCIS.read_pandas_csv(FEWS_levensstadium,';',logger)
    df_FEWS_gedrag          = UtilsEFCIS.read_pandas_csv(FEWS_gedrag,';',logger)
    df_FEWS_param           = UtilsEFCIS.read_pandas_csv(FEWS_param,';',logger)

    
    #Lijsten die worden gebruikt om waarden te verplaatsen naar juiste IM metingen kolommen
    TP_list = list(df_FEWS_typering['Code'])
    GH_list = list(df_FEWS_grootheid['Code'])
    PC_list = list(df_FEWS_parcode['Code'])
    PC_naam = list(df_FEWS_parcode['Omschrijving'])
    BT_list = list(df_FEWS_biotaxon['taxonname'])
    WB_list = list(df_FEWS_waardebewerking['Code'])
    HH_list = list(df_FEWS_hoedaningheid['Code'])
    LS_list = list(df_FEWS_levensstadium['Code'])
    GG_list = list(df_FEWS_gedrag['Code'])

    mapping_lists = {'TP_list':TP_list,'GH_list':GH_list,'PC_list':PC_list,'PC_naam':PC_naam,'BT_list':BT_list
                     ,'WB_list':WB_list,'HH_list':HH_list,'LS_list':LS_list,'GG_list':GG_list}
    mapping_strvar = {'np.nan':np.nan,'object':object}
    taxontype_hoed_mapping = ['MACAG', 'FYTPT', 'DIATM']
    mapping_CO = {row['Omschrijving']: row['Code'] for idx, row in df_FEWS_compartiment.iterrows()}
    mapping_taxontype = {'Vissen': 'VISSN', 'Amfibieen': 'AMFBE', 'Ongewervelden': 'MACEV', 'Vlinders': 'VLIND',
                         'Zoogdieren': 'ZOOGD', 'Vogels': 'VOGLS'}
    #%% Tel aantal files dat wordt aangeboden, check later of dit gelijk is aan preprocessed
    totaalfiles = len(import_files_bio)
    processed   = 0

    for settings in config['Files']:
        logger.info('Processing file pattern {}'.format(settings['file pattern']))
        files = [file for file in import_files_bio if file.name.startswith(settings['file pattern'])]
        for file in files:
            logger.info('Start processing {}'.format(file))
            col_names = pd.read_csv(file, sep=';', nrows=0).columns
            dtypes_dict = UtilsEFCIS.replace_values_dict(settings['dtypes_dict'],mapping_strvar)
            dtypes_dict.update({col: str for col in col_names if col not in dtypes_dict})
            df = pd.read_csv(file, dtype=dtypes_dict, sep=';')

            #File specifieke aanpassingen voor Fytoplankton (direct na inlezen csv file)
            if settings['file pattern'] == 'Fytoplankton':
                df = df[df['Meetpakket_Code'] == 'FP.AC']

            #Replace value in specific columns with mapping in dictionary
            for mapping in settings["replace_value"]:
                logger.info('Map strings in column {}'.format(mapping['col']))
                df = UtilsEFCIS.replace_value(df,mapping['col'],UtilsEFCIS.replace_values_dict(mapping['mapping'],mapping_strvar),object)

            #Move values from src col to target col
            for moveto in settings['movecol']:
                logger.info('Move strings in {} to {}'.format(moveto['srccol'],moveto['targetcol']))
                df = UtilsEFCIS.movecolumndf(df, mapping_lists[moveto['list']], moveto['srccol'],moveto['targetcol'])

            # add extra columns
            df = add_existing_columns(df, UtilsEFCIS.replace_values_dict(settings['add_existing_columns'],
                                                                          mapping_strvar))
            df = add_new_columns(df, UtilsEFCIS.replace_values_dict(settings['add_new_columns'], mapping_strvar))

            #Check if after moving strings, there are still values in the columns that should not be there
            UtilsEFCIS.check_empty_columns(df,settings['check_empty_cols'],logger)

            sett = settings['create_taxonnaamtype']
            if len(sett) > 0:
                df = create_taxonnaamtype(df,sett['biotaxoncol'],sett['partypecol'],sett['outcol'])

            #If necessary, split meetobject namespace and store in seperate columns
            sett = settings['splitsmeetobjectcode']
            if len(sett)>0:
                df = splitmeetobjectcode(df, sett['srccol'], sett['targetmobj'], sett['targetnamespace'])

            #Maak datumtijd kolom gebasseerd op apparte kolommen datum en tijd
            sett = settings['make_metingdatumtijd']
            if len(sett) > 0:
                df = make_metingdatumtijd(df, sett['coldatum'], sett['coltijd'], sett['colout'])

            #Maak kolommen voor resultaatdatum/tijd in FEWS
            sett = settings['make_resultaatdatumtijd']
            df = make_resultaatdatumtijd(df, sett['coldatumtijd'], sett['sourcepattern'], sett['coldatumout'], sett['coltijduit'])

            #File specifieke aanpassingen Macrofyten (deze aanpassing moet gebeuren vóór het maken van FEWS parameter)
            if settings['file pattern'] == 'Macrofyten':
                df.loc[(df['Grootheid.code'] == 'HOOGTE') & (df['Compartiment_Code'] == 'SB'), 'Grootheid.code'] = 'SLIBDTE'
                df.loc[(df['Parameter_Type'].isin(taxontype_hoed_mapping)) & (df['Eenheid_Gemeten'] == 'n/ml') & (df['Hoedanigheid.code'] == 'NVT'), 'Hoedanigheid.code'] = 'cel'

            #Maak fews parameter kolom aan
            sett = settings['maak_param_FEWS']
            if len(sett) > 0:
                df = maak_param_FEWS(df, sett['srccols'],sett['eenheidcol'],sett['outcol'], logger)

            #Convert alfanumerieke waardes
            sett = settings['convert_alphanumeric']
            if len(sett) > 0:
                df = UtilsEFCIS.convert_alphanumeric(df, sett['fewsparcol'], sett['anumeriekcol'])

            #Maak sample id uniek en sorteer dataframe
            sett = settings['make_sampleid_unique']
            df = UtilsEFCIS.make_sampleid_unique(df, sett['loccol'], sett['datumcol'], sett['collectienummer'],sett['outcol'])
            df = sort_dataframe(df, sett['outcol'])

            #Add postfix to sampleid
            sett = settings['add_postfix_importbestand']
            df = UtilsEFCIS.add_postfix_importbestand(df, sett['sampleidcol'], sett['postfix'])

            #Controleer of aangeboden meetinstantie voorkomt in qualifierlijst. Indien  niet, log error
            sett = settings['check_valueproperty_list']
            df = check_valueproperty_list(df,sett['leveranciercol'],df_FEWS_meetinstantie['Omschrijving'].values,sett['sampleidcol'],sett['fewsparcol'],logger)

            #Controleer of er parameters zijn die in FewsParGroup "7. Niet bemeten"
            sett = settings['log_params_niet_bemeten']
            failedfolder = file.parent / 'preprofailed'
            failedfolder.mkdir(exist_ok=True, parents=True)
            failedmonsters = UtilsEFCIS.log_params_niet_bemeten(file,df,sett['fewsparcol'],df_FEWS_param,'7. Niet bemeten',failedfolder,logger)

            #File specifieke aanpassingen
            if settings['file pattern'] == 'Fytoplankton':
                df = splits_kolom(df, 'Parameter_Kenmerken',['Levensvorm.Code', 'LengteKlasse.Code'], ['LV', 'FL'], sep=',')
                df.loc[(df['Parameter_Type'].isin(taxontype_hoed_mapping)) & (df['Eenheid_Berekend'] == 'n/ml') & (df['Hoedanigheid.code'] == 'NVT'), 'Hoedanigheid.code'] = 'cel'

            if settings['file pattern'] == 'Macrofauna':
                df.loc[(df['Parameter_Type'].isin(taxontype_hoed_mapping)) & (df['Eenheid_Berekend'] == 'n/ml') & (df['Hoedanigheid.code'] == 'NVT'), 'Hoedanigheid.code'] = 'cel'

            if settings['file pattern'] == 'FF':
                df['Compartiment.code'] = map_oms_code('d_COMPARTI', mapping_CO, df.d_COMPARTI, logger)
                df['taxonnaamtype'] = df['d_LAT_SOOR'] + '_' + df['d_SOORTGRO'].map(mapping_taxontype)
                df['Parameter_Type'] = df['d_SOORTGRO'].map(mapping_taxontype)

            df_succes = df[~df['Sample_Id_FEWS'].isin(failedmonsters)]
            df_failed = df[df['Sample_Id_FEWS'].isin(failedmonsters)]

            if not (file.name.endswith('succesvol.csv')):
                filesucces = file.parent / (file.stem + '_succesvol.csv')
            else:
                filesucces = file

            filefailed = file.parent / failedfolder / (file.stem + '_failed.csv')
            df_succes.to_csv(filesucces, header=True, index=False, sep=';', encoding="utf-8-sig")
            if not (df_failed.empty):
                df_failed.to_csv(filefailed, header=True, index=False, sep=';', encoding="utf-8-sig")

            if not (file == filesucces):
                os.remove(file)

            processed +=1
            # Write result: Update import file to IMmetingen format
            #processed += 1
            #if not(resultnietbem):
            #    df.to_csv(file, header=True, index=False, sep=';', encoding="ISO-8859-1")

    if not(processed == totaalfiles):
        logger.error('{} csv files where found, but only {} processed based on wildcards'.format(totaalfiles,processed))
        sys.exit(1)
    logger.info('Finished with conversion steps, ready for import in FEWS')


def main(argv):
    config_dir = Path(argv[0])
    import_dir = Path(argv[1])
    log_dir    = Path(argv[2])
    loghistorydir = log_dir / 'loghistory'

    log_dir.mkdir(exist_ok=True)
    loghistorydir.mkdir(exist_ok=True)
    
    logger = UtilsEFCIS.set_up_logging(log_dir / 'log_PreProImport_BIO.txt',
                                      loghistorydir / 'log_PreProImport_BIO.txt', logging.DEBUG)

    with open('PreProImport_BIO.json') as json_file:
        config = json.load(json_file)

    logger.info('Starting preprocessing import files EFCIS Biologische data')
    logger.info('Config directory : {}'.format(config_dir))
    logger.info('Import directory : {}'.format(import_dir))
    try:
        preprocessing(config_dir,config,import_dir, logger)
        logger.info('Succesfully finished script PreProImport_BIO.py')
        UtilsEFCIS.flush_close_logging(logger)
    except Exception as e:
        logger.error('Something whent wrong in preprocessing script')
        logger.error('{}'.format(e))
        UtilsEFCIS.flush_close_logging(logger)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1:])
    else:  
        args = [r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/Config',
                r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/tofss/Import/SampleData',
                r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/fromfss/ImportPrePro_Logging/Biologie'
                 ]
        main(args)
      

    