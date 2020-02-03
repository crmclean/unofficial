#!/Users/craigmclean/miniconda3/bin/python3

import os
import json
import re

curDir = os.getcwd()
newDir = os.chdir("../../data/2020-02-02/gov_agency_aid_numbers")


output = "Agency_AID_table.txt"

files = [f for f in os.listdir('.') if os.path.isfile(f)]
for f in files:

    
    fileSub = re.sub("gov_index_", "",f) 
    fileSub = re.sub(".txt", "", fileSub)
    with open(f) as json_file:
        data = json.load(json_file)
        outlist = [fileSub, data['results']['agency_name']] 
    
    json_file.close()
    
    with open (output, "a+") as writeFile:
        writeFile.write('\t'.join(outlist))
        writeFile.write("\n")
    writeFile.close()
                
 
os.chdir(curDir)

