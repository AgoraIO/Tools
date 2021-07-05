package Agora::SimpleTokenBuilder;
# this package is port from https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey @8c5941e
use strict;
use warnings;
use utf8;
use 5.010;

use Carp;
use Agora::AccessToken;

use constant {
    Role_Attendee   => 1,
    Role_Publisher  => 2,
    Role_Subscriber => 3,
    Role_Admin      => 4,
};

my $attendee_privileges = {
    Agora::AccessToken::KJoinChannel()        => 0,
    Agora::AccessToken::KPublishAudioStream() => 0,
    Agora::AccessToken::KPublishVideoStream() => 0,
    Agora::AccessToken::KPublishDataStream()  => 0,
};

my $publisher_privileges = {
    Agora::AccessToken::KJoinChannel()              => 0,
    Agora::AccessToken::KPublishAudioStream()       => 0,
    Agora::AccessToken::KPublishVideoStream()       => 0,
    Agora::AccessToken::KPublishDataStream()        => 0,
    Agora::AccessToken::KPublishAudiocdn()          => 0,
    Agora::AccessToken::KPublishVideoCdn()          => 0,
    Agora::AccessToken::KInvitePublishAudioStream() => 0,
    Agora::AccessToken::KInvitePublishVideoStream() => 0,
    Agora::AccessToken::KInvitePublishDataStream()  => 0,
};

my $subscriber_privileges = {
    Agora::AccessToken::KJoinChannel()               => 0,
    Agora::AccessToken::KRequestPublishAudioStream() => 0,
    Agora::AccessToken::KRequestPublishVideoStream() => 0,
    Agora::AccessToken::KRequestPublishDataStream()  => 0,
};

my $admin_privileges = {
    Agora::AccessToken::KJoinChannel()         => 0,
    Agora::AccessToken::KPublishAudioStream()  => 0,
    Agora::AccessToken::KPublishVideoStream()  => 0,
    Agora::AccessToken::KPublishDataStream()   => 0,
    Agora::AccessToken::KAdministrateChannel() => 0,
};

our $RolePrivileges = {
    Role_Attendee()   => $attendee_privileges,
    Role_Publisher()  => $publisher_privileges,
    Role_Subscriber() => $subscriber_privileges,
    Role_Admin()      => $admin_privileges,
};

sub create_simple_token_builder {
    my ($app_id, $app_certificate, $channel_name, $uid) = @_;
    return __PACKAGE__->new(
        token => Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, $uid),
    );
}

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    if (grep { !exists $args{$_} } qw/token/) {
        Carp::croak("invalide paramaters");
    }
    bless \%args, $class;
}

sub init_privileges {
    my ($self, $role) = @_;
    my $privileges = $RolePrivileges->{$role}
        or Carp::croak "not defined role [$role]";

    while (my ($k, $v) = each %$privileges) {
        $self->{token}->add_privilege($k, $v);
    }
}

sub init_token_builder {
    my ($self, $origin_token) = @_;
    return $self->{token}->from_string($origin_token);
}

sub set_privilege {
    my ($self, $privilege, $expire_timestamp) = @_;
    $self->{token}->add_privilege($privilege, $expire_timestamp);
}

sub remove_privilege {
    my ($self, $privilege) = @_;
    $self->{token}->remove_privilege($privilege);
}

sub build_token {
    my $self = shift;
    return $self->{token}->build;
}

1;
