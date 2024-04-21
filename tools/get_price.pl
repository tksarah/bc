#!/usr/bin/perl
# https://coinmarketcap.com/api/documentation/v1/
use strict;
use warnings;
use JSON;
use LWP::Simple;
use Data::Dumper;

my $url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';
my $api_key = 'YOUR_API_KEY';
my $headers = '-H "X-CMC_PRO_API_KEY: '.$api_key.'" -H "Accept: application/json"';

# for USD
my $params_usd = '-d "symbol=ETH,ASTR&convert=USD"';
my $curl_command_usd = "curl -s $headers $params_usd -G \"$url\"";

my $json_usd = `$curl_command_usd`;
die "Could not get $url" unless defined $json_usd;

my $decoded_json_usd = decode_json($json_usd);

# TEST
#print Dumper($decoded_json);

my $eth_price_usd = $decoded_json_usd->{'data'}{'ETH'}{'quote'}{'USD'}{'price'};
my $astr_price_usd = $decoded_json_usd->{'data'}{'ASTR'}{'quote'}{'USD'}{'price'};

# for JPY
my $params_jpy = '-d "symbol=ETH,ASTR&convert=JPY"';
my $curl_command_jpy = "curl -s $headers $params_jpy -G \"$url\"";

my $json_jpy = `$curl_command_jpy`;
die "Could not get $url" unless defined $json_jpy;

my $decoded_json_jpy = decode_json($json_jpy);

my $eth_price_jpy = $decoded_json_jpy->{'data'}{'ETH'}{'quote'}{'JPY'}{'price'};
my $astr_price_jpy = $decoded_json_jpy->{'data'}{'ASTR'}{'quote'}{'JPY'}{'price'};

my $token = $ARGV[0] // 'default';


# Output
if($token eq "e"){
	print "\n--- Price ---\n";
	print "\$/Yen:\n";
	printf("  %.2f\n", $eth_price_jpy/$eth_price_usd);
	print "ETH\n";
	printf("  USD  : %.2f\n", $eth_price_usd);
	printf("  JPY  : %.2f\n", $eth_price_jpy);
	print "-------------\n\n";
}elsif($token eq "a"){
	print "\n--- Price ---\n";
	print "\$/Yen:\n";
	printf("  %.2f\n", $eth_price_jpy/$eth_price_usd);
	print "ASTR\n";
	printf("  USD : %.4f\n", $astr_price_usd);
	printf("  JPY : %.2f\n", $astr_price_jpy);
	print "-------------\n\n";

}else{
	print "\n--- Price ---\n";
	print "\$/Yen:\n";
	printf("  %.2f\n\n", $eth_price_jpy/$eth_price_usd);
	print "USD:\n";
	printf("  ETH  : %.2f\n", $eth_price_usd);
	printf("  ASTR : %.4f\n", $astr_price_usd);
	print "\n";
	print "JPY:\n";
	printf("  ETH  : %.2f\n", $eth_price_jpy);
	printf("  ASTR : %.2f\n", $astr_price_jpy);
	print "-------------\n\n";
}

exit(0);
