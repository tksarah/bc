#!/usr/bin/perl
use strict;
use warnings;

# $input = api_data.csv: created by script.pl
# This file needs adjustment.
my $input = $ARGV[0];
my $tier = $ARGV[1];
my $rank = $ARGV[2];

my %rank_reward;
my %tier_reward;
$rank_reward{'1'} = 0;

my $x = 0;
my $total_reward = 0;

open my $refh, '<', $input or die "Could not open file: $!";

while (my $row = <$refh>) {
  chomp $row;

  # Tier Base
  if ($row =~ /\srewards:\s\[$/) {
    $row = <$refh>;  # Teir1 Base Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $tier_reward{'1'} = sprintf("%d", $x);

    $row = <$refh>;  # Teir2 Base Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $tier_reward{'2'} = sprintf("%d", $x);

    $row = <$refh>;  # Teir3 Base Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $tier_reward{'3'} = sprintf("%d", $x);

    $row = <$refh>;  # Teir4 Base Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $tier_reward{'4'} = sprintf("%d", $x);

    print "Tier 1 Reward, $tier_reward{'1'}\n";
    print "Tier 2 Reward, $tier_reward{'2'}\n";
    print "Tier 3 Reward, $tier_reward{'3'}\n";
    print "Tier 4 Reward, $tier_reward{'4'}\n\n";
  }

  # Rank
  if ($row =~ /\srankRewards:\s\[$/) {
     <$refh>;
    $row = <$refh>;  # Tier2 Rank Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $rank_reward{'2'} = sprintf("%d", $x);

    $row = <$refh>;  # Teir3 Rank Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $rank_reward{'3'} = sprintf("%d", $x);

    $row = <$refh>;  # Tier4 Rank Reward
    chomp $row;
    ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    $rank_reward{'4'} = sprintf("%d", $x);

    print "Tier 1 Rank Reward, $rank_reward{'1'}\n";
    print "Tier 2 Rank Reward, $rank_reward{'2'}\n";
    print "Tier 3 Rank Reward, $rank_reward{'3'}\n";
    print "Tier 4 Rank Reward, $rank_reward{'4'}\n\n";
   } 
}

close $refh;

print "Tier: $tier\n";
print "Rank: $rank\n";

$total_reward = $tier_reward{$tier} + $rank*$rank_reward{$tier};

print "Total Reward: $total_reward\n";
