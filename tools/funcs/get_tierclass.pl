#!/usr/bin/perl
use strict;
use warnings;

# $input = api_data.csv: created by script.pl
# This file needs adjustment.
my $input = $ARGV[0];

my $x = 0;
my $y = 0;
my $z = 0;
my $t4 = 15000000;

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
    print "Tier 1 $formatted_x\n";


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
    print "Tier 2 $formatted_y\n";


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
    print "Tier 3 $formatted_z\n";

    my $formatted_t4 = sprintf("%.3f", $t4);
    print "Tier 4 $formatted_t4\n";


  }
}

close $refh;

