#!/bin/bash

# Data file name
file="../store/data"
# tiers data file name
json="../store/tiers.json"

# Save directory 
SDIR="../store/save"

# docs directory 
DOCS="../docs"

### Run
echo -n "Run script -> "
perl ./script.pl
echo "Done"

echo -n "Run amount -> "
perl ./amount.pl $file
echo "Done"

echo -n "Run combine -> "
perl ./combined.pl
echo "Done"

echo -n "Run update Tier -> "
perl ./update_tier.pl $json index.org index.html
echo "Done"

# Get timestamp of source file
timestamp=$(date -r "$file" +"%Y%m%d%H%M%S")

# Save file name
sfile="${timestamp}-data.csv"

### Copy 
echo -n "Run copy to Desktop ->" 
cp $file.csv /mnt/c/Users/sarah/Desktop/
echo "Done"

echo -n "Run copy to DOCS -> "
cp $file.csv index.html $DOCS/
echo "Done"

echo -n "Run save data -> "
cp -p $file.csv  $SDIR/$sfile
echo "Done"

### Save org data file
echo -n "CSV Data saving -> "
(cd $SDIR; tar czf $sfile.tar.gz $sfile )
echo "Done"

### Cleanup
echo -n "Run cleanup -> "
rm $file $file.csv $SDIR/$sfile chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv after_voting.csv index.html
# Leave api_data.csv
#rm $file $file.csv $SDIR/$sfile chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json after_voting.csv index.html
echo "Done"
touch $file
