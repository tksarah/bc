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
my @voting;
my @bAe;

while (my $row = <$refh>) {
  chomp $row;
  if ($row =~ /\sstaked: \{$/) {
    $row = <$refh>;  # 次の行を読み込む
    chomp $row;
    ($x) = $row =~ /\s*voting:\s(\d{0,3}(,\d{3})*)/;
    #	print "$x\n";
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    my $formatted_x = sprintf("%.3f", $x);
    push @voting, $formatted_x;

  <$refh>;
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
    push @bAe, $formatted_y;
    }else{
    my $formatted_y = 0;
    push @bAe, $formatted_y;
    }
  }
}

close $refh;

open my $out, '>', $output_data or die "Cannot open '$output_data': $!";

print $out "dappId,Voting,BuildAndEarn,TotalStaked\n";
for my $i (0..$#id) {
    my $sum = $voting[$i] + $bAe[$i];
    print $out "$id[$i],$voting[$i],$bAe[$i],$sum\n";
}
close $out;

# Check
#for my $i (0..$#id) {
#    print "$id[$i],$voting[$i],$bAe[$i]\n";
#}
