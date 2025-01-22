#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Text::CSV;
use POSIX 'strftime';
use List::Util qw(sum); 
use Statistics::Basic qw(:all);

# Set Tier value
my ($tier1, $tier2, $tier3, $tier4) = get_threshold('tier.json');

# Rank Initialize
my $rank = 0;

# Output TotalAmount
my $total_amount = "TotalAmount.csv";

# Reward hash
our $tier_n;
our $rank_n;
our %tier_reward;
our %rank_reward;
$rank_reward{'1'} = 0;
get_reward_func('reward.json');
my $total_reward = 0;

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
print $output_fh2 "Name,Category,TotalStaked,Stakers,Mean,Median,STDDEV,Tier,Rank,Reward\n";

while (my $row = $csv->getline($fh)) {
    my $num_staker=0;
    my $mean=0;
    my $median=0;
    my $stddev=0;
    my ($address, $name, $mainCategory) = @$row;

    my @stake_amount_a;

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
	$num_staker++;

	push(@stake_amount_a, $formatted_value);
    }
    close $output_fh;

    print "\n -> $filename -> Done\n";
    
    # Get Tier and Rank
    my ($tier,$rank) = get_tier($tier1,$tier2,$tier3,$tier4,$sum);
    # for reward
    if ($tier =~ /(\d)/) { $tier_n = $1; }
    if ($rank =~ /(\d)/) { $rank_n = $1; }

    # Per staker amount
    if ($num_staker != 0){
	#$per_staker_amount = int($sum/$num_staker);
    	$mean = $sum/$num_staker;
    }

    # Get Median & STDDEV
    $median = median_func(@stake_amount_a);
    $stddev = stddev_func(@stake_amount_a);

    # For total reward
    if($tier ne "No Tier"){
	    $total_reward = $tier_reward{$tier_n} + $rank_n*$rank_reward{$tier_n};
    }else{
	    $total_reward = 0;
    }

    ### Out
    print $output_fh2 "$name,$mainCategory,$sum,$num_staker,$mean,$median,$stddev,$tier,$rank,$total_reward\n";

}
close $fh;

close $output_fh2;

exit(0);

sub get_threshold {
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

sub get_tier{
	my $tier1 = shift;
	my $tier2 = shift;
	my $tier3 = shift;
	my $tier4 = shift;
	my $stake_amount = shift;

	my $tier_value;

	my $rank = 0;

	# Set each rank divisor
	my $t2_divisor = ($tier1 - $tier2)/10;
	my $t3_divisor = ($tier2 - $tier3)/10;
	my $t4_divisor = ($tier3 - $tier4)/10;

	# Set rank/tier
	if ($stake_amount >= $tier1){
		$tier_value = "Tier 1";
	}elsif($stake_amount < $tier1 && $stake_amount >= $tier2){
		$tier_value = "Tier 2";
		$rank = int(($stake_amount - $tier2)/$t2_divisor);
	}elsif($stake_amount < $tier2 && $stake_amount >= $tier3){
		$tier_value = "Tier 3";
	    	$rank = int(($stake_amount - $tier3)/$t3_divisor);
	}elsif($stake_amount < $tier3 && $stake_amount >= $tier4){
		$tier_value = "Tier 4";
	    	$rank = int(($stake_amount - $tier4)/$t4_divisor);
	}else{
		$tier_value = "No Tier";
	    	$rank = "None";
	}

	return ($tier_value,$rank);

}

# Out Median
sub median_func {
    my @sorted = sort { $a <=> $b } @_;
    my $count = scalar @sorted;

    # 配列が空の場合は0を返す
    return 0 if $count == 0;

    if ($count % 2) {
        return $sorted[int($count / 2)];
    } else {
        return ($sorted[$count / 2 - 1] + $sorted[$count / 2]) / 2;
    }
}

# Out STDDEV
sub stddev_func {
    my @data = @_;

    # 配列が空の場合、またはすべての要素が0の場合は0を返す 
    return 0 if @data == 0 || sum(@data) == 0;

    my $mean = sum(@data) / @data;
    my $sq_sum = sum(map { ($_ - $mean) ** 2 } @data);
    return sqrt($sq_sum / @data);
}

# Get Tier Reward
sub get_reward_func {

    my ($file) = @_;
    my $x = 0;
    open my $refh, '<', $file or die "Could not open file: $!";

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
   	}
    }

    close $refh;

}

1;

