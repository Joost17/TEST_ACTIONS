# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 13:24:40 2020

@author: driebergen

"""



import pandas as pd
import sys
from pathlib import Path
from utils_EFCIS import Utils as UtilsEFCIS
from datetime import datetime
import logging
pd.options.mode.chained_assignment = None  # ignore warnings; default='warn'


def sort_dataframe(df,col_name):
    return df.sort_values(by = col_name)

    #%%inlezen biologie toetswaarde files
def preprocessing(config_dir,import_folder,logger):
    logger.info('Start reading Qualifier csv files')

    bio_toetsing      = import_folder / 'jaarlijks'
    N_files_jaar      = len([file for file in bio_toetsing.iterdir() if file.name.endswith('.csv')])
    toetsing_files    = [bio_toetsing / file for file in bio_toetsing.iterdir() if file.name.startswith('Toetsing biologie')]
    print(toetsing_files)
    FEWS_typering     = config_dir / 'MapLayerFiles/Qualifiers/Typering.csv'
    FEWS_parcode      = config_dir / 'MapLayerFiles/Qualifiers/Parametercode.csv'
    FEWS_parameters   = config_dir / 'MapLayerFiles/parameters/Parameters.csv'
    FEWS_grootheid    = config_dir / 'MapLayerFiles/Qualifiers/Grootheid.csv'

    df_FEWS_typering  = UtilsEFCIS.read_pandas_csv(FEWS_typering,sep=';',logger=logger)
    df_FEWS_parcode   = UtilsEFCIS.read_pandas_csv(FEWS_parcode,sep=';',logger=logger)
    df_FEWS_param     = UtilsEFCIS.read_pandas_csv(FEWS_parameters,sep=';',logger=logger)    
    df_FEWS_grootheid = UtilsEFCIS.read_pandas_csv(FEWS_grootheid,sep=';',logger=logger)
    
    #Mapping WNS code en wns omschrijving
    map_wnscode_oms = {row['WnsId']:row['WNS_Code'] for idx,row in df_FEWS_param.iterrows()}
    #Mapping om taxonnaamtype aan te maken
    mapping_name_taxontype = {'fytoplankton':'FYTPT','macrofauna':'MACEV',
                              'macrofyten':'MACFT','vissen':'VISSN'}

    TP_list = list(df_FEWS_typering['Code'])
    PC_list = list(df_FEWS_parcode['Code'])
    PAR_OMS = list(df_FEWS_parcode['Omschrijving'])
    GH_list = list(df_FEWS_grootheid['Code'])
    
    iter_jaar = 0
    for file in toetsing_files:
        bestandstype = [key for key in mapping_name_taxontype.keys() if key in file.stem]
        logger.info('Start processing {}'.format(file))
        df_toets = pd.read_csv(file,sep = ';',dtype={'Kwaliteitsoordeel.code': object})
        df_toets['Toetsdatumtijd_new'] = [datetime(date.year,12,31,23,59) for date in pd.to_datetime(df_toets['Begindatum'])]
        df_toets['taxontype'] = mapping_name_taxontype[bestandstype[0]]
        df_toets.loc[df_toets['Eenheid.code'].isnull(),'Eenheid.code'] = 'DIMSLS'
        df_toets['Toetswaarde'] = ['TTSWDE' + '[' + eenheid + ']' for eenheid in df_toets['Eenheid.code']]
        df_toets['Toetsoordeel'] = 'TTSODL[DIMSLS]'
        
        #Convert alphanumeric values
        df_toets = UtilsEFCIS.convert_alphanumeric(df_toets,'Toetsoordeel','Alfanumeriekewaarde')
        
        #Sort dataframe on sample-ids
        df_toets = sort_dataframe(df_toets,'Monster.lokaalID')
                
         #Maak aparte kolommen Resultaatdatum en Resultaattijd om als valueproperties in FEWS te importeren.
        df_toets['Resultaatdatum_fews'] = [datumtijd.date().strftime('%Y-%m-%d') for datumtijd in pd.to_datetime(df_toets['Begindatum'],format='%Y-%m-%d')]
        df_toets['Resultaattijd_fews']  = [datumtijd.time().strftime('%H:%M:%S') for datumtijd in pd.to_datetime(df_toets['Begindatum'],format='%Y-%m-%d')]
        
        df_toets  = UtilsEFCIS.movecolumndf(df_toets,TP_list,'Grootheid.code','Typering.code')
        df_toets  = UtilsEFCIS.movecolumndf(df_toets,PAR_OMS,'Biotaxon.naam','Parameter.omschrijving')
        df_toets.loc[~df_toets['Biotaxon.naam'].isnull(),'taxonnaamtype'] = df_toets['Biotaxon.naam'] + '_' + df_toets['taxontype']
        
        #Filter het bestand op records waar Monster.lokaalID leeg is: deze wordt apart geïmporteerd in FEWS
        df_toets_no_sample = df_toets[df_toets['Monster.lokaalID'].isnull()]
        df_toets_no_sample.to_csv(file.parent / Path('without sampleid ' + file.stem + '.csv'),index=False,sep=';')        
        
        #Filter empty Monster.lokaalID
        df_toets_with_sample = df_toets[~df_toets['Monster.lokaalID'].isnull()]

        #Voeg taxontype toe
        df_toets = UtilsEFCIS.add_postfix_importbestand(df_toets_with_sample, 'Monster.lokaalID', '_TOETS_{}'.format(mapping_name_taxontype[bestandstype[0]]))
        
        iter_jaar += 1
        df_toets_with_sample.to_csv(file.parent / Path('with sampleid ' + file.stem + '.csv'),index=False,sep=';')
    
    #%% KRW TOETSWAARDEN monitoringslocaties
    KRW_toetsing    = import_folder / 'jaarlijks'
    KRW_monitoringslocaties = [KRW_toetsing / file for file in KRW_toetsing.iterdir() if file.name.startswith('Toetsing KRWToetsResultaat monitoringslocaties')]
    
    for file in KRW_monitoringslocaties:
        logger.info('Start processing {}'.format(file))
        df_KRW = pd.read_csv(file,sep = ';')
        df_KRW.loc[df_KRW['Eenheid'].isnull(),'Eenheid'] = 'DIMSLS'
        df_KRW['Toetswaarde'] = ['TTSWDE' + '[' + eenheid + ']' for eenheid in df_KRW['Eenheid']]
        df_KRW['Toetsoordeel'] = 'TTSODL[DIMSLS]'
                
        #Voeg WNS code toe aan csv file gebasseerd op wns omschrijving
        df_KRW['wns_oms'] = df_KRW['ParameterTyperingCode'] + '[' + df_KRW['Eenheid'] + '][' + df_KRW['Hoedanigheid'] + '][' + df_KRW['CompartimentCode'] + ']'
        df_KRW['waarnemingssoort.code'] = df_KRW['wns_oms'].map(map_wnscode_oms)

        #Convert alphanumeric values
        df_KRW = UtilsEFCIS.convert_alphanumeric(df_KRW,'Toetswaarde','AlfaNumeriekeWaarde')

        #Maak aparte kolommen Resultaatdatum en Resultaattijd om als valueproperties in FEWS te importeren.
        df_KRW['Resultaatdatum_fews'] = [datumtijd.date().strftime('%Y-%m-%d') for datumtijd in pd.to_datetime(df_KRW['BeginDatum'],format='%Y-%m-%d')]
        df_KRW['Resultaattijd_fews']  = [datumtijd.time().strftime('%H:%M:%S') for datumtijd in pd.to_datetime(df_KRW['BeginDatum'],format='%Y-%m-%d')]
 

        #Er staan typeringen in de kolom Grootheid.code, deze worden verplaatst naar tyerping kolom.
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,TP_list,'ParameterTyperingCode','Typering.code')
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,PC_list,'ParameterTyperingCode','Parameter.code')
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,GH_list,'ParameterTyperingCode','ToetsGrootheidCode')

        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,PC_list,'ToetsParameterCode','Parameter.code')
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,TP_list,'ToetsGrootheidCode','Typering.code')
        

        
        #Check dat de kolommen inderdaad leeg zijn (geen restant qualifiers achtergebleven die niet gemapped konden worden)
        UtilsEFCIS.check_empty_columns(df_KRW,['ParameterTyperingCode','ToetsParameterCode'],logger)        
        
        iter_jaar += 1
        df_KRW.to_csv(file,index=False,sep=';')

    if not(N_files_jaar == iter_jaar):
        logger.error('{} csv files where found in folder {}, but only {} processed based on wildcards'.format(N_files_jaar,str(bio_toetsing),iter_jaar))
        sys.exit(1)

        
    #%% KRW TOETSWAARDEN KRW waterlichamen
    KRW_waterlichamen    = import_folder / 'meerjarig'
    N_files_meerjaar     = len([file for file in KRW_waterlichamen.iterdir() if file.name.endswith('.csv')])
    KRW_waterlichamen    = [KRW_waterlichamen / file for file in KRW_waterlichamen.iterdir() if file.name.startswith('Toetsing KRWOordeel waterlichamen')]
    iter_meerjaar = 0
    for file in KRW_waterlichamen:
        logger.info('Start processing {}'.format(file))
        df_KRW = pd.read_csv(file,sep = ';',dtype={'KwaliteitCode': object})
        df_KRW = df_KRW[df_KRW['MonitoringSoort'] == 'OM_TT']
        df_KRW.loc[df_KRW['Eenheid'].isnull(),'Eenheid'] = 'DIMSLS'
        df_KRW['Toestandswaarde'] = ['TSTNDWDE' + '[' + eenheid + ']' for eenheid in df_KRW['Eenheid']]
        df_KRW['Toestandsoordeel'] = 'TSTNDODL[DIMSLS]'
        #Voeg WNS code toe aan csv file gebasseerd op wns omschrijving        
        df_KRW['wns_oms'] = df_KRW['ParameterTyperingCode'] + '[' + df_KRW['Eenheid'] + '][' + df_KRW['Hoedanigheid'] + '][' + df_KRW['CompartimentCode'] + ']'
        df_KRW['waarnemingssoort.code'] = df_KRW['wns_oms'].map(map_wnscode_oms)
                
        #Convert alphanumeric values
        df_KRW = UtilsEFCIS.convert_alphanumeric(df_KRW,'Toestandswaarde','AlfanumeriekeWaarde')
        
        #Maak aparte kolommen Resultaatdatum en Resultaattijd om als valueproperties in FEWS te importeren.
        df_KRW['Resultaatdatum_fews'] = [datumtijd.date().strftime('%Y-%m-%d') for datumtijd in pd.to_datetime(df_KRW['BeginDatum'],format='%Y-%m-%d')]
        df_KRW['Resultaattijd_fews']  = [datumtijd.time().strftime('%H:%M:%S') for datumtijd in pd.to_datetime(df_KRW['BeginDatum'],format='%Y-%m-%d')]
 
        #Er staan typeringen in de kolom ParameterTyperingCode, deze worden verplaatst naar tyerping kolom.
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,TP_list,'ParameterTyperingCode','Typering.code')
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,PC_list,'ParameterTyperingCode','Parameter.code')
        df_KRW  = UtilsEFCIS.movecolumndf(df_KRW,GH_list,'ParameterTyperingCode','Grootheid.code')
        
        #Check if all columns that are expected to be empty are empty
        UtilsEFCIS.check_empty_columns(df_KRW,['ParameterTyperingCode'],logger)        

        iter_meerjaar += 1
        df_KRW.to_csv(file,index=False,sep=';')
    
    if not(N_files_meerjaar == iter_meerjaar):
        logger.error('{} csv files where found in folder {}, but only {} processed based on wildcards'.format(N_files_meerjaar,str(import_folder / 'meerjarig'),iter_meerjaar))
        sys.exit(1)
#%%
def main(argv):
    config_dir = Path(argv[0])
    import_dir = Path(argv[1])
    log_dir    = Path(argv[2])
    loghistorydir = log_dir / 'loghistory'

    log_dir.mkdir(exist_ok=True)
    loghistorydir.mkdir(exist_ok=True)
    
    logger = UtilsEFCIS.set_up_logging(log_dir / 'log_PreProToetsing_EFCIS.txt',
                                      loghistorydir / 'log_PreProToetsing_EFCIS.txt', logging.DEBUG)

    logger.info('Starting preprocessing import files EFCIS')
    logger.info('Config directory : {}'.format(config_dir))
    logger.info('Import directory : {}'.format(import_dir))
    
    try:
        preprocessing(config_dir,import_dir, logger)
        logger.info('Succesfully finished script PreProImportToetsing_EFCIS.py')
        UtilsEFCIS.flush_close_logging(logger)        
    except Exception as e:
        logger.error('Something whent wrong in preprocessing script')
        logger.error('{}'.format(e)) 
        UtilsEFCIS.flush_close_logging(logger)
        sys.exit(1)

#%%
if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1:])
    else:
        args = [r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/Config',
                r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/tofss/Import/Toetsing',
                r'D:\FEWSProjects\FEWS-EFCIS_HKV\branches\2021-01-test\FEWS\fromfss\ImportPrePro_Logging'
                 ]
        main(args)     
    





