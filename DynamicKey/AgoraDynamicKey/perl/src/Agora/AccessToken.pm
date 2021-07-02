package Agora::AccessToken;
# this package is port from https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey @8c5941e
use strict;
use warnings;
use utf8;
use 5.010;

use Carp;
use Math::Random::MT::Auto qw/rand/;
use MIME::Base64 qw/encode_base64 decode_base64/;
use Digest::SHA qw/hmac_sha256/;
use String::CRC32 qw/crc32/;

use constant {
    VERSION_LENGTH => 3,
    APP_ID_LENGTH  => 32,
};

# Privileges
use constant {
    KJoinChannel               => 1,
    KPublishAudioStream        => 2,
    KPublishVideoStream        => 3,
    KPublishDataStream         => 4,
    KPublishAudiocdn           => 5,
    KPublishVideoCdn           => 6,
    KRequestPublishAudioStream => 7,
    KRequestPublishVideoStream => 8,
    KRequestPublishDataStream  => 9,
    KInvitePublishAudioStream  => 10,
    KInvitePublishVideoStream  => 11,
    KInvitePublishDataStream   => 12,

    KAdministrateChannel => 101,
};

sub get_version {
    return "006";
}

sub create_access_token {
    my ($app_id, $app_certificate, $channel_name, $uid) = @_;
    return __PACKAGE__->new(
        app_id          => $app_id,
        app_certificate => $app_certificate,
        channel_name    => $channel_name,
        uid             => $uid,
    );
}

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    bless {
        (map { $_ => $args{$_} } qw/app_id app_certificate channel_name/),
        uid      => $args{uid} == 0 ? "" : $args{uid} . "",
        ts       => time() + 24 * 3600,
        salt     => int(rand(99999999)) + 1,
        messages => {},
    }, $class;
}

sub from_string {
    my ($self, $origin_token) = @_;

    my $dk6version = get_version;
    my $origin_version = substr $origin_token, 0, VERSION_LENGTH;
    return 0 if $dk6version != $origin_version;

    my $origin_app_id = substr $origin_token, VERSION_LENGTH, APP_ID_LENGTH;
    my $origin_content = substr $origin_token, VERSION_LENGTH + APP_ID_LENGTH;
    my $origin_content_decoded = decode_base64 $origin_content;
    return 0 unless $origin_content_decoded;

    my $r = _reader->new($origin_content_decoded);

    my $signature        = $r->unpack_string;
    my $crc_channel_name = $r->unpack_uint32;
    my $crc_uid          = $r->unpack_uint32;
    my $msg_raw_content  = $r->unpack_string;

    $r = _reader->new($msg_raw_content);

    $self->{salt}     = $r->unpack_uint32;
    $self->{ts}       = $r->unpack_uint32;
    $self->{messages} = $r->unpack_map_uint32;

    return 1;
}

sub add_privilege {
    my ($self, $privilege, $expire_timestamp) = @_;
    $self->{messages}{$privilege} = $expire_timestamp;
}

sub remove_privilege {
    my ($self, $privilege) = @_;
    delete $self->{messages}{$privilege};
}

sub build {
    my $self = shift;

    my $m = join "",
        _pack_uint32($self->{salt}),
        _pack_uint32($self->{ts}),
        _pack_map_uint32($self->{messages});

    my $val = join "", $self->{app_id}, $self->{channel_name}, $self->{uid}, $m;
    my $sig = hmac_sha256 $val, $self->{app_certificate};

    my $crc_channel_name = crc32($self->{channel_name}) & 0xffffffff;
    my $crc_uid          = crc32($self->{uid}) & 0xffffffff;

    my $content = join "",
        _pack_string($sig),
        _pack_uint32($crc_channel_name),
        _pack_uint32($crc_uid),
        _pack_string($m);

    my $version = get_version;
    return $version . $self->{app_id} . encode_base64($content, "");
}

sub _pack_uint16 {
    my ($i) = @_;
    return pack("S<", $i);
}

sub _pack_uint32 {
    my ($i) = @_;
    return pack("L<", $i);
}

sub _pack_string {
    my ($s) = @_;
    return _pack_uint16(length($s)) . $s;
}

sub _pack_map_uint32 {
    my ($extra) = @_;

    my @keys = sort keys %$extra;
    my $r    = _pack_uint16(scalar(@keys));
    for my $k (@keys) {
        $r .= _pack_uint16($k);
        $r .= _pack_uint32($extra->{$k});
    }
    return $r;
}

{

    package _reader;

    sub new {
        my ($class, $content) = @_;
        bless {
            b => $content,
            p => 0,
        }, $class;
    }

    sub _read_bytes {
        my ($self, $len) = @_;
        my $c = substr $self->{b}, $self->{p}, $len;
        $self->{p} += $len;
        return $c;
    }

    sub unpack_uint16 {
        my $self = shift;
        return unpack("S<", $self->_read_bytes(2));
    }

    sub unpack_uint32 {
        my $self = shift;
        return unpack("L<", $self->_read_bytes(4));
    }

    sub unpack_string {
        my $self = shift;
        my $len  = $self->unpack_uint16;
        return $self->_read_bytes($len);
    }

    sub unpack_map_uint32 {
        my $self = shift;
        my $ret  = {};

        my $len = $self->unpack_uint16;
        for (1 .. $len) {
            my $k = $self->unpack_uint16;
            my $v = $self->unpack_uint32;
            $ret->{$k} = $v;
        }
        return $ret;
    }
}

1
