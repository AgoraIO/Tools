#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;

use FindBin;

use lib $FindBin::Bin."/../src";

use Agora::AccessToken;
use Agora::SimpleTokenBuilder;

# Need to set environment variable AGORA_APP_ID
my $app_id           = $ENV{AGORA_APP_ID};
# Need to set environment variable AGORA_APP_CERTIFICATE
my $app_certificate  = $ENV{AGORA_APP_CERTIFICATE};

my $channel_name     = "7d72365eb983485397e3e3f9d460bdda";
my $uid              = 2882341273;
my $expire_timestamp = 0;

if (!defined($app_id) || $app_id eq "" || !defined($app_certificate) || $app_certificate eq "") {
    say "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE";
    exit 1;
}
say "App Id: $app_id";
say "App Certificate: $app_certificate";

my $builder = Agora::SimpleTokenBuilder::create_simple_token_builder($app_id, $app_certificate, $channel_name, $uid);
$builder->init_privileges(Agora::SimpleTokenBuilder::Role_Attendee);
$builder->set_privilege(Agora::AccessToken::KJoinChannel, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishAudioStream, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishVideoStream, $expire_timestamp);
$builder->set_privilege(Agora::AccessToken::KPublishDataStream, $expire_timestamp);

my $token_str = $builder->build_token;
say "Token: $token_str";

