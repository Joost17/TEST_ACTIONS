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
import os

pd.options.mode.chained_assignment = None  # ignore warnings; default='warn'

def sort_dataframe(df,col_name):
    return df.sort_values(by = col_name)


def find_taxontype_taxonname(df_import,df_FEWS_biotaxon,logger):
    df_import['Organisme.taxontype'] = np.nan
    df_subset = df_import[~df_import['Organisme.naam'].isnull()]
    for idx,row in df_subset.iterrows():
        if not(row['Organisme.naam'] in df_FEWS_biotaxon['taxonname'].values):
            logger.warning('Taxonname {} not in biotaxon qualifier lijst'.format(row['Organisme.naam']))
            continue
        subset_taxontype = df_FEWS_biotaxon.loc[df_FEWS_biotaxon['taxonname'] == row['Organisme.naam']]
        if len(subset_taxontype) > 1:
            logger.warning('Mapping from taxonname {} to taxontype is not unambiguous'.format(row['Organisme.naam']))
            continue
        else:
            df_import.loc[idx,'Organisme.taxontype'] = subset_taxontype['taxontype'].values[0]
    
    return df_import            

def process_comments_alfanumeriek(df_FC,df_FEWS_param,logger):
    # Tekst uit kolom numerieke waarde verplaatsen naar opmerking (indien n.g."/"n.t.b."/"n.a in kolom Numeriekewaarde)
    df_import_an = df_FC[~df_FC['custom.waarnemingssoort.nummer'].isin(df_FEWS_param['EnumerationId'])]
    df_an_subset = df_import_an[df_import_an.Numeriekewaarde.isnull()]
    #Alleen als er comments staan in de subset, moeten deze veplaatst worden naar kolom MeetwaardeOpmerking
    df_an_subset['Alfanumeriekewaarde'] = df_an_subset['Alfanumeriekewaarde'].astype(str)
    df_an_subset = df_an_subset[df_an_subset.Alfanumeriekewaarde.str.lower().isin(['n.g.', 'n.t.b.', 'n.a.'])]
    if not (df_an_subset.Alfanumeriekewaarde.isnull().all()):
        logger.info('Found strings in Alfanumeriekewaarde')
        index_opmerking_gevuld = df_an_subset[(~df_an_subset['MeetwaardeOpmerking'].isnull())].index
        index_opmerking_leeg = df_an_subset[(df_an_subset['MeetwaardeOpmerking'].isnull())].index
        df_FC.loc[index_opmerking_gevuld, 'MeetwaardeOpmerking'] = \
            df_FC.loc[index_opmerking_gevuld, 'Alfanumeriekewaarde'] + ', ' + \
            df_FC.loc[index_opmerking_gevuld, 'MeetwaardeOpmerking']
        df_FC.loc[index_opmerking_leeg, 'MeetwaardeOpmerking'] = \
            df_FC.loc[index_opmerking_leeg, 'Alfanumeriekewaarde']
        df_FC.loc[df_an_subset.index, 'Alfanumeriekewaarde'] = np.nan
    return df_FC

def move_X_Y_monsterid(df_FC,chemiefile,logger):
    df_FC['X_monster'] = np.nan
    df_FC['Y_monster'] = np.nan
    for monsterid in df_FC['Monster.lokaalID'].unique():
        WNS_X = 'WNS11483'
        WNS_Y = 'WNS11485'
        subset = df_FC[
            (df_FC['Monster.lokaalID'] == monsterid) & (df_FC['custom.waarnemingssoort.nummer'].isin([WNS_X, WNS_Y]))]
        if subset.empty:
            continue
        if not (subset['custom.waarnemingssoort.nummer'].isin([WNS_X, WNS_Y]).all()):
            logger.error(
                'Expect both X WNS {} and Y WNS {} present for file {} and sample id {}'.format(chemiefile, monsterid))
            sys.exit(1)
        X_monster = subset[subset['custom.waarnemingssoort.nummer'] == WNS_X]['Numeriekewaarde'].values[0]
        Y_monster = subset[subset['custom.waarnemingssoort.nummer'] == WNS_Y]['Numeriekewaarde'].values[0]
        # Set sample property X and Y coördinates.
        df_FC.loc[df_FC['Monster.lokaalID'] == monsterid, 'X_monster'] = X_monster
        df_FC.loc[df_FC['Monster.lokaalID'] == monsterid, 'Y_monster'] = Y_monster
        df_FC['X_monster'] = df_FC['X_monster'].astype('Int64')
        df_FC['Y_monster'] = df_FC['Y_monster'].astype('Int64')
        # Drop records with X,Y coördinates
        df_FC = df_FC.drop(df_FC[(df_FC['Monster.lokaalID'] == monsterid) & (df_FC['custom.waarnemingssoort.nummer'] == WNS_X)].index[0])
        df_FC = df_FC.drop(df_FC[(df_FC['Monster.lokaalID'] == monsterid) & (df_FC['custom.waarnemingssoort.nummer'] == WNS_Y)].index[0])
    return df_FC

