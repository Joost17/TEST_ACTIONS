import pandas as pd

def test_dummy():
    assert 1 == 0
    df = pd.read_csv('FC_test.csv',sep=';')
    assert df.columns[0] == 'ID'