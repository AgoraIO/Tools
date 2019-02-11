use strict;
use warnings;
use utf8;

use Test::More;

use_ok "Agora::AccessToken";

my $app_id          = "970CA35de60c44645bbae8a215061b33";
my $app_certificate = "5CFd2fd1755d40ecb72977518be15d3b";
my $channel_name    = "7d72365eb983485397e3e3f9d460bdda";
my $uid             = 2882341273;
my $expired_ts      = 1446455471;

subtest "uid != 0" => sub {
    my $token = Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, $uid);
    $token->{salt} = 1;
    $token->{ts}   = 1111111;
    $token->add_privilege(Agora::AccessToken::KJoinChannel(), $expired_ts);
    my $expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    is $token->build, $expected, "build";

    my $token2 = Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, $uid);
    ok $token2->from_string($expected), "from_string";
    is $token2->build, $expected, "build after from_string";
};

subtest "uid = 0" => sub {
    my $token = Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, 0);
    $token->{salt} = 1;
    $token->{ts}   = 1111111;
    $token->add_privilege(Agora::AccessToken::KJoinChannel(), $expired_ts);
    my $expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";
    is $token->build, $expected, "build";

    my $token2 = Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, 0);
    ok $token2->from_string($expected), "from_string";
    is $token2->build, $expected, "build after from_string";
};

done_testing;
