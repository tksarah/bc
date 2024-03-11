#!/bin/bash

# Data file name
file="data"

# Save directory 
SDIR="./save"

### Run
echo -n "Run script -> "
perl ./script.pl
echo "Done script"
echo -n "Run amount -> "
perl ./amount.pl ./$file
echo "Done amount"
echo -n "Run combine -> "
perl ./combined.pl
echo "Done combine"

# Get timestamp of source file
timestamp=$(date -r "$file" +"%Y%m%d%H%M%S")

# Save file name
sfile="${timestamp}-${file}.csv"

### Copy (From WSL to Win11)
echo -n "Run copy to Desktop -> "
cp ./$file.csv /mnt/c/Users/sarah/Desktop/
echo "Done copy"

### Save org data file
echo -n "Run save data -> "
cp -p ./$file.csv  $SDIR/$sfile
(cd $SDIR; tar czf $sfile.tar.gz $sfile )
touch ./$file
echo "Done save"

### Cleanup
echo -n "Run cleanup -> "
rm $SDIR/$sfile chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv data
echo "Done cleanup"
touch data
