use crate::access_token;

// Role type
pub type Role = u16;

// RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
// your scenario does not require authentication for
// [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
pub const ROLE_PUBLISHER: Role = 1;

// Only use this role if your scenario require authentication for
// [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
// @note In order for this role to take effect, please contact our support team
// to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
// still has the same privileges as Role_Publisher.
pub const ROLE_SUBSCRIBER: Role = 2;

// Build the RTC token with uid.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from
//     Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in
//     the Agora Dashboard. See Get an App Certificate.
// channel_name: Unique channel name for the AgoraRTC session in the string format
// uid: User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1). optionalUid must be unique.
// role: RolePublisher: A broadcaster/host in a live-broadcast profile.
//     RoleSubscriber: An audience(default) in a live-broadcast profile.
// expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
//     Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
// token_expire: represented by the number of seconds elapsed since now. If, for example,
//     you want to access the Agora Service within 10 minutes after the token is generated,
//     set token_expire as 600(seconds).
// privilege_expire: represented by the number of seconds elapsed since now. If, for example,
//     you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
// return The RTC token.
pub fn build_token_with_uid(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    uid: u32,
    role: Role,
    token_expire: u32,
    privilege_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    build_token_with_user_account(
        app_id,
        app_certificate,
        channel_name,
        &access_token::get_uid_str(uid),
        role,
        token_expire,
        privilege_expire,
    )
}

// Build the RTC token with account.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from
//     Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in
//     the Agora Dashboard. See Get an App Certificate.
// channel_name: Unique channel name for the AgoraRTC session in the string format
// account: The user's account, max length is 255 Bytes.
// role: RolePublisher: A broadcaster/host in a live-broadcast profile.
//     RoleSubscriber: An audience(default) in a live-broadcast profile.
// token_expire: represented by the number of seconds elapsed since now. If, for example,
//     you want to access the Agora Service within 10 minutes after the token is generated,
//     set token_expire as 600(seconds).
// privilege_expire: represented by the number of seconds elapsed since now. If, for example,
//     you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
// return The RTC token.
pub fn build_token_with_user_account(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    account: &str,
    role: Role,
    token_expire: u32,
    privilege_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, token_expire);

    let mut service_rtc = access_token::new_service_rtc(channel_name, account);
    service_rtc
        .service
        .add_privilege(access_token::PRIVILEGE_JOIN_CHANNEL, privilege_expire);
    if role == ROLE_PUBLISHER {
        service_rtc.service.add_privilege(
            access_token::PRIVILEGE_PUBLISH_AUDIO_STREAM,
            privilege_expire,
        );
        service_rtc.service.add_privilege(
            access_token::PRIVILEGE_PUBLISH_VIDEO_STREAM,
            privilege_expire,
        );
        service_rtc.service.add_privilege(
            access_token::PRIVILEGE_PUBLISH_DATA_STREAM,
            privilege_expire,
        );
    }
    token.add_service(Box::new(service_rtc));

    return token.build();
}

// Generates an RTC token with the specified privilege.
//
// This method supports generating a token with the following privileges:
// - Joining an RTC channel.
// - Publishing audio in an RTC channel.
// - Publishing video in an RTC channel.
// - Publishing data streams in an RTC channel.
//
// The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
// enabled go-host authentication.
//
// A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
// The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
// or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
// the respective timestamp for each privilege in your app logic. After receiving the callback, you need
// to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
// the channel.
//
// Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
// Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
// When the token for joining the channel expires, the user is immediately kicked off the RTC channel
// and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
pub fn build_token_with_uid_and_privilege(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    uid: u32,
    token_expire: u32,
    join_channel_privilege_expire: u32,
    pub_audio_privilege_expire: u32,
    pub_video_privilege_expire: u32,
    pub_data_stream_privilege_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    build_token_with_user_account_and_privilege(
        app_id,
        app_certificate,
        channel_name,
        &access_token::get_uid_str(uid),
        token_expire,
        join_channel_privilege_expire,
        pub_audio_privilege_expire,
        pub_video_privilege_expire,
        pub_data_stream_privilege_expire,
    )
}

// Generates an RTC token with the specified privilege.
//
// This method supports generating a token with the following privileges:
// - Joining an RTC channel.
// - Publishing audio in an RTC channel.
// - Publishing video in an RTC channel.
// - Publishing data streams in an RTC channel.
//
// The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
// enabled co-host authentication.
//
// A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
// The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
// or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
// the respective timestamp for each privilege in your app logic. After receiving the callback, you need
// to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
// the channel.
//
// @note
// Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
// Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
// When the token for joining the channel expires, the user is immediately kicked off the RTC channel
// and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
pub fn build_token_with_user_account_and_privilege(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    account: &str,
    token_expire: u32,
    join_channel_privilege_expire: u32,
    pub_audio_privilege_expire: u32,
    pub_video_privilege_expire: u32,
    pub_data_stream_privilege_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, token_expire);

    let mut service_rtc = access_token::new_service_rtc(channel_name, account);
    service_rtc.service.add_privilege(
        access_token::PRIVILEGE_JOIN_CHANNEL,
        join_channel_privilege_expire,
    );
    service_rtc.service.add_privilege(
        access_token::PRIVILEGE_PUBLISH_AUDIO_STREAM,
        pub_audio_privilege_expire,
    );
    service_rtc.service.add_privilege(
        access_token::PRIVILEGE_PUBLISH_VIDEO_STREAM,
        pub_video_privilege_expire,
    );
    service_rtc.service.add_privilege(
        access_token::PRIVILEGE_PUBLISH_DATA_STREAM,
        pub_data_stream_privilege_expire,
    );
    token.add_service(Box::new(service_rtc));

    return token.build();
}
