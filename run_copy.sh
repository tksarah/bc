#!/bin/bash

### Backup data file
#cp data "data_$(data +%Y-%m-%d)"

### Run
perl ./script.pl
echo "Done script"
perl ./amount.pl ./data
echo "Done amount"
perl ./combined.pl
echo "Done combine"

### Copy (From WSL to Win11)
cp ./comp.csv /mnt/c/Users/sarah/Desktop/
echo "Done copy"

### Change csv file name 
mv ./comp.csv ./data.csv

### Cleanup
rm chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv 
echo "Done cleanup"
