#!/bin/bash

DIR="../../docs/rank"
SDIR="../../store/Period2_data"

echo -n "Run get_stakerAndamount_list.pl -> "
perl ./get_stakerAndamount_list.pl
echo "Done"

# Update index.html
echo -n "Run update html -> "
perl ./update_html.pl index.org index.html
echo "Done"

# Copy & Gzip & Move
echo -n "Run copy & gzip & move  -> "
cp -p *_TotalAmount.csv $DIR/TotalAmount.csv
gzip *_TotalAmount.csv 
mv *_TotalAmount.csv.gz $SDIR/

cp -p index.html $DIR/
echo "Done"

### Cleanup
echo -n "Run cleanup -> "
rm *.csv index.html 
echo "Done"
