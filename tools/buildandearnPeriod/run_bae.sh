#!/bin/bash

DIR="../../docs/rank"
SDIR="../../store/Period2_data"

echo "Run get_stakerAndamount_list.pl -> "
perl ./get_stakerAndamount_list.pl
echo "Done"

# Update index.html
echo -n "Run update html -> "
perl ./update_html.pl index.org index.html
echo "Done"

# Check Rank
mv *_TotalAmount.csv TotalAmount.csv
perl ./rank.pl

# Copy & Gzip & Move
echo -n "Run copy & gzip & move  -> "
cp -p TotalAmount.csv $DIR/TotalAmount.csv
gzip TotalAmount.csv 
mv TotalAmount.csv.gz $SDIR/

cp -p index.html $DIR/
echo "Done"

### Cleanup
echo -n "Run cleanup -> "
rm *.csv index.html 
echo "Done"
