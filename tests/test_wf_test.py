import pandas as pd
import chardet

#Read output of preprocessing
file_BIO        = r'tests/testfiles/Diatomeeen_test.csv'
df_BIO          = pd.read_csv(file_BIO,sep=';')
file_BIO_prepro = r'tests/testfiles/Diatomeeen_test_processed.csv'
df_BIO_prepro   = pd.read_csv(file_BIO_prepro,sep=';')

wftestrunlog = 'wf_testrun/log.txt'


def test_errors():
    with open(wftestrunlog) as file:
        for line in file:
            print(line)
            assert (not('ERROR' in line))