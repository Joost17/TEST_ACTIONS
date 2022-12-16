# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 13:24:40 2020

@author: driebergen

"""
#%%
import pandas as pd
import sys
from pathlib import Path
import chardet

def sort_dataframe(df,col_name):
    return df.sort_values(by = col_name)

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

def main(argv):
    #Only for FF
    input_file = Path(argv[0])
    dtypes_dict = {"Leverancier_Code":"object"}
    df_BIO      = pd.read_csv(input_file,sep=';',dtype=dtypes_dict)
    df_BIO      = df_BIO.convert_dtypes(convert_string=False)
    df_BIO      = make_sampleid_unique(df_BIO, 'Meetobject.code', 'Collectie_Datum','Collectie_Datum','Sample_Id_FEWS')
    #Preprocessing    
    outfile = Path(r'tests/testfiles') / (input_file.stem + '_processed.csv')
    print('Writing outputfile {}'.format(outfile))
    df_BIO.to_csv(outfile,header=True, index=False, sep=';', encoding="utf-8-sig")

if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1:])
    else:  
        args = [r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/tofss/Import/SampleData']
        main(args)
      

