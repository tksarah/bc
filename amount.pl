#!/usr/bin/perl
use strict;
use warnings;

my $input_data = $ARGV[0];
my $output_data = "after_voting.csv";

my @id;

# ファイルを開く
open my $fh, '<', $input_data or die "Could not open file: $!";

# ファイルを行ごとに読み込みます
while (my $row = <$fh>) {
  chomp $row;

  # 行が一桁または二桁の数字だけで構成されているか確認します
  if ($row =~ /^\s*(\d{1,2})\s*$/) {
    # 数字を変数に格納します
    push @id, $1;
  }
}

close $fh;

open my $refh, '<', $input_data or die "Could not open file: $!";

my $x = 0;
my $y = 0;
my $z = 0;
my @staked_voting;
my @staked_bAe;
my @staked_future_bAe;

while (my $row = <$refh>) {
  chomp $row;
  if ($row =~ /\sstaked: \{$/) {
    $row = <$refh>;  # (voting)を読み込む
    chomp $row;
    ($x) = $row =~ /\s*voting:\s(\d{0,3}(,\d{3})*)/;
    #	print "$x\n";
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    my $formatted_x = sprintf("%.3f", $x);
    push @staked_voting, $formatted_x;

    $row = <$refh>;  # (buildAndEarn)を読み込む
    chomp $row;
    ($z) = $row =~ /\s*buildAndEarn:\s(\d{0,3}(,\d{3})*)/;
    #	print "$x\n";
    $z =~ s/,//g;
    $z = $z/1000000000000000000;
    my $formatted_z = sprintf("%.3f", $z);
    push @staked_bAe, $formatted_z;

  <$refh>;
  <$refh>;
  <$refh>;

  $row = <$refh>;  
  chomp $row;
  if ($row =~ /\sstakedFuture: \{$/) {
    <$refh>;
    $row = <$refh>;  
    chomp $row;
    ($y) = $row =~ /\s*buildAndEarn:\s(\d{0,3}(,\d{3})*)/;
    #	print "$y\n";
    $y =~ s/,//g;
    $y = $y/1000000000000000000;
    my $formatted_y = sprintf("%.3f", $y);
    push @staked_future_bAe, $formatted_y;
    }else{ # "stakedFuture: null"
    my $formatted_y = 0;
    push @staked_future_bAe, $formatted_y;
    }
  }
}

close $refh;

open my $out, '>', $output_data or die "Cannot open '$output_data': $!";

print $out "dappId,Voting,BuildAndEarn,TotalStaked\n";
for my $i (0..$#id) {
    if ($staked_future_bAe[$i] != 0){
    	my $sum = $staked_voting[$i] + $staked_future_bAe[$i];
    	print $out "$id[$i],$staked_voting[$i],$staked_future_bAe[$i],$sum\n";
    }else{
    	my $sum = $staked_voting[$i] + $staked_bAe[$i];
    	print $out "$id[$i],$staked_voting[$i],$staked_bAe[$i],$sum\n";
    }

}
close $out;

# Check
#for my $i (0..$#id) {
#    print "$id[$i],$voting[$i],$bAe[$i]\n";
#}
