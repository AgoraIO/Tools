#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;

use FindBin;

use lib $FindBin::Bin."/../src";

use Agora::SignalingToken;

my $account               = "2882341273";
my $app_id                = "970CA35de60c44645bbae8a215061b33";
my $app_certificate       = "5CFd2fd1755d40ecb72977518be15d3b";
my $now                   = time();
my $valid_time_in_seconds = 3600*24;
my $expired_ts_in_seconds = $now + $valid_time_in_seconds;

my $token = Agora::SignalingToken::gen_signaling_token($account, $app_id, $app_certificate, $expired_ts_in_seconds);
say "signaling_token\t$token";
