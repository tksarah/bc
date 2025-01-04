#!/bin/bash

# Input identity data from polkadot.js.org/apps/#/chainstate
file='./id_data.txt'

# 検索するパターン
pattern=$1

# grepでマッチした行番号を取得し、その後40行を出力
grep -n "$pattern" "$file" | while IFS=: read -r line_num _; do
  raw_value=$(awk "NR>$line_num && NR<=($line_num+40)" "$file" | awk '/display:/{flag=1} flag && /Raw:/{print $2; flag=0}')
  if [ -n "$raw_value" ]; then
    #echo "$pattern,$raw_value"
    echo "$raw_value"
  fi
done

