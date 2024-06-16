#!/usr/bin/perl
use strict;
use warnings;

#my $period = $ARGV[1];
my $input_data = $ARGV[0];
my $output_data = "voting_period.csv";

my @id;

##########
open my $fh, '<', $input_data or die "Could not open file: $!";

while (my $row = <$fh>) {
  chomp $row;

  if ($row =~ /^\s*(\d{1,2})\s*$/) {
    push @id, $1;
  }
}

close $fh;
##########
open my $refh, '<', $input_data or die "Could not open file: $!";

my $x = 0;
my @staked_future_voting;

while (my $row = <$refh>) {
  chomp $row;
  if ($row =~ /\sstakedFuture: \{$/) {
    $row = <$refh>;  # Read (stakedfuture-voting)
    chomp $row;
    ($x) = $row =~ /\s*voting:\s(\d{0,3}(,\d{3})*)/;
    #	print "$x\n";
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    my $formatted_x = sprintf("%.3f", $x);
    push @staked_future_voting, $formatted_x;
    }elsif($row =~ /\sstakedFuture: null$/){ # "stakedFuture: null"
    my $formatted_x = 0;
    push @staked_future_voting, $formatted_x;
  }
}

close $refh;
##########
open my $out, '>', $output_data or die "Cannot open '$output_data': $!";

print $out "dappId,stakeFuture-Voting\n";
for my $i (0..$#id) {
        print $out "$id[$i],$staked_future_voting[$i]\n";
	}
close $out;

# Check
for my $i (0..$#staked_future_voting) {
    print "$staked_future_voting[$i]\n";
    #print "$id[$i],$voting[$i],$bAe[$i]\n";
}
