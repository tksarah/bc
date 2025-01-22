#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;

# URLからJSONデータを取得
my $url = "https://api.astar.network/api/v3/astar/dapps-staking/rewards/1%20day?transaction=DAppReward";
my $json_text = get($url);

# JSONデータをデコード
my $data = decode_json($json_text);

# はじめの era を取得
my $current_era = $data->[0]->{era};

print "$current_era\n";

