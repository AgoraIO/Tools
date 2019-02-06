package Agora::DynamicKey5;
# this package is port from https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey @8c5941e
use strict;
use warnings;
use utf8;
use 5.010;

use MIME::Base64 qw/encode_base64/;
use Digest::SHA qw/hmac_sha1_hex/;

# service type
use constant {
    MEDIA_CHANNEL_SERVICE  => 1,
    RECORDING_SERVICE      => 2,
    PUBLIC_SHARING_SERVICE => 3,
    IN_CHANNEL_PERMISSION  => 4,
};

# extra key
use constant {
    ALLOW_UPLOAD_IN_CHANNEL => 1,
};

# permision
use constant {
    NO_UPLOAD          => "0",
    AUDIO_VIDEO_UPLOAD => "3",
};

sub gen_public_sharing_key {
    my ($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts) = @_;
    return _gen_dynamic_key(
        PUBLIC_SHARING_SERVICE, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, {}
    );
}

sub gen_recording_key {
    my ($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts) = @_;
    return _gen_dynamic_key(
        RECORDING_SERVICE, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, {}
    );
}

sub gen_media_channel_key {
    my ($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts) = @_;
    return _gen_dynamic_key(
        MEDIA_CHANNEL_SERVICE, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, {}
    );
}

sub gen_in_channel_permission_key {
    my ($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, $permision) = @_;
    my $extra = {
        ALLOW_UPLOAD_IN_CHANNEL() => $permision,
    };
    return _gen_dynamic_key(
        IN_CHANNEL_PERMISSION, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, $extra
    );
}

sub _gen_dynamic_key {
    my ($service_type, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, $extra) = @_;
    my $version   = "005";
    my $signature = _gen_signature(
        $service_type, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, $extra
    );
    my $key = join "",
        _pack_uint16($service_type),
        _pack_string($signature),
        _pack_hex_string($app_id),
        _pack_uint32($unix_ts),
        _pack_int32($random_int),
        _pack_uint32($expired_ts),
        _pack_extra($extra);
    return $version . encode_base64($key, "");
}

sub _gen_signature {
    my ($service_type, $app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts, $extra) = @_;
    my $sig = join "",
        _pack_uint16($service_type),
        _pack_hex_string($app_id),
        _pack_uint32($unix_ts),
        _pack_int32($random_int),
        _pack_string($channel_name),
        _pack_uint32($uid),
        _pack_uint32($expired_ts),
        _pack_extra($extra);
    return uc(hmac_sha1_hex($sig, pack("H*", $app_certificate)));
}

sub _pack_uint16 {
    my ($i) = @_;
    return pack("S<", $i);
}

sub _pack_uint32 {
    my ($i) = @_;
    return pack("L<", $i);
}

sub _pack_int32 {
    my ($i) = @_;
    return pack("l<", $i);
}

sub _pack_string {
    my ($s) = @_;
    return _pack_uint16(length($s)) . $s;
}

sub _pack_hex_string {
    my ($s) = @_;
    return _pack_string(pack("H*", $s));
}

sub _pack_extra {
    my ($extra) = @_;

    my @keys = sort keys %$extra;
    my $r    = _pack_uint16(scalar(@keys));
    for my $k (@keys) {
        $r .= _pack_uint16($k);
        $r .= _pack_string($extra->{$k});
    }
    return $r;
}

1
