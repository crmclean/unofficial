#!/Users/craigmclean/miniconda3/bin/python3

import requests

## sending get request
response = requests.get('https://api.usaspending.gov/api/v2/award_spending/recipient/',
        params={'fiscal_year':'2016', 'awarding_agency_id':'183'})

#&awarding_agency_id=183'


if response.status_code == 200:
    print('Success!')
elif response.status_code == 404:
    print('Not Found.')
elif response.status_code == 400:
    print('Not Found.')
