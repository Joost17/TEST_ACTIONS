import pandas as pd

def test_unique_sampleID():
    df = pd.read_csv('FC_test.csv',sep=';')
    assert df.columns[0] == 'ID'