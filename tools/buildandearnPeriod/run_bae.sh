#!/bin/bash

DIR="../../docs/rank"

echo -n "Run get_stakerAndamount_list.pl -> "
perl ./get_stakerAndamount_list.pl
echo "Done"

# Update index.html
echo -n "Run update html -> "
perl ./update_html.pl index.org index.html
echo "Done"

# Copy
echo -n "Run copy to DOCS -> "
cp -p *_TotalAmount.csv $DIR/TotalAmount.csv
cp -p index.html $DIR/
echo "Done"

### Cleanup
echo -n "Run cleanup -> "
rm *.csv index.html 
echo "Done"
