#!/usr/bin/perl
use strict;
use warnings;
use POSIX 'strftime';


my $input_filename = $ARGV[0]; # index.org
my $output_filename = $ARGV[1]; # new index.html 
my @lines;

# Initialize
my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;

# ファイルを開く
open(my $in_fh, '<', $input_filename) or die "Could not open file '$input_filename' $!";

# ファイルの各行を読み込む
while (my $row = <$in_fh>) {
    chomp $row;
    $row =~ s/DATEJST/$date/g;
    push @lines, $row;
}

close $in_fh;

# 結果を新しいファイルに保存する
open(my $out_fh, '>', $output_filename) or die "Could not open file '$output_filename' $!";
print $out_fh join("\n", @lines);
close $out_fh;

exit(0);