def preprocessing(config_dir,import_folder,logger):
    #%%inlezen qualifier kolommen
    logger.info('Start reading Qualifier csv files')
    import_folder_chemie = import_folder / 'FysischeChemie'
    import_files_chemie = [x for x in import_folder_chemie.glob('*.csv') if x.is_file()]

    #%% Import bestand CHEMIE
    patterns_chemie = ['110084_Ontwikkeling, Strategie en Adv','110081_Monitoring_']
    chemie_files    = [file for file in import_files_chemie if any([file.name.startswith(pattern) for pattern in patterns_chemie])]
    FEWS_biotaxon           = config_dir / 'MapLayerFiles/Qualifiers/TWN_biotaxon.csv'
    FEWS_meetinstantie      = config_dir / 'MapLayerFiles/Qualifiers/Meetinstantie.csv'
    FEWS_param              = config_dir / 'MapLayerFiles/Parameters/Parameters.csv'
    df_FEWS_biotaxon        = UtilsEFCIS.read_pandas_csv(FEWS_biotaxon,';',logger)
    df_FEWS_meetinstantie   = UtilsEFCIS.read_pandas_csv(FEWS_meetinstantie,';',logger)
    df_FEWS_param           = UtilsEFCIS.read_pandas_csv(FEWS_param,';',logger)
    map_taxonnametype = {'Macrophytes':'MACFT','Macroinvertebrates':'MACEV','Nematodes':'NEMTD',
     'Fish':'VISSN','Diatoms':'DIATM','Phytoplankton':'FYTPT','Zooplankton':'ZOOPT',
     'Birds':'VOGLS','Butterflies':'VLIND','Amphibia':'AMFBE','Reptiles':'REPTL',
     'Macroalgae':'MACAG','Mammals':'ZOOGD'}
    
    mapping_meetinstantie = {str(int(row['Code'])):row['Omschrijving'] for idx,row in df_FEWS_meetinstantie.iterrows()}
    processed = 0
    for chemiefile in chemie_files:
        logger.info('Start processing {}'.format(chemiefile))
        df_FC     = pd.read_csv(chemiefile,sep = ';',dtype={'Kwaliteitsoordeel.code': object})
        df_FC     = df_FC.convert_dtypes(convert_string=False)
        df_FC     = sort_dataframe(df_FC, 'Monster.lokaalID')
        df_FC     = UtilsEFCIS.add_postfix_importbestand(df_FC, 'Monster.lokaalID', '_FC')

        if not(df_FC['Biotaxon.naam'].isnull().all()):
            logger.warning('Biotaxon.naam is not empty')

        df_FC['Meetinstantie.code'] = df_FC['Meetinstantie.code'].apply(str)
        
        df_FC = UtilsEFCIS.replace_value(df_FC,'Meetinstantie.code',mapping_meetinstantie,object)

        df_subset = df_FC[~df_FC['Meetinstantie.code'].isin(df_FEWS_meetinstantie['Omschrijving'])]
        for idx,row in df_subset.iterrows():
            if not(row['Meetinstantie.code'] in df_FEWS_meetinstantie['Omschrijving'].values):
                logger.error('Value {} for column Meetinstantie.code not in list of possible options for line number {}'.format(row['Meetinstantie.code'],idx))
                sys.exit(1)
                
        #Convert alphanumeric values
        df_FC = UtilsEFCIS.convert_alphanumeric(df_FC,'custom.waarnemingssoort.nummer','Alfanumeriekewaarde')
        
        #Maak aparte kolommen Resultaatdatum en Resultaattijd om als valueproperties in FEWS te importeren.
        df_FC['Resultaatdatum_fews'] = [datumtijd.date().strftime('%Y-%m-%d') for datumtijd in pd.to_datetime(df_FC['Resultaatdatum'],format='%Y-%m-%d')]
        df_FC['Resultaattijd_fews']  = [datumtijd.time().strftime('%H:%M:%S') for datumtijd in pd.to_datetime(df_FC['Resultaattijd'],format='%H:%M:%S')]

        if not('Organisme.taxontype') in df_FC.columns:
            df_FC     = find_taxontype_taxonname(df_FC,df_FEWS_biotaxon,logger)
        df_FC['Organisme.naam'] = df_FC['Organisme.naam'].astype(str)
        df_FC.loc[~df_FC['Organisme.naam'].isnull(),'Organisme.taxonnaamtype'] =  df_FC['Organisme.naam'] + '_' + df_FC['Organisme.taxontype'].map(map_taxonnametype)

        if not('Duplicaat.code' in df_FC.columns):
            df_FC['Duplicaat.code'] = np.nan    
        df_FC     = df_FC.reset_index(drop = True)
        df_FC['Meetobject.code']= [string.split('NL14_')[-1] for string in df_FC['Meetobject.lokaalID']]
        df_FC['Namespace.code']= [string.split('_')[0] for string in df_FC['Meetobject.lokaalID']]

        df_FC = move_X_Y_monsterid(df_FC,chemiefile,logger)

        df_FC = process_comments_alfanumeriek(df_FC, df_FEWS_param,logger)

        #Controleer of er parameters zijn die in FewsParGroup "7. Niet bemeten" voorkomen
        failedfolder = chemiefile.parent / 'preprofailed'
        failedfolder.mkdir(exist_ok=True,parents=True)
        failedmonsters = UtilsEFCIS.log_params_niet_bemeten(chemiefile,df_FC,'custom.waarnemingssoort.nummer',df_FEWS_param,'7. Niet bemeten',failedfolder,logger)

        processed += 1
        if '_FEWS_FC' in str(chemiefile):
            chemiefilenew = chemiefile
        else:
            chemiefilenew = chemiefile.parent / (chemiefile.stem + '_FEWS_FC.csv')

        df_succes = df_FC[~df_FC['Monster.lokaalID'].isin(failedmonsters)]
        df_failed = df_FC[df_FC['Monster.lokaalID'].isin(failedmonsters)]

        if not(chemiefilenew.name.endswith('FEWS_FC_succesvol.csv')):
            chemiefilesucces = chemiefilenew.parent / (chemiefilenew.stem + '_succesvol.csv')
        else:
            chemiefilesucces = chemiefilenew

        chemiefilefailed = chemiefilenew.parent / failedfolder / (chemiefilenew.stem + '_failed.csv')
        df_succes.to_csv(chemiefilesucces, header=True, index=False, sep=';', encoding="utf-8-sig")
        if not(df_failed.empty):
            df_failed.to_csv(chemiefilefailed, header=True, index=False, sep=';', encoding="utf-8-sig")

        if not(chemiefilenew == chemiefilesucces):
            os.remove(chemiefile)

    if not(len(import_files_chemie) == processed):
        logger.error('{} csv files where found, but only {} processed based on wildcards'.format(len(import_files_chemie),processed))
        sys.exit(1)

    logger.info('Finished with conversion steps, ready for import in FEWS')   

#%%

def main(argv):
    config_dir = Path(argv[0])
    import_dir = Path(argv[1])
    log_dir    = Path(argv[2])
    loghistorydir = log_dir / 'loghistory'

    log_dir.mkdir(exist_ok=True)
    loghistorydir.mkdir(exist_ok=True)
    
    logger = UtilsEFCIS.set_up_logging(log_dir / 'log_PreProImport_FC.txt',
                                      loghistorydir / 'log_PreProImport_FC.txt', logging.DEBUG)

    logger.info('Starting preprocessing import files EFCIS Fysisch-Chemische data')
    logger.info('Config directory : {}'.format(config_dir))
    logger.info('Import directory : {}'.format(import_dir))
    try:
        preprocessing(config_dir,import_dir, logger)
        logger.info('Succesfully finished script PreProImport_FC.py')
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
                r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/Modules/Import_preprocessing/logs'
                 ]
        main(args)
      

