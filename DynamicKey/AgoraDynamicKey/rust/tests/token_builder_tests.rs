use agora_token::access_token::{
    self, AccessToken, ServiceApaas, ServiceChat, ServiceFpa, ServiceRtc, ServiceRtm, ServiceRtm2, PRIVILEGE_APAAS_APP, PRIVILEGE_APAAS_ROOM_USER,
    PRIVILEGE_APAAS_USER, PRIVILEGE_CHAT_APP, PRIVILEGE_CHAT_USER, PRIVILEGE_JOIN_CHANNEL, PRIVILEGE_LOGIN, PRIVILEGE_PUBLISH_AUDIO_STREAM,
    PRIVILEGE_PUBLISH_DATA_STREAM, PRIVILEGE_PUBLISH_VIDEO_STREAM, RTM2_PERMISSION_READ, RTM2_PERMISSION_WRITE, RTM2_RESOURCE_MESSAGE_CHANNELS,
    RTM2_RESOURCE_STREAM_CHANNELS, SERVICE_TYPE_APAAS, SERVICE_TYPE_CHAT, SERVICE_TYPE_FPA, SERVICE_TYPE_RTC, SERVICE_TYPE_RTM, SERVICE_TYPE_RTM2,
};
use agora_token::{apaas_token_builder, chat_token_builder, education_token_builder, fpa_token_builder, rtc_token_builder, rtm_token_builder};

const APP_ID: &str = "970CA35de60c44645bbae8a215061b33";
const APP_CERT: &str = "5CFd2fd1755d40ecb72977518be15d3b";
const CHANNEL_NAME: &str = "7d72365eb983485397e3e3f9d460bdda";
const USER_ID: &str = "2882341273";
const EXPIRE: u32 = 600;

/// Parses a generated token and verifies its signature.
fn parse_token(token: String) -> AccessToken {
    let mut parsed = access_token::create_access_token();
    assert!(parsed.parse(&token).unwrap());
    assert!(parsed.verify_signature(APP_CERT));
    parsed
}

/// Returns a parsed service as its concrete type.
fn get_service<T: 'static>(token: &AccessToken, service_type: u16) -> &T {
    token
        .services
        .iter()
        .find(|service| service.get_service_type() == service_type)
        .and_then(|service| service.as_any().downcast_ref::<T>())
        .expect("expected service type")
}

/// Verifies all APaaS token builder methods.
#[test]
fn test_apaas_token_builders() {
    let room_token = apaas_token_builder::build_room_user_token(APP_ID, APP_CERT, "room", USER_ID, 1, EXPIRE).unwrap();
    let parsed = parse_token(room_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!("room", apaas.room_uuid);
    assert_eq!(USER_ID, apaas.user_uuid);
    assert_eq!(1, apaas.role);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_ROOM_USER]);
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTM).len());
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_CHAT).len());

    let user_token = apaas_token_builder::build_user_token(APP_ID, APP_CERT, USER_ID, EXPIRE).unwrap();
    let parsed = parse_token(user_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_USER]);

    let app_token = apaas_token_builder::build_app_token(APP_ID, APP_CERT, EXPIRE).unwrap();
    let parsed = parse_token(app_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_APP]);
}

/// Verifies all Education token builder methods.
#[test]
fn test_education_token_builders() {
    let room_token = education_token_builder::build_room_user_token(APP_ID, APP_CERT, "room", USER_ID, 1, EXPIRE).unwrap();
    let parsed = parse_token(room_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_ROOM_USER]);
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTM).len());
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_CHAT).len());

    let user_token = education_token_builder::build_user_token(APP_ID, APP_CERT, USER_ID, EXPIRE).unwrap();
    let parsed = parse_token(user_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_USER]);

    let app_token = education_token_builder::build_app_token(APP_ID, APP_CERT, EXPIRE).unwrap();
    let parsed = parse_token(app_token);
    let apaas = get_service::<ServiceApaas>(&parsed, SERVICE_TYPE_APAAS);
    assert_eq!(EXPIRE, apaas.service.privileges[&PRIVILEGE_APAAS_APP]);
}

/// Verifies Chat user and application token builders.
#[test]
fn test_chat_token_builders() {
    let user_token = chat_token_builder::build_chat_user_token(APP_ID, APP_CERT, USER_ID, EXPIRE).unwrap();
    let parsed = parse_token(user_token);
    let chat = get_service::<ServiceChat>(&parsed, SERVICE_TYPE_CHAT);
    assert_eq!(USER_ID, chat.user_id);
    assert_eq!(EXPIRE, chat.service.privileges[&PRIVILEGE_CHAT_USER]);

    let app_token = chat_token_builder::build_chat_app_token(APP_ID, APP_CERT, EXPIRE).unwrap();
    let parsed = parse_token(app_token);
    let chat = get_service::<ServiceChat>(&parsed, SERVICE_TYPE_CHAT);
    assert_eq!(EXPIRE, chat.service.privileges[&PRIVILEGE_CHAT_APP]);
}

