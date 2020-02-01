#!/Users/craigmclean/miniconda3/bin/python3
import json 
import requests

base = 'https://api.usaspending.gov'
end = '/api/v2/award_spending/recipient/' 
params = '?fiscal_year=2016&awarding_agency_id=183'
url = base + end + params
r = requests.get(url=url)
print(r.json())

#with open('get_data.txt', 'w') as outfile:
#    json.dump(r.json(), outfile)
