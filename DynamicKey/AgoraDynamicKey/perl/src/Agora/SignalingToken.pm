package Agora::SignalingToken;
# this package is port from https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey @8c5941e
use strict;
use warnings;
use utf8;
use 5.010;

use Digest::MD5 qw/md5_hex/;

sub gen_signaling_token {
    my ($account, $app_id, $app_certificate, $expired_ts_in_seconds) = @_;
    my $version = "1";
    my $expired = $expired_ts_in_seconds . "";
    my $content = $account . $app_id . $app_certificate . $expired;
    my $md5sum  = md5_hex $content;

    return join ":", $version, $app_id, $expired, $md5sum;
}

1;
