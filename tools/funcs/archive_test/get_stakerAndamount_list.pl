#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';

# 新しいCSVモジュールを使用するための準備
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# CSVファイルを開く
open my $fh, "<:encoding(utf8)", "dapps_list.dat" or die "dapps_list.dat $!";

# CSVファイルのヘッダーを読み飛ばす
$csv->getline($fh);

while (my $row = $csv->getline($fh)) {
    my ($address, $name, $mainCategory) = @$row;

    # APIのURLを組み立てる
    my $url = "https://api.astar.network/api/v3/astar/dapps-staking/stakerslist/$address";
    my $json_text = get($url);

    # JSONをデコードする
    my $data = decode_json($json_text);

    # データを金額でソートする
    my @sorted_data = sort { $b->{amount} <=> $a->{amount} } @$data;

    # 結果を保存するファイル名を生成する
    my $timestamp = strftime "%Y-%m-%d-%H", localtime;
    my $filename = $timestamp . "_" . $name . ".csv";
    $filename =~ s/\s/_/g;
    $filename =~ s/:/-/g;
    $filename =~ s/,/_/g;
    $filename =~ s/\(/_/g;
    $filename =~ s/\)/_/g;
    $filename =~ s/\|/_/g;

    # 結果を保存するファイルを開く
    open my $output_fh, ">:encoding(utf8)", $filename or die "$filename: $!";

    # ヘッダーを出力
    print $output_fh "stakerAddress, amount\n";

    # 各データ項目を出力
    foreach my $item (@sorted_data) {
        my $value = $item->{amount}/1000000000000000000;
        my $formatted_value = sprintf("%.3f", $value);
        print $output_fh "$item->{stakerAddress}, $formatted_value\n";
    }

    close $output_fh;

}

close $fh;

