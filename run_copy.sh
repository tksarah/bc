#!/bin/bash

# Get current date
current_date=$(date +"%Y%m%d_%H%M%S")
# Save directory 
SDIR="./save"
# Save file name
sfile="${current_date}_data"

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

### Save org data file
echo -n "Run save data -> "
mv ./data  $SDIR/$sfile
tar czf $SDIR/$sfile.tar.gz $SDIR/$sfile
touch ./data
echo "Done save"

### Cleanup
echo -n "Run cleanup -> "
rm $SDIR/$sfile chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv 
echo "Done cleanup"
