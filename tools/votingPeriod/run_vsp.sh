#!/bin/bash

# Current period number
# Edit required before running
period=5

# Data from https://polkadot.js.org/apps/#/chainstate
# dappStaking.contractStake: PalletDappStakingContractStakeAmount
file="data"

# Save file name
sfile="vsp_data.csv"

DIR="../../docs/vsp"

###
# IN from API
# Out api_data.csv, etc
### Run
echo -n "Run script -> "
perl ./script.pl
echo "Done"

###
# IN ./data <- on chain data
# Out voting_period.csv
echo -n "Run vsp_amount.pl -> "
perl ./vsp_amount.pl $file $period
echo "Done"

# IN ./voting_period.csv
# IN ./api_data.csv <- from runing ./script.pl
# OUT ../../docs/vsp/vsp_data.csv
echo -n "Run vsp_combine.pl -> "
perl ./vsp_combine.pl
echo "Done"
###

# Update index.html
echo -n "Run update html -> "
perl ./update_html.pl index.org index.html
echo "Done"

# Fixing the incorrect string
# "ApeXChimpz (*******************)",nft,76,1598439.339
sed -i 's/"ApeXChimpz \(.*\)",\(.*\),\([0-9]*\),\([0-9]*\.[0-9]*\)/"ApeXChimpz",\2,\3,\4/' $sfile 

# Copy
echo -n "Run copy to DOCS -> "
cp -p $sfile index.html $DIR/
echo "Done"

### Cleanup
echo -n "Run cleanup -> "
rm chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv voting_period.csv vsp_data.csv index.html data
#rm chaindapps.csv chaindapps.json dappssimple.csv dappssimple.json api_data.csv voting_period.csv index.html data
touch data
echo "Done"
