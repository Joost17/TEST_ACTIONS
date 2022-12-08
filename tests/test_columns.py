import pandas as pd

def test_dummy():
	df = pd.read_csv('FC_test.csv',sep=';')
    assert df.columns[0] == 'ID'
	assert df.columns[1] == 'code'
