use crate::access_token;
use crate::rtc_token_builder::{Role, ROLE_PUBLISHER};

/// Builds a ConvoAI token with RTC and RTM services.
///
/// # Arguments
///
/// * `app_id` - The App ID issued to you by Agora.
/// * `app_certificate` - Certificate of the application registered in the Agora Dashboard.
/// * `channel_name` - The unique channel name for the Agora RTC session in string format. The string length
///   must be less than 64 bytes. The channel name may contain the following characters:
///   - All lowercase English letters: a to z.
///   - All uppercase English letters: A to Z.
///   - All numeric characters: 0 to 9.
///   - The space character.
///   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
/// * `account` - The account used by both RTC and RTM, max length is 255 bytes.
/// * `token_expire` - The whole token lifetime in seconds from now.
/// * `privilege_expire` - The RTC and RTM privilege lifetime in seconds from now. It must not exceed
///   `token_expire`; otherwise, it is limited by the token expiration time.
///
/// Returns the ConvoAI token.
pub fn build_token(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    account: &str,
    token_expire: u32,
    privilege_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    build_token_with_privilege(
        app_id,
        app_certificate,
        channel_name,
        account,
        ROLE_PUBLISHER,
        token_expire,
        privilege_expire,
        privilege_expire,
        privilege_expire,
        privilege_expire,
        account,
        privilege_expire,
    )
}

/// Builds a ConvoAI token with RTC and RTM services.
///
/// # Arguments
///
/// * `app_id` - The App ID issued to you by Agora.
/// * `app_certificate` - Certificate of the application registered in the Agora Dashboard.
/// * `channel_name` - The unique channel name for the Agora RTC session in string format. The string length
///   must be less than 64 bytes. The channel name may contain the following characters:
///   - All lowercase English letters: a to z.
///   - All uppercase English letters: A to Z.
///   - All numeric characters: 0 to 9.
///   - The space character.
///   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
/// * `rtc_account` - The RTC user's account, max length is 255 bytes.
/// * `rtc_role` - `ROLE_PUBLISHER` for a broadcaster or `ROLE_SUBSCRIBER` for an audience member.
/// * `rtc_token_expire` - Represented by the number of seconds elapsed since now. For example, set it to 600
///   to access the Agora Service within 10 minutes after the token is generated. This is the whole token
///   expiration. The whole token is invalid after this time, even if a privilege expiration time is later.
/// * `join_channel_privilege_expire` - Represented by the number of seconds elapsed since now. For example,
///   set it to 600 to join the channel and stay in it for 10 minutes. It must not exceed
///   `rtc_token_expire`; otherwise, the privilege is limited by the token expiration time.
/// * `pub_audio_privilege_expire` - Represented by the number of seconds elapsed since now. For example, set
///   it to 600 to publish audio for 10 minutes. It must not exceed `rtc_token_expire`; otherwise, the
///   privilege is limited by the token expiration time.
/// * `pub_video_privilege_expire` - Represented by the number of seconds elapsed since now. For example, set
///   it to 600 to publish video for 10 minutes. It must not exceed `rtc_token_expire`; otherwise, the
///   privilege is limited by the token expiration time.
/// * `pub_data_stream_privilege_expire` - Represented by the number of seconds elapsed since now. For
///   example, set it to 600 to publish data streams for 10 minutes. It must not exceed `rtc_token_expire`;
///   otherwise, the privilege is limited by the token expiration time.
/// * `rtm_user_id` - The RTM user's account, max length is 255 bytes.
/// * `rtm_token_expire` - Represented by the number of seconds elapsed since now. For example, set it to 600
///   to access the Agora Service within 10 minutes after the token is generated. It must not exceed
///   `rtc_token_expire`; otherwise, the RTM login privilege is limited by the token expiration time.
///
/// Returns the ConvoAI token.
pub fn build_token_with_privilege(
    app_id: &str,
    app_certificate: &str,
    channel_name: &str,
    rtc_account: &str,
    rtc_role: Role,
    rtc_token_expire: u32,
    join_channel_privilege_expire: u32,
    pub_audio_privilege_expire: u32,
    pub_video_privilege_expire: u32,
    pub_data_stream_privilege_expire: u32,
    rtm_user_id: &str,
    rtm_token_expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, rtc_token_expire);

    let mut service_rtc = access_token::new_service_rtc(channel_name, rtc_account);
    service_rtc.service.add_privilege(access_token::PRIVILEGE_JOIN_CHANNEL, join_channel_privilege_expire);
    if rtc_role == ROLE_PUBLISHER {
        service_rtc.service.add_privilege(access_token::PRIVILEGE_PUBLISH_AUDIO_STREAM, pub_audio_privilege_expire);
        service_rtc.service.add_privilege(access_token::PRIVILEGE_PUBLISH_VIDEO_STREAM, pub_video_privilege_expire);
        service_rtc.service.add_privilege(access_token::PRIVILEGE_PUBLISH_DATA_STREAM, pub_data_stream_privilege_expire);
    }
    token.add_service(Box::new(service_rtc));

    let mut service_rtm = access_token::new_service_rtm(rtm_user_id);
    service_rtm.service.add_privilege(access_token::PRIVILEGE_LOGIN, rtm_token_expire);
    token.add_service(Box::new(service_rtm));

    token.add_service(Box::new(access_token::new_service_convoai()));

    token.build()
}
