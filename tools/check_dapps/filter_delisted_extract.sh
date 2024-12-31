#!/bin/bash

# JSONファイルとCSVファイルのパスを指定します
json_file="chaindapps.json"
csv_file="api_data.csv"
temp_file="temp_addresses.txt"
output_file="result.csv"

# script.pl を実行して chaindapps.json を生成します
perl script.pl

# jq を使用して、state が "Registered" でない contractAddress を抽出します
jq -r '.[] | select(.state | ascii_downcase != "registered") | .contractAddress' "$json_file" | tr '[:upper:]' '[:lower:]' > "$temp_file"

# 抽出された contractAddress に基づいて、api_data.csv の該当行を出力します（大文字小文字を区別せず）
awk -F',' '
NR==FNR {addresses[tolower($1)]; next}
tolower($1) in addresses
' "$temp_file" "$csv_file" > "$output_file"

# 一時ファイルを削除します
rm "$temp_file"
rm dappssimple.json dappssimple.csv chaindapps.json chaindapps.csv

echo "Done: $output_file"

