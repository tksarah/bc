#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;


my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, eol => $/ });

open my $fh1, "<:encoding(utf8)", "api_data.csv" or die "api_data.csv: $!";
open my $fh2, "<:encoding(utf8)", "voting_period.csv" or die "voting_period.csv: $!";
open my $fh_out, ">:encoding(utf8)", "vsp_data.csv" or die "vsp/vsp_data.csv: $!";

# Read header
my $row1 = $csv->getline($fh1);
my $row2 = $csv->getline($fh2);

# Find index "dappId"
my ($index1) = grep { $row1->[$_] eq 'dappId' } 0..$#$row1;
my ($index2) = grep { $row2->[$_] eq 'dappId' } 0..$#$row2;

# Read file2 into hash
my %file2;
while (my $row = $csv->getline($fh2)) {
    $file2{$row->[$index2]} = $row;
}

# for Header
print $fh_out "Name,Category,Stakers,VotingStaked\n";

while (my $row = $csv->getline($fh1)) {
    if (my $match = $file2{$row->[$index1]}) {
        $csv->print($fh_out, [@$row[1,2,4], @$match[1..$#$match]]);
    }
}

close $fh1;
close $fh2;
close $fh_out;

