#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';

# Set Tier value
my ($tier1, $tier2, $tier3, $tier4) = get_tier_new('sample.json');


exit(0);

sub get_tier_new {
    my $input = shift;

    my $x = 0;
    my $y = 0;
    my $z = 0;
    my $t4 = 1500000;

    my $formatted_t1;
    my $formatted_t2;
    my $formatted_t3;
    my $formatted_t4;

    open my $refh, '<', $input or die "Could not open file: $!";

    while (my $row = <$refh>) {
        chomp $row;
        if ($row =~ /^tierThresholds:\s\[$/) {

            $row = <$refh>;  # Read Teir1 Threshold
            chomp $row;
            ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $x =~ s/,//g;
            $x = $x/1000000000000000000;
            $formatted_t1 = sprintf("%.3f", $x);
            print "Tier 1 = $formatted_t1\n";

            $row = <$refh>;  # Read Teir2 Threshold
            chomp $row;
            ($y) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $y =~ s/,//g;
            $y = $y/1000000000000000000;
            $formatted_t2 = sprintf("%.3f", $y);
            print "Tier 2 = $formatted_t2\n";

            $row = <$refh>;  # Read Teir3 Threshold
            chomp $row;
            ($z) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $z =~ s/,//g;
            $z = $z/1000000000000000000;
            $formatted_t3 = sprintf("%.3f", $z);
            print "Tier 3 = $formatted_t3\n";

            $formatted_t4 = sprintf("%.3f", $t4);
            print "Tier 4 = $formatted_t4\n";
        }
    }

    close $refh;

    return ($formatted_t1, $formatted_t2, $formatted_t3, $formatted_t4);

}


1;

