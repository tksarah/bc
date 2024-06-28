#!/usr/bin/perl
use strict;
use warnings;

my $input_data = $ARGV[0];
my $output_data = "after_voting.csv";

my @id;

open my $fh, '<', $input_data or die "Could not open file: $!";

while (my $row = <$fh>) {
  chomp $row;

  if ($row =~ /^\s*(\d{1,2})\s*$/) {
    push @id, $1;
  }
}

close $fh;

open my $refh, '<', $input_data or die "Could not open file: $!";

my $x = 0;
my $y = 0;
my $z = 0;

my $stakeFuture_voting;
my @staked_voting;
my @staked_bAe;
my @staked_future_bAe;

my @flags_staked;

my $sum = 0;

while (my $row = <$refh>) {
  chomp $row;
  if ($row =~ /\sstaked: \{$/) {
    $row = <$refh>;  # Read (voting)
    chomp $row;
    ($x) = $row =~ /\s*voting:\s(\d{0,3}(,\d{3})*)/;
    #	print "$x\n";
    $x =~ s/,//g;
    $x = $x/1000000000000000000;
    my $formatted_x = sprintf("%.3f", $x);
    push @staked_voting, $formatted_x;

    $row = <$refh>;  # Read (buildAndEarn)
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
      $row = <$refh>;
      chomp $row;
      ($stakeFuture_voting) = $row =~ /\s*voting:\s(\d{0,3}(,\d{3})*)/;

      $row = <$refh>;  
      chomp $row;
      ($y) = $row =~ /\s*buildAndEarn:\s(\d{0,3}(,\d{3})*)/;
      #	print "$y\n";
      $y =~ s/,//g;
      if($y == 0){
  	    $y = $stakeFuture_voting;
            $y =~ s/,//g;
            push @flags_staked, 1;
      }
      $y = $y/1000000000000000000;
      my $formatted_y = sprintf("%.3f", $y);
      push @staked_future_bAe, $formatted_y;
    }else{ # "stakedFuture: null"
      my $formatted_y = 0;
      push @staked_future_bAe, $formatted_y;
      push @flags_staked, 0;
    }
  }
}

close $refh;

open my $out, '>', $output_data or die "Cannot open '$output_data': $!";

print $out "dappId,Voting,BuildAndEarn,TotalStaked\n";
for my $i (0..$#id) {
    $flags_staked[$i] //= 0;
    if ($staked_future_bAe[$i] != 0){
	if($flags_staked[$i] == 0){
    		$sum = $staked_voting[$i] + $staked_future_bAe[$i];
	}else{
    		$sum = $staked_future_bAe[$i];
	}
    	print $out "$id[$i],$staked_voting[$i],$staked_future_bAe[$i],$sum\n";
    }else{
    	$sum = $staked_voting[$i] + $staked_bAe[$i];
    	print $out "$id[$i],$staked_voting[$i],$staked_bAe[$i],$sum\n";
    }

}
close $out;

# Check
#for my $i (0..$#id) {
#    print "$id[$i],$voting[$i],$bAe[$i]\n";
#}
