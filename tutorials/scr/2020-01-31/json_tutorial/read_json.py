#!/Users/craigmclean/miniconda3/bin/python3

import json

with open('gov_data_ex.txt') as json_file:
    data = json.load(json_file)
    print(data["fields"]) ## fileds is the name of an object within file
    #for p in data['filters']:
        #print('recipient_type_names: ' + p['recipient_type_names'])
        #print('Website: ' + p['website'])
        #print('From: ' + p['from'])
        #print('')
