import pandas as pd
import chardet

#Read output of preprocessing
file_fc        = r'tests/testfiles/FC_test.csv'
df_FC          = pd.read_csv(file_fc,sep=';')
file_fc_prepro = r'tests/testfiles/FC_test_processed.csv'
df_FC_prepro   = pd.read_csv(file_fc,sep=';')


def test_dtypes():
    df_FC.dtypes['Kwaliteitsoordeel.code'] == object

def test_encoding():
    with open(file_fc_prepro, 'rb') as rawdata:
        result = chardet.detect(rawdata.read(100000))
    assert result['encoding'] == 'UTF-8-SIG'

def test_length():
    assert len(df_FC) == len(df_FC_prepro)