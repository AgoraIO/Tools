use agora_token::rtc_token_builder;
use agora_token::stt_token_builder;
use std::env;

fn main() {
    let app_id = env::var("AGORA_APP_ID").unwrap_or_default();
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap_or_default();

    let channel_name = "stt-channel";
    let rtc_account = "stt-rtc-user";
    let rtc_role = rtc_token_builder::ROLE_PUBLISHER;
    let rtc_token_expire = 3600;
    let join_channel_privilege_expire = 3600;
    let pub_audio_privilege_expire = 3600;
    let pub_video_privilege_expire = 3600;
    let pub_data_stream_privilege_expire = 3600;
    let rtm_user_id = "stt-rtm-user";
    let rtm_token_expire = 3600;

    println!("App Id: {}", app_id);
    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match stt_token_builder::build_token(
        &app_id,
        &app_certificate,
        channel_name,
        rtc_account,
        rtc_role,
        rtc_token_expire,
        join_channel_privilege_expire,
        pub_audio_privilege_expire,
        pub_video_privilege_expire,
        pub_data_stream_privilege_expire,
        rtm_user_id,
        rtm_token_expire,
    ) {
        Ok(result) => println!("STT token: {}", result),
        Err(err) => println!("{}", err),
    }
}
