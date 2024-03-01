#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use JSON;
use Text::CSV;

# JSON ファイルをダウンロードして保存する関数
sub download_json {
    my ($url, $filename) = @_;
    my $content = get($url);
    open my $fh, '>', $filename or die "Could not open $filename: $!";
    print $fh $content;
    close $fh;
}

# JSON ファイルを読み込んで CSV ファイルに保存する関数
sub json_to_csv {
    my ($json_file, $csv_file, @fields) = @_;
    my $json_text = do {
        open(my $json_fh, "<:encoding(UTF-8)", $json_file)
            or die("Could not open \"$json_file\": $!\n");
        local $/;
        <$json_fh>
    };
    my $json = JSON->new;
    my $data = $json->decode($json_text);
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
    open my $fh, ">:encoding(utf8)", $csv_file or die "$csv_file: $!";
    $csv->say($fh, \@fields);
    foreach my $row (@$data) {
        my @values = map { $row->{$_} } @fields;
        $csv->say($fh, \@values);
    }
    close $fh or die "$csv_file: $!";
}

# JSON ファイルをダウンロードして CSV ファイルに保存
download_json('https://api.astar.network/api/v1/astar/dapps-staking/dappssimple', 'dappssimple.json');
json_to_csv('dappssimple.json', 'dappssimple.csv', 'address', 'name', 'mainCategory');

download_json('https://api.astar.network/api/v3/astar/dapps-staking/chaindapps', 'chaindapps.json');
json_to_csv('chaindapps.json', 'chaindapps.csv', 'contractAddress', 'dappId', 'stakersCount');

# CSV ファイルを読み込んで比較
my $csv1 = Text::CSV->new({ binary => 1, auto_diag => 1 });
my $csv2 = Text::CSV->new({ binary => 1, auto_diag => 1 });

open my $fh1, "<:encoding(utf8)", "dappssimple.csv" or die "dappssimple.csv: $!";
open my $fh2, "<:encoding(utf8)", "chaindapps.csv" or die "chaindapps.csv: $!";
open my $fh_out, ">:encoding(utf8)", "api_data.csv" or die "api_data.csv: $!";

my $header1 = $csv1->getline($fh1);
my $header2 = $csv2->getline($fh2);
$csv1->column_names(@$header1);
$csv2->column_names(@$header2);

my @rows1 = @{$csv1->getline_hr_all($fh1)};
my @rows2 = @{$csv2->getline_hr_all($fh2)};

$csv1->say($fh_out, ['address', 'name', 'mainCategory', 'dappId', 'stakersCount']);

my $cate;
foreach my $row1 (@rows1) {
    foreach my $row2 (@rows2) {
        if (lc $row1->{'address'} eq lc $row2->{'contractAddress'}) {
	    # For Nova Wallet and Lucky
            if ($row1->{'mainCategory'} eq ""){
		    $cate = "others";
	    }else{
		    $cate = $row1->{'mainCategory'}
	    }
            $csv1->say($fh_out, [$row1->{'address'}, $row1->{'name'}, $cate, $row2->{'dappId'}, $row2->{'stakersCount'}]);
        }
    }
}

close $fh1;
close $fh2;
close $fh_out;

