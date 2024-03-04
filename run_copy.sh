#!/bin/bash

### Backup data file
#cp data "data_$(data +%Y-%m-%d)"

### Run
echo -n "Run script -> "
perl ./script.pl
echo "Done script"
echo -n "Run amount -> "
perl ./amount.pl ./data
echo "Done amount"
echo -n "Run combine -> "
perl ./combined.pl
echo "Done combine"

### Copy (From WSL to Win11)
echo -n "Run copy to Desktop -> "
cp ./data.csv /mnt/c/Users/sarah/Desktop/
echo "Done copy"

### Cleanup
echo -n "Run cleanup -> "
rm chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv 
echo "Done cleanup"
