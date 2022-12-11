import pandas as pd
import chardet

#Read output of preprocessing
file_BIO        = r'tests/testfiles/Diatomeeen_test.csv'
df_BIO          = pd.read_csv(file_BIO,sep=';')
file_BIO_prepro = r'tests/testfiles/Diatomeeen_test_processed.csv'
df_BIO_prepro   = pd.read_csv(file_BIO_prepro,sep=';')


def test_dtypes():
    df_BIO.dtypes['Leverancier_Code'] == object

def test_encoding():
    with open(file_BIO_prepro, 'rb') as rawdata:
        result = chardet.detect(rawdata.read(100000))
    assert result['encoding'] == 'UTF-8-SIG'

def test_length():
    assert len(df_BIO) == len(df_BIO_prepro)

def test_sampleID_unique():
    assert len(df_BIO_prepro) == len(df_BIO_prepro.drop_duplicates(subset=['Meetobject.code', 'Collectie_Datum','Collectie_Datum','Sample_Id_FEWS']))
