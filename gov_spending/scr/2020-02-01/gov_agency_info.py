#!/Users/craigmclean/miniconda3/bin/python3

import requests
import json
import re

## python3 script used to gather information to link agencies and AID numbers

endpoint = "https://api.usaspending.gov/api/v2/references/agency/"

## outer for loop - used to enter different agency codes to api 
for i in list(range(0,1500)):
    
    #print(endpoint + str(i))

    ## function used to query API
    response = requests.get(endpoint + str(i))

    ## checks to see if good API query was used
    print("Number did match")
    if response.status_code == 400:
         print("Note Found.")           
         continue
    elif response.status_code == 200:
         print("Success!")

    ## checks if API returned valid info for an agency
    if bool(re.search('{"results":{}}', response.text)) == True:
        print("AID Number did not Match an Agency")
        continue
   
    print(json.dumps(response.json(), indent = 4, sort_keys=True))

    jsonOut = "gov_index_" + str(i) + ".txt"

    with open(jsonOut, 'w') as json_file:
      json.dump(response.json(), json_file)

