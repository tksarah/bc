#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;

my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, eol => $/ });

# ファイルを開く
open my $fh1, "<:encoding(utf8)", "api_data.csv" or die "api_data.csv: $!";
open my $fh2, "<:encoding(utf8)", "after_voting.csv" or die "after_voting.csv $!";
open my $fh_out, ">:encoding(utf8)", "comp.csv" or die "comp.csv: $!";

# ヘッダー行を読み込む
my $row1 = $csv->getline($fh1);
my $row2 = $csv->getline($fh2);

# "dappId"列のインデックスを見つける
my ($index1) = grep { $row1->[$_] eq 'dappId' } 0..$#$row1;
my ($index2) = grep { $row2->[$_] eq 'dappId' } 0..$#$row2;

# ファイル2をハッシュに読み込む
my %file2;
while (my $row = $csv->getline($fh2)) {
    $file2{$row->[$index2]} = $row;
}

# Header
print $fh_out "Address,Name,Category,dAppId,Stakers,Voting,BuildAndEarn,TotalStaked\n";

# ファイル1を読み込み、マッチする行を結合する
while (my $row = $csv->getline($fh1)) {
    if (my $match = $file2{$row->[$index1]}) {
        $csv->print($fh_out, [@$row, @$match[1..$#$match]]);
    }
}

# ファイルを閉じる
close $fh1;
close $fh2;
close $fh_out;

