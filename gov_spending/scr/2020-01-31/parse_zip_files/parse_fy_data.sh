#!/bin/bash


### AIMS: this file is deisgned to read in the entire grant data from US government spending and return a two column table with money/agency info for each year. 

## Setting the parent directory to run the script 

origDir=~/Documents/unofficial/gov_spending/data/2020-01-31/
## outloop through FY20XX files 

#echo $(ls $origDir)
filePath="${origDir}*"

for i in $filePath 
do
  echo $i

  if test -e "$i"; then
    mkdir cur_files
    unzip $i
    mv *.csv cur_files
    Rscript parse_single_year_FY_data.R 
    rm -r cur_files

  fi

done


 

