#!/bin/bash

# Data file name
file="../store/data"

# Save directory 
SDIR="../store/save"

# docs directory 
DOCS="../docs"

### Run
echo -n "Run script -> "
perl ./script.pl
echo "Done script"
echo -n "Run amount -> "
perl ./amount.pl $file
echo "Done amount"
echo -n "Run combine -> "
perl ./combined.pl
echo "Done combine"

# Get timestamp of source file
timestamp=$(date -r "$file" +"%Y%m%d%H%M%S")

# Save file name
sfile="${timestamp}-data.csv"

### Copy 
echo -n "Run copy to Desktop ->" 
cp $file.csv /mnt/c/Users/sarah/Desktop/
echo -n "Run copy to DOCS -> "
cp $file.csv $DOCS/
echo -n "Run save data -> "
cp -p $file.csv  $SDIR/$sfile
echo "Done copy"

### Save org data file
echo -n "CSV Data saving -> "
(cd $SDIR; tar czf $sfile.tar.gz $sfile )
echo "Done save"

### Cleanup
echo -n "Run cleanup -> "
rm $file $file.csv $SDIR/$sfile chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv
echo "Done cleanup"
touch $file
