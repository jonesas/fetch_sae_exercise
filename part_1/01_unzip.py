# I ran these block by block in a Jupyter notebook in order to get a look at the data and unzip and fix one file 

import gzip
import pandas as pd
import os

fn = 'C:/Users/Austin/Downloads/receipts.json.gz'
print(os.path.isfile(fn))
df = pd.read_json(fn, lines=True, compression='gzip')
df.head()


# users.json.gz one was giving me an error so I unzipped it and opened up the json 
# file in VS Code and there were some extra characters at the start and end of the 
# file and once I removed those it ran successfully
with gzip.open('C:/Users/Austin/Downloads/users.json.gz', 'rb') as f_in:
    with open('C:/Users/Austin/Downloads/users.json', 'wb') as f_out:
        f_out.write(f_in.read())

fn = 'C:/Users/Austin/Downloads/users.json'
print(os.path.isfile(fn))
df = pd.read_json(fn, lines=True)
df.head()


fn = 'C:/Users/Austin/Downloads/brands.json.gz'
print(os.path.isfile(fn))
df = pd.read_json(fn, lines=True, compression='gzip')
df.head()