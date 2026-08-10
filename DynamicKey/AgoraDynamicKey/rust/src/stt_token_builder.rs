use crate::access_token;
use crate::rtc_token_builder::{Role, ROLE_PUBLISHER};

/// Builds a Token007 that carries RTC, RTM, and STT services.
pub fn build_token(
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

    token.add_service(Box::new(access_token::new_service_stt()));

    token.build()
}
