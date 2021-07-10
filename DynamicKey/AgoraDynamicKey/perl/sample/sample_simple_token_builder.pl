#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;

use FindBin;

use lib $FindBin::Bin."/../src";

use Agora::AccessToken;
use Agora::SimpleTokenBuilder;

my $app_id           = "970CA35de60c44645bbae8a215061b33";
my $app_certificate  = "5CFd2fd1755d40ecb72977518be15d3b";
my $channel_name     = "7d72365eb983485397e3e3f9d460bdda";
my $uid              = 2882341273;
my $expire_timestamp = 0;

my $builder = Agora::SimpleTokenBuilder::create_simple_token_builder($app_id, $app_certificate, $channel_name, $uid);

$builder->init_privileges(Agora::SimpleTokenBuilder::Role_Attendee);
$builder->set_privilege(Agora::AccessToken::KJoinChannel, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishAudioStream, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishVideoStream, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishDataStream, $expire_timestamp);

my $token_str = $builder->build_token;
say "access_token\t$token_str";

