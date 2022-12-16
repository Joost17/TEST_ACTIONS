import pandas as pd
import chardet
import csv
from pathlib import Path

config_dir = Path('Config')

def get_delimiter(file_path: str) -> str:
    with open(file_path, 'r') as csvfile:
        delimiter = str(csv.Sniffer().sniff(csvfile.read()).delimiter)
        return delimiter
    
def test_seperator_maplayerfiles():
    for file in (config_dir / 'MapLayerFiles/Qualifiers').glob('*.csv'):
        delim = get_delimiter(file)
        assert delim ==';'
        
