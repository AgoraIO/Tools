use agora_token::rtc_token_builder;
use std::env;

fn main() {
    // Need to set environment variable AGORA_APP_ID
    let app_id = env::var("AGORA_APP_ID").unwrap();
    // Need to set environment variable AGORA_APP_CERTIFICATE
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap();

    let channel_name = "7d72365eb983485397e3e3f9d460bdda";
    let uid = 2882341273;
    let uid_str = "2882341273";
    let token_expiration_in_seconds = 3600;
    let privilege_expiration_in_seconds = 3600;
    let join_channel_privilege_expire_in_seconds = 3600;
    let pub_audio_privilege_expire_in_seconds = 3600;
    let pub_video_privilege_expire_in_seconds = 3600;
    let pub_data_stream_privilege_expire_in_seconds = 3600;

    println!("App Id: {}", app_id);
    println!("App Certificate: {}", app_certificate);
    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match rtc_token_builder::build_token_with_uid(
        &app_id,
        &app_certificate,
        &channel_name,
        uid,
        rtc_token_builder::ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds,
    ) {
        Ok(result) => println!("Token with int uid: {}", result),
        Err(err) => println!("{}", err),
    }

    match rtc_token_builder::build_token_with_user_account(
        &app_id,
        &app_certificate,
        &channel_name,
        &uid_str,
        rtc_token_builder::ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds,
    ) {
        Ok(result) => println!("Token with user account: {}", result),
        Err(err) => println!("{}", err),
    }

    match rtc_token_builder::build_token_with_uid_and_privilege(
        &app_id,
        &app_certificate,
        &channel_name,
        uid,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds,
    ) {
        Ok(result) => println!("Token with int uid and privilege: {}", result),
        Err(err) => println!("{}", err),
    }

    match rtc_token_builder::build_token_with_user_account_and_privilege(
        &app_id,
        &app_certificate,
        &channel_name,
        &uid_str,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds,
    ) {
        Ok(result) => println!("Token with user account and privilege: {}", result),
        Err(err) => println!("{}", err),
    }

    match rtc_token_builder::build_token_with_rtm(
        &app_id,
        &app_certificate,
        &channel_name,
        &uid_str,
        rtc_token_builder::ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds,
    ) {
        Ok(result) => println!("Token with RTM: {}", result),
        Err(err) => println!("{}", err),
    }

    match rtc_token_builder::build_token_with_rtm2(
        &app_id,
        &app_certificate,
        &channel_name,
        &uid_str,
        rtc_token_builder::ROLE_PUBLISHER,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds,
        &uid_str,
        token_expiration_in_seconds,
    ) {
        Ok(result) => println!("Token with RTM: {}", result),
        Err(err) => println!("{}", err),
    }
}
