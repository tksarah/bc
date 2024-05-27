#!/usr/bin/perl
use strict;
use warnings;
use POSIX 'strftime';


my $json = $ARGV[0]; # ./store/json file
my $input_filename = $ARGV[1]; # index.org
my $output_filename = $ARGV[2]; # new index.html 
my @lines;

# Initialize
my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;
my $tier1=200000000;
my $tier4=1500000;

my ($tier1m, $tier2m, $tier3m) = process($json);  

# ファイルを開く
open(my $in_fh, '<', $input_filename) or die "Could not open file '$input_filename' $!";

# ファイルの各行を読み込む
while (my $row = <$in_fh>) {
    chomp $row;
    $row =~ s/TIERMtop/$tier1/g;
    $row =~ s/TIER1M/$tier1m/g;
    $row =~ s/TIER2M/$tier2m/g;
    $row =~ s/TIER3M/$tier3m/g;
    $row =~ s/TIER4/$tier4/g;
    $row =~ s/DATEJST/$date/g;
    push @lines, $row;
}

close $in_fh;

# 結果を新しいファイルに保存する
open(my $out_fh, '>', $output_filename) or die "Could not open file '$output_filename' $!";
print $out_fh join("\n", @lines);
close $out_fh;

exit(0);



#######################
sub process {
    my ($input) = @_;  

    my $x = 0;
    my $y = 0;
    my $z = 0;

open my $refh, '<', $input or die "Could not open file: $!";

while (my $row = <$refh>) {
  chomp $row;
  if ($row =~ /\stierThresholds:\s\[$/) {
    <$refh>;
    <$refh>;

    $row = <$refh>;  # Read Teir1 Threshold
    chomp $row;
    ($x) = $row =~ /\s*amount:\s(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    my $formatted_x = sprintf("%.3f", $x);
    #push @staked_voting, $formatted_x;
    #print "Tier 1 $formatted_x\n";


    <$refh>;
    <$refh>;
    <$refh>;
    <$refh>;
    <$refh>;

    $row = <$refh>;  # Read Teir2 Threshold
    chomp $row;
    ($y) = $row =~ /\s*amount:\s(\d{0,3}(,\d{3})*)/;
    $y =~ s/,//g;
    $y = $y/1000000000000000000;
    my $formatted_y = sprintf("%.3f", $y);
    #push @staked_bAe, $formatted_y;
    #print "Tier 2 $formatted_y\n";


    <$refh>;
    <$refh>;
    <$refh>;
    <$refh>;
    <$refh>;

    $row = <$refh>;  # Read Teir3 Threshold
    chomp $row;
    ($z) = $row =~ /\s*amount:\s(\d{0,3}(,\d{3})*)/;
    $z =~ s/,//g;
    $z = $z/1000000000000000000;
    my $formatted_z = sprintf("%.3f", $z);
    #push @staked_bAe, $formatted_y;
    #print "Tier 3 $formatted_z\n";

  return ($formatted_x, $formatted_y, $formatted_z);  

  }
}
close $refh;

}
