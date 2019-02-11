use strict;
use warnings;
use utf8;

use Test::More;

use_ok "Agora::DynamicKey5";

my $app_id          = "970ca35de60c44645bbae8a215061b33";
my $app_certificate = "5cfd2fd1755d40ecb72977518be15d3b";
my $channel_name    = "7d72365eb983485397e3e3f9d460bdda";
my $unix_ts         = 1446455472;
my $random_int      = 58964981;
my $uid             = 2882341273;
my $expired_ts      = 1446455471;

is
    Agora::DynamicKey5::gen_public_sharing_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts),
    "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==",
    "public_sharing_key";

is
    Agora::DynamicKey5::gen_recording_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts),
    "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==",
    "gen_recording_key";

is
    Agora::DynamicKey5::gen_media_channel_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts),
    "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==",
    "gen_media_channel_key";

is
    Agora::DynamicKey5::gen_in_channel_permission_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, Agora::DynamicKey5::NO_UPLOAD()),
    "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw",
    "gen_in_channel_permission_key(NO_UPLOAD)";

is
    Agora::DynamicKey5::gen_in_channel_permission_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, Agora::DynamicKey5::AUDIO_VIDEO_UPLOAD()),
    "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz",
    "gen_in_channel_permission_key(AUDIO_VIDEO_UPLOAD)";

done_testing;
