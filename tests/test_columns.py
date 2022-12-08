import pandas as pd

#Read output of preprocessing
df_FC = pd.read_csv(r'tests/testfiles/FC_test_processed.csv',sep=';')

def test_unique_sampleID():
    assert df_FC.columns[0] == 'ID'