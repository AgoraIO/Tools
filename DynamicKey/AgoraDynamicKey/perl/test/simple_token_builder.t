use strict;
use warnings;
use utf8;

use Test::More;
use Agora::AccessToken;

use_ok "Agora::SimpleTokenBuilder";

my $app_id          = "970CA35de60c44645bbae8a215061b33";
my $app_certificate = "5CFd2fd1755d40ecb72977518be15d3b";
my $channel_name    = "7d72365eb983485397e3e3f9d460bdda";
my $uid             = 2882341273;
my $expired_ts      = 1446455471;

{
    my $builder = Agora::SimpleTokenBuilder::create_simple_token_builder($app_id, $app_certificate, $channel_name, $uid);
    $builder->{token}{salt} = 1;
    $builder->{token}{ts}   = 1111111;
    $builder->set_privilege(Agora::AccessToken::KJoinChannel(), $expired_ts);
    my $expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    is $builder->build_token, $expected, "create_simple_token_builder build";

    my $builder2 = Agora::SimpleTokenBuilder::create_simple_token_builder($app_id, $app_certificate, $channel_name, $uid);
    ok $builder2->init_token_builder($expected);
    is $builder2->build_token, $expected, "build after init_token_builder";
}

done_testing;

