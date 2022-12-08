import pandas as pd

def check_unique_sampleID():
    df = pd.read_csv('FC_test.csv',sep=';')
    assert df.columns[0] == 'ID'