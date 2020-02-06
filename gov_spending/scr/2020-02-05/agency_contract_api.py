#!/Users/craigmclean/miniconda3/bin/python3

# I would like to loop through each row of the agency info
# and store all information involved in transactions of contracts
# for a given agency

import pandas as pd
import requests
import json
import re

## loading in data
data = pd.read_csv("../../data/2020-02-02/Agency_AID_table.txt",sep = "\t", header = None)
data.columns = ['AID','Agency']

for index, row in data.head(n=50).iterrows():
    curAid = row["AID"]
    
    response = requests.get('https://api.usaspending.gov/api/v2/award_spending/recipient/',
            params = {'awarding_agency_id':str(curAid),
                'fiscal_year':'2019'})
    
    if response.status_code == 200:
        print('Success!')
    elif response.status_code == 400:
        print('Not Found.')
        continue

    if bool(re.search('"results": \[]', response.text)):
        print("AID Number did not have spending data")
        continue

    print(json.dumps(response.json(), indent = 4, sort_keys = True))
