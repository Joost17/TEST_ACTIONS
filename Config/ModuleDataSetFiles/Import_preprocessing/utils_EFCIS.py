 # -*- coding: utf-8 -*-
"""
@author: Joost Driebergen
"""

import logging
from logging import handlers
import chardet
import pandas as pd
import numpy as np
import sys
import shutil
import os
class Utils:
    @staticmethod
    def set_up_single_logging(logfile, level):
        logger = logging.getLogger('logger')
        logger.setLevel(level)
    
        current_log_handler = logging.FileHandler(filename=logfile, mode='w')
        current_log_handler.setFormatter(Utils.get_formatter())
        logger.addHandler(current_log_handler)
        return logger

    @staticmethod
    def set_up_logging(logfile, loghistoryfile, level):
        logger = Utils.set_up_single_logging(logfile, level)
        history_log_handler = handlers.RotatingFileHandler(loghistoryfile, maxBytes=10000000, backupCount=5)
        history_log_handler.setFormatter(Utils.get_formatter())
        logger.addHandler(history_log_handler)
        return logger

    @staticmethod
    def flush_close_logging(logger):
        logging.shutdown()
        logger.handlers.clear()

    @staticmethod
    def get_handler(logfile):
        current_log_handler = logging.FileHandler(filename=logfile, mode='w')
        current_log_handler.setFormatter(Utils.get_formatter())
        return current_log_handler

    @staticmethod
    def get_formatter():
        fmt = r'%(asctime)s %(levelname)s: %(message)s'
        dfmt = r'%Y-%m-%d %H:%M:%S'
        return logging.Formatter(fmt, datefmt=dfmt)
    
    def capatilize_str_pattern(listofstrings,listofpatterns):
        """
        Function to capitalize the first letter after a pattern (listofpatterns)
        """
        import re
        newlist = []
        patterns = ''.join([pattern+'|' for pattern in listofpatterns])[0:-1]
        for s in listofstrings:
            #Find all matches and positions for input patterns
            matches = re.finditer(patterns, s)
            matches_positions = [match.start() for match in matches]
            #Replace each letter after the pattern with a capitalize version
            for idx in matches_positions:
                index = idx + 1
                s = s[:index] + s[index].capitalize() + s[index + 1:]
            newlist.append(s)
        return newlist    
    
    def replace_value(df,col,mapping,dtype):
        """
        Function to apply a mapping to a column.
        First de dtype is convert to dtype.
        This is because if for example the column is empty and we try to replace with a string, we get an error trying to replace int with string
        """
        df = df.astype({col:dtype})
        df = df.replace({col:mapping})
        return df
    
    def convert_alphanumeric(df,parcol,anumcol):
        """
        Function that preprocesses alphanumeric values such that they can be imported according to the definition in Config file Parameters.xml
        """
        #Step1: Apply mapping for specific strings
        mapping_classificatie = {'Nietnatuur':'Niet natuurlijk','Voorovropngn':'Vooroever openingen','Nvt':'Niet van toepassing',
                                 'NIET BEMON':'Niet bemonsterde kant','BACTVLIES':'Bacterievlies','BRUINTROEB':'Bruin troebel'
                                 }
        #Pas alleen stappen toe als de waarde van kolom geen int/float is 
        if not(anumcol in df.select_dtypes(include=['int64','float64'])):
            #Step1: Make subset
            dfsubset = df.loc[~(df[anumcol].isnull())]
            #Step2: capitalize first letter of each string
            df.loc[dfsubset.index,anumcol] = dfsubset[anumcol].str.capitalize()
            #Step3: Pas mapping toe voor paar specifieke alfanumerieke waarden
            df = Utils.replace_value(df,anumcol,mapping_classificatie,object)
            #Step4: Replace every character after a - or / with a capital, except for parameter ISOLTE[DIMSLS]
            df.loc[(df.index.isin(dfsubset.index)) & ~(df[parcol] == 'ISOLTE[DIMSLS]'),anumcol] = \
                Utils.capatilize_str_pattern(df.loc[(df.index.isin(dfsubset.index)) & ~(df[parcol] == 'ISOLTE[DIMSLS]')][anumcol],['-','/'])
        return df
    
    def read_pandas_csv(file,sep,logger):
    
        """ 
        Function to read csv file into pandas dataframe.
        Encoding is retrieved by the package chardet
        """
        logger.debug('Reading file {}'.format(file))
        with open(file, 'rb') as rawdata:
            result = chardet.detect(rawdata.read(100000))
        logger.debug('Retrieved encoding:{} for file {}'.format(result['encoding'],file))
        
        df = pd.read_csv(file,encoding = result['encoding'],sep=sep)
        return df
    
    def make_sampleid_unique(df,col_loc,col_datetime,col_sampleid,col_sampleid_new):
        """
        Functie om, indien nodig, sampleid uniek te maken tov locatie kolom en datum kolom
        """
        df = df.sort_values(by=[col_datetime,col_loc])
        uniek_Sample = df[col_sampleid].unique()
        for sampleid in uniek_Sample:
            selectie = df[df[col_sampleid] == sampleid]
            selectie_unique = selectie[[col_loc,col_datetime,col_sampleid]].drop_duplicates()
            if len(selectie_unique)>1:
                postfix = 1
                for loc,datetime in zip(selectie_unique[col_loc],selectie_unique[col_datetime]):
                    df.loc[(df[col_loc] == loc) & (df[col_datetime]==datetime),col_sampleid_new] = sampleid + '_' + str(postfix)
                    postfix+=1
            else:
                df.loc[df[col_sampleid] == sampleid,col_sampleid_new] = sampleid
        return df
    
    def add_postfix_importbestand(df,sampleidcolumn,postfix):
        """
        Adds a string postfix to all records in column sampleidcolumn in df
        """
        df[sampleidcolumn] = df[sampleidcolumn].astype(str)
        df.loc[~df[sampleidcolumn].str.endswith(postfix),sampleidcolumn] = \
            [str(sampleid) + postfix for sampleid in  df.loc[~df[sampleidcolumn].str.endswith(postfix)][sampleidcolumn].values]
        return df
    
    def movecolumndf(df,liststrings,srccol,dstcol):
        """
        Function to move al strings in srccol which are in liststrings to dstcol
        al strings which are in liststrings in srccol are set empty : ''
        """
        df.loc[df[srccol].isin(liststrings),dstcol] = df[srccol]
        df.loc[df[srccol].isin(liststrings),srccol] = np.nan
        return df

    def check_nan_empty_str(val):
        """
        Function to check if value is nan or empty string ''
        """
        if not(type(val) == str):
            return np.isnan(val)
        else:
            if val == '':
                return True
            else:
                return False

    def replace_values_dict(dictin,targetdict):
        """"
        Function to replace values in dictin if value is in targetdict
        """
        dictout = {}
        for key, val in dictin.items():
            if val in targetdict.keys():
                dictout[key] = targetdict[val]
            else:
                dictout[key] = val
        return dictout

    def log_params_niet_bemeten(filename,df,parcol,df_FEWS_par,nietbemcol,failedfolder,logger):
        """
        Function to check if there are values in df[parcol] that have attribute FewsParGroup nietbemcol in df_FEWS_par
        Returns
            samples_failed: List of samples that contains records with parcol == nietbemcol
        """
        subset = df_FEWS_par[(df_FEWS_par['Parameter_Code'].isin(df[parcol].unique())) & (df_FEWS_par['FewsParGroup'] == nietbemcol)]
        subset2 = df[df[parcol].isin(subset['Parameter_Code'])]
        if subset.empty:
            return []
        logger.error('{} contains parameters in FewsParGroup {}'.format(filename.stem,nietbemcol))
        #logger.error('Moving file {} to folder {}'.format(filename.stem,failedfolder))
        #shutil.copy(filename,failedfolder / filename.name)
        #os.remove(filename)
        for idx,row in subset2.iterrows():
            logger.error('{} line nr {} FewsParGroup of {} is equal to {}'.format(filename.stem,idx,row[parcol],nietbemcol))

        return list(subset2['Monster.lokaalID'].unique())
        #sys.exit(1)



    
    def check_empty_columns(df,cols,logger):
        """
        Function to check if columns are empty
        if not empty, log error and return exit code 1

        """
        for col in cols:
            if not(df[col].isnull().all()):
                df_restant = df[~df[col].isnull()]
                for idx,row in df_restant.iterrows():
                    logger.error('Qualifier {} could not be mapped but is still present in column {} (line number {})'.format(row[col],col,idx))
                sys.exit(1)
    
    
#%%


