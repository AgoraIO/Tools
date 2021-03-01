namespace AgoraIO.Media
{
    public enum Privileges
    {
        kJoinChannel = 1,
        kPublishAudioStream = 2,
        kPublishVideoStream = 3,
        kPublishDataStream = 4,

        kPublishAudiocdn = 5,
        kPublishVideoCdn = 6,
        kRequestPublishAudioStream = 7,
        kRequestPublishVideoStream = 8,
        kRequestPublishDataStream = 9,
        kInvitePublishAudioStream = 10,
        kInvitePublishVideoStream = 11,
        kInvitePublishDataStream = 12,
        kAdministrateChannel = 101,
        kRtmLogin = 1000
    }
}
