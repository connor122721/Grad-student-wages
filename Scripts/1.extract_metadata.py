# Adapted from: https://web.mit.edu/julianst/www/phdstipends/stipends.html
# 11.8.2022 Connor S. Murray
# module load anaconda/2020.11-py3.8; python3

# Modules
import requests
import json
import os
import pandas as pd

# Working directory
os.chdir("/project/berglandlab/connor/")

# Empty object
full_stipends = []
reqlimit = 1000

# Go throgh each page
for i in range(0, reqlimit):
    data = requests.get(f'https://www.phdstipends.com/data/{i}').json()['data']
    for entry in data:
        full_stipends.append(entry)

    # Gather data from phdstipends pages until the pages no longer return data
    if len(data) < 1:
        break

# Write to CSV file
pd.DataFrame(full_stipends).to_csv("stipends.csv")
