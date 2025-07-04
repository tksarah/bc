#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::Simple;

my $url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';
my $api_key = 'YOUR-API-KEY';

# トークンIDとその対応するsymbolを記述
my %tokens = (
    '1'  => 'BTC',
    '1027'  => 'ETH',
    '5426'  => 'SOL',
    '12885' => 'ASTR',
    '19966' => 'QUICK',
);

sub fetch_prices {
    my ($convert) = @_;
    my $id_str = join(',', keys %tokens);
    my $headers = '-H "X-CMC_PRO_API_KEY: ' . $api_key . '" -H "Accept: application/json"';
    my $params = qq{-d "id=$id_str&convert=$convert"};
    my $command = qq{curl -s $headers $params -G "$url"};
    my $json = `$command`;
    die "Could not get data for $convert" unless $json;
    return decode_json($json);
}

sub extract_prices {
    my ($json, $currency) = @_;
    my %prices;
    for my $id (keys %tokens) {
        my $symbol = $tokens{$id};
        $prices{$symbol} = $json->{data}{$id}{quote}{$currency}{price};
    }
    return \%prices;
}

sub print_price_info {
    my ($usd_prices, $jpy_prices, $target) = @_;
    print "\n--- Price ---\n";
    my $rate = $jpy_prices->{ETH} / $usd_prices->{ETH};
    printf("\$/Yen:\n  %.2f\n", $rate);

    if ($target && exists $usd_prices->{$target}) {
        print "$target\n";
        printf("  USD : %.4f\n", $usd_prices->{$target});
        printf("  JPY : %.2f\n", $jpy_prices->{$target});
    } else {
        print "\nUSD:\n";
        for my $symbol (sort keys %$usd_prices) {
            printf("  %-6s : %.4f\n", $symbol, $usd_prices->{$symbol});
        }
        print "\nJPY:\n";
        for my $symbol (sort keys %$jpy_prices) {
            printf("  %-6s : %.2f\n", $symbol, $jpy_prices->{$symbol});
        }
    }
    print "-------------\n\n";
}


my $token = uc($ARGV[0] // '');
my $json_usd = fetch_prices('USD');
my $json_jpy = fetch_prices('JPY');

my $usd_prices = extract_prices($json_usd, 'USD');
my $jpy_prices = extract_prices($json_jpy, 'JPY');

print_price_info($usd_prices, $jpy_prices, $token);
exit(0);
