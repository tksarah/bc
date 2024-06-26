#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';

# Output TotalAmount
my $total_amount = "TotalAmount.csv";

# 新しいCSVモジュールを使用するための準備
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# CSVファイルを開く
open my $fh, "<:encoding(utf8)", "dapps_list.dat" or die "dapps_list.dat $!";

# CSVファイルのヘッダーを読み飛ばす
$csv->getline($fh);

# Get timestamp
my $timestamp = strftime "%Y-%m-%d-%H", localtime;
$total_amount = $timestamp . "_" . $total_amount . ".csv";
# Open TotalAmount
open my $output_fh2, ">>:encoding(utf8)", $total_amount or die "$total_amount: $!";
print $output_fh2 "Name,Category,TotalStaked\n";

while (my $row = $csv->getline($fh)) {
    my ($address, $name, $mainCategory) = @$row;

    # 保存するファイル名を生成する-1
    my $filename = $timestamp . "_" . $name . ".csv";
    $filename =~ s/\s/_/g;
    $filename =~ s/:/-/g;
    $filename =~ s/,/_/g;
    $filename =~ s/\(/_/g;
    $filename =~ s/\)/_/g;
    $filename =~ s/\|/_/g;
    
    # for TotalAmount 
    my $sum = 0;

    # APIのURLを組み立てる
    my $url = "https://api.astar.network/api/v3/astar/dapps-staking/stakerslist/$address";
    my $json_text = get($url);

    # JSONをデコードする
    my $data = decode_json($json_text);

    # データを金額でソートする
    my @sorted_data = sort { $b->{amount} <=> $a->{amount} } @$data;

    ### FH
    open my $output_fh, ">:encoding(utf8)", $filename or die "$filename: $!";
    print $output_fh "stakerAddress, amount\n";

    # 各データ項目を出力
    foreach my $item (@sorted_data) {
        my $value = $item->{amount}/1000000000000000000;
        my $formatted_value = sprintf("%.3f", $value);
        print $output_fh "$item->{stakerAddress}, $formatted_value\n";

	$sum += $formatted_value;
    }
    close $output_fh;
    
    # For total amount
    print $output_fh2 "$name,$mainCategory,$sum\n";

}
close $fh;

close $output_fh2;


