#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;

use FindBin;

use lib $FindBin::Bin."/../src";

use Agora::DynamicKey5;

# Need to set environment variable AGORA_APP_ID
my $app_id          = $ENV{AGORA_APP_ID};
# Need to set environment variable AGORA_APP_CERTIFICATE
my $app_certificate = $ENV{AGORA_APP_CERTIFICATE};

my $channel_name    = "7d72365eb983485397e3e3f9d460bdda";
my $unix_ts         = time();
my $uid             = 2882341273;
my $random_int      = rand(10000000);
my $expired_ts      = 0;

if (!defined($app_id) || $app_id eq "" || !defined($app_certificate) || $app_certificate eq "") {
    say "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE";
    exit 1;
}
say "App Id: $app_id";
say "App Certificate: $app_certificate";

my $recording_key              = Agora::DynamicKey5::gen_recording_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts);
my $media_channel_key          = Agora::DynamicKey5::gen_media_channel_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts);
my $public_sharing_key         = Agora::DynamicKey5::gen_public_sharing_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts);
my $in_channel_permission_key1 = Agora::DynamicKey5::gen_in_channel_permission_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, Agora::DynamicKey5::NO_UPLOAD);
my $in_channel_permission_key2 = Agora::DynamicKey5::gen_in_channel_permission_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, Agora::DynamicKey5::AUDIO_VIDEO_UPLOAD);

say "recording_key: $recording_key";
say "media_channel_key: $media_channel_key";
say "public_sharing_key: $public_sharing_key";
say "in_channel_permission_no_upload: $in_channel_permission_key1";
say "in_channel_permission_video_audio_upload: $in_channel_permission_key2";
