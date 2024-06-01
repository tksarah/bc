#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;

my $value = 0;
my $CONT = "0x7672f18994d876a319502f356efea726c4354f39";
#my $CONT = $ARGV[0];

# URLからJSONデータを取得
my $url = "https://api.astar.network/api/v3/astar/dapps-staking/stakerslist/$CONT";
my $json_text = get($url);

# JSONデータをデコード
my $data = decode_json($json_text);

# データをamountの量で降順にソート
my @sorted_data = sort { $b->{amount} <=> $a->{amount} } @$data;

print "stakerAddress, amount\n";

# stakerAddressとamountを出力
foreach my $item (@sorted_data) {
    my $value = $item->{amount}/1000000000000000000;
    my $formatted_value = sprintf("%.3f", $value);
    print "$item->{stakerAddress}, $formatted_value\n";
}

