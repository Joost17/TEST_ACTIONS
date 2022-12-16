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

def main(argv):
    input_file = Path(argv[0])
    df_FC      = pd.read_csv(input_file,sep=';',dtype={'Kwaliteitsoordeel.code': object})
    df_FC      = df_FC.convert_dtypes(convert_string=False)
    df_FC      = sort_dataframe(df_FC, 'Monster.lokaalID')
    
    #Preprocessing
    
    outfile = Path(r'tests/testfiles') / (input_file.stem + '_processed.csv')
    print('Writing outputfile {}'.format(outfile))
    df_FC.to_csv(outfile,header=True, index=False, sep=';', encoding="utf-8-sig")

if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1:])
    else:  
        args = [r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/tofss/Import/SampleData']
        main(args)
      

