# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 13:24:40 2020

@author: driebergen

"""
#%%
import pandas as pd
import sys
from pathlib import Path

def main(argv):
    input_file = Path(argv[0])
    df = pd.read_csv(input_file,sep=';')
    
    #Preprocessing
    df['SampleID'] = 'test'
    
    outfile = input_file.stem + '_processed.csv'
    df.to_csv(outfile,header=True, index=False, sep=';', encoding="utf-8-sig")

if __name__ == "__main__":
    if len(sys.argv)>1:
        main(sys.argv[1:])
    else:  
        args = [r'D:/FEWSProjects/FEWS-EFCIS_HKV/branches/2021-01-test/FEWS/tofss/Import/SampleData']
        main(args)
      

