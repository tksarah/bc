#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';

use strict;
use warnings;

my $filename = 'TotalAmount.csv';

open(my $fh, '<', $filename) or die "Cannot open $filename: $!";
my @lines = <$fh>;
close($fh);

my $header = shift @lines;

@lines = sort { (split /,/, $b)[2] <=> (split /,/, $a)[2] } @lines;

my %rank;
foreach my $line (@lines) {
    my @fields = split /,/, $line;
    my $category = $fields[3];
    chomp $fields[3];
    $rank{$category}++;
    $fields[4] = "$rank{$category}\n";
    
    $line = join(',', @fields);
}

chomp $header;
$header = $header . ",Rank\n";

# Out
open(my $out, '>', $filename) or die "Cannot open $filename: $!";
print $out $header;
print $out @lines;
close($out);

# Debug
#print $header;
#print @lines;