/// Verifies the FPA token builder.
#[test]
fn test_fpa_token_builder() {
    let parsed = parse_token(fpa_token_builder::build_token(APP_ID, APP_CERT).unwrap());
    let fpa = get_service::<ServiceFpa>(&parsed, SERVICE_TYPE_FPA);
    assert_eq!(0, fpa.service.privileges[&PRIVILEGE_LOGIN]);
}

/// Verifies all RTC token builder methods and privilege variants.
#[test]
fn test_rtc_token_builders() {
    let token = rtc_token_builder::build_token_with_uid(APP_ID, APP_CERT, CHANNEL_NAME, 2882341273, rtc_token_builder::ROLE_PUBLISHER, EXPIRE, EXPIRE).unwrap();
    let parsed = parse_token(token);
    let rtc = get_service::<ServiceRtc>(&parsed, SERVICE_TYPE_RTC);
    assert_eq!(USER_ID, rtc.uid);
    assert_eq!(4, rtc.service.privileges.len());

    let token = rtc_token_builder::build_token_with_user_account(APP_ID, APP_CERT, CHANNEL_NAME, "account", rtc_token_builder::ROLE_SUBSCRIBER, EXPIRE, EXPIRE)
        .unwrap();
    let parsed = parse_token(token);
    let rtc = get_service::<ServiceRtc>(&parsed, SERVICE_TYPE_RTC);
    assert_eq!("account", rtc.uid);
    assert_eq!(1, rtc.service.privileges.len());

    let token = rtc_token_builder::build_token_with_uid_and_privilege(APP_ID, APP_CERT, CHANNEL_NAME, 2882341273, EXPIRE, 1, 2, 3, 4).unwrap();
    let parsed = parse_token(token);
    let rtc = get_service::<ServiceRtc>(&parsed, SERVICE_TYPE_RTC);
    assert_eq!(1, rtc.service.privileges[&PRIVILEGE_JOIN_CHANNEL]);
    assert_eq!(2, rtc.service.privileges[&PRIVILEGE_PUBLISH_AUDIO_STREAM]);
    assert_eq!(3, rtc.service.privileges[&PRIVILEGE_PUBLISH_VIDEO_STREAM]);
    assert_eq!(4, rtc.service.privileges[&PRIVILEGE_PUBLISH_DATA_STREAM]);

    let token = rtc_token_builder::build_token_with_user_account_and_privilege(APP_ID, APP_CERT, CHANNEL_NAME, "account", EXPIRE, 1, 2, 3, 4).unwrap();
    let parsed = parse_token(token);
    let rtc = get_service::<ServiceRtc>(&parsed, SERVICE_TYPE_RTC);
    assert_eq!("account", rtc.uid);
    assert_eq!(4, rtc.service.privileges.len());

    let token = rtc_token_builder::build_token_with_rtm(APP_ID, APP_CERT, CHANNEL_NAME, "account", rtc_token_builder::ROLE_PUBLISHER, EXPIRE, EXPIRE).unwrap();
    let parsed = parse_token(token);
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTC).len());
    assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTM).len());

    let token = rtc_token_builder::build_token_with_rtm2(
        APP_ID,
        APP_CERT,
        CHANNEL_NAME,
        "rtc-account",
        rtc_token_builder::ROLE_PUBLISHER,
        EXPIRE,
        1,
        2,
        3,
        4,
        "rtm-account",
        EXPIRE,
    )
    .unwrap();
    let parsed = parse_token(token);
    let rtm = get_service::<ServiceRtm>(&parsed, SERVICE_TYPE_RTM);
    assert_eq!("rtm-account", rtm.user_id);
}

/// Verifies the RTM token builder.
#[test]
fn test_rtm_token_builder() {
    let parsed = parse_token(rtm_token_builder::build_token(APP_ID, APP_CERT, USER_ID, EXPIRE).unwrap());
    let rtm = get_service::<ServiceRtm>(&parsed, SERVICE_TYPE_RTM);
    assert_eq!(USER_ID, rtm.user_id);
    assert_eq!(EXPIRE, rtm.service.privileges[&PRIVILEGE_LOGIN]);
}

/// Verifies RTM2 token generation, parsing, permissions, and signature validation.
#[test]
fn test_rtm2_token_builder() {
    let mut permissions = access_token::new_rtm2_permissions();
    permissions.add(
        RTM2_RESOURCE_MESSAGE_CHANNELS,
        RTM2_PERMISSION_READ,
        vec!["message-a".to_string(), "message-b".to_string()],
    );
    permissions.add(RTM2_RESOURCE_STREAM_CHANNELS, RTM2_PERMISSION_WRITE, vec!["stream-a".to_string()]);
    let parsed = parse_token(rtm_token_builder::build_token_with_permissions(APP_ID, APP_CERT, USER_ID, &permissions, EXPIRE).unwrap());
    let rtm2 = get_service::<ServiceRtm2>(&parsed, SERVICE_TYPE_RTM2);

    assert_eq!(USER_ID, rtm2.user_id);
    assert_eq!(permissions, rtm2.permissions);
    assert_eq!(EXPIRE, rtm2.service.privileges[&PRIVILEGE_LOGIN]);
}
