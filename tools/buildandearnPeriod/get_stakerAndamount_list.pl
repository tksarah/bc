#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';

# Set Tier value
my ($tier1, $tier2, $tier3, $tier4) = get_tier('tier.json');

# Set Rank Value
my $t2_rankV = ($tier1 - $tier2)/10;
my $t3_rankV = ($tier2 - $tier3)/10;
my $t4_rankV = ($tier3 - $tier4)/10;

# Initialize
my $rank = "";

# Output TotalAmount
my $total_amount = "TotalAmount.csv";

# 新しいCSVモジュールを使用するための準備
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# CSVファイルを開く
open my $fh, "<:encoding(utf8)", "dapps_list.dat" or die "dapps_list.dat $!";

# CSVファイルのヘッダーを読み飛ばす
$csv->getline($fh);

# Get timestamp
my $timestamp = strftime "%Y-%m-%d-%H", localtime;
$total_amount = $timestamp . "_" . $total_amount;
# Open TotalAmount
open my $output_fh2, ">>:encoding(utf8)", $total_amount or die "$total_amount: $!";
print $output_fh2 "Name,Category,TotalStaked,Tier,Rank\n";

while (my $row = $csv->getline($fh)) {
    my ($address, $name, $mainCategory) = @$row;

    # 保存するファイル名を生成する-1
    my $filename = $timestamp . "_" . $name . ".csv";
    $filename =~ s/\s/_/g;
    $filename =~ s/:/-/g;
    $filename =~ s/,/_/g;
    $filename =~ s/\(/_/g;
    $filename =~ s/\)/_/g;
    $filename =~ s/\|/_/g;
    
    # for TotalAmount 
    my $sum = 0;

    # APIのURLを組み立てる
    my $url = "https://api.astar.network/api/v3/astar/dapps-staking/stakerslist/$address";
    my $json_text = get($url);

    # JSONをデコードする
    my $data = decode_json($json_text);

    # データを金額でソートする
    my @sorted_data = sort { $b->{amount} <=> $a->{amount} } @$data;

    ### FH
    open my $output_fh, ">:encoding(utf8)", $filename or die "$filename: $!";
    print $output_fh "stakerAddress, amount\n";

    # 各データ項目を出力
    foreach my $item (@sorted_data) {
        my $value = $item->{amount}/1000000000000000000;
        my $formatted_value = sprintf("%.3f", $value);
        print $output_fh "$item->{stakerAddress}, $formatted_value\n";

	$sum += $formatted_value;
    }
    close $output_fh;

    print "\n -> $filename -> Done\n";
    
    # Check Tier 
    my $tier = check_tier($tier1,$tier2,$tier3,$tier4,$sum);

    if($tier =~ /1/){
	    $rank = 0;
    }elsif($tier =~/2/){
	    $rank = int(($sum - $tier2)/$t2_rankV);
    }elsif($tier =~ /3/){
	    $rank = int(($sum - $tier3)/$t3_rankV);
    }elsif($tier =~ /4/){
	    $rank = int(($sum - $tier4)/$t4_rankV);
    }else{
	    $rank = "None";
    }

    # For total amount
    print $output_fh2 "$name,$mainCategory,$sum,$tier,$rank\n";

}
close $fh;

close $output_fh2;

exit(0);

sub get_tier {
    my $input = shift;

    my $x = 0;
    my $y = 0;
    my $z = 0;
    my $t4 = 0;

    my $formatted_t1;
    my $formatted_t2;
    my $formatted_t3;
    my $formatted_t4;

    open my $refh, '<', $input or die "Could not open file: $!";

    while (my $row = <$refh>) {
        chomp $row;
        if ($row =~ /^\s+tierThresholds:\s\[$/) {

            $row = <$refh>;  # Read Teir1 Threshold
            chomp $row;
            ($x) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $x =~ s/,//g;
            $x = $x/1000000000000000000;
            $formatted_t1 = sprintf("%.3f", $x);
	    #print "Tier 1 = $formatted_t1\n";

            $row = <$refh>;  # Read Teir2 Threshold
            chomp $row;
            ($y) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $y =~ s/,//g;
            $y = $y/1000000000000000000;
            $formatted_t2 = sprintf("%.3f", $y);
	    #print "Tier 2 = $formatted_t2\n";

            $row = <$refh>;  # Read Teir3 Threshold
            chomp $row;
            ($z) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $z =~ s/,//g;
            $z = $z/1000000000000000000;
            $formatted_t3 = sprintf("%.3f", $z);
	    #print "Tier 3 = $formatted_t3\n";

            $row = <$refh>;  # Read Teir4 Threshold
            chomp $row;
            ($t4) = $row =~ /\s*(\d{0,3}(,\d{3})*)/;
            $t4 =~ s/,//g;
            $t4 = $t4/1000000000000000000;
            $formatted_t4 = sprintf("%.3f", $t4);
	    #print "Tier 4 = $formatted_t4\n";
        }
    }

    close $refh;

    return ($formatted_t1, $formatted_t2, $formatted_t3, $formatted_t4);

}

sub check_tier{
	my $tier1 = shift;
	my $tier2 = shift;
	my $tier3 = shift;
	my $tier4 = shift;
	my $sum = shift;

	my $tier_value;

	if ($sum >= $tier1){
		$tier_value = "Tier 1";
	}elsif($sum < $tier1 && $sum >= $tier2){
		$tier_value = "Tier 2";
	}elsif($sum < $tier2 && $sum >= $tier3){
		$tier_value = "Tier 3";
	}elsif($sum < $tier3 && $sum >= $tier4){
		$tier_value = "Tier 4";
	}else{
		$tier_value = "No Tier";
	}

	return $tier_value;

}


1;

