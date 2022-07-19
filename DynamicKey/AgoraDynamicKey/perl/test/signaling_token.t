use strict;
use warnings;
use utf8;

use Test::More;

use_ok "Agora::SignalingToken";

my $account               = "2882341273";
my $app_id                = "970CA35de60c44645bbae8a215061b33";
my $app_certificate       = "5CFd2fd1755d40ecb72977518be15d3b";
my $now                   = 1514133234;
my $valid_time_in_seconds = 3600 * 24;
my $expired_ts_in_seconds = $now + $valid_time_in_seconds;

is
    Agora::SignalingToken::gen_signaling_token($account, $app_id, $app_certificate, $expired_ts_in_seconds),
    "1:970CA35de60c44645bbae8a215061b33:1514219634:82539e1f3973bcfe3f0d0c8993e6c051",
    "signaling_token";

done_testing;

