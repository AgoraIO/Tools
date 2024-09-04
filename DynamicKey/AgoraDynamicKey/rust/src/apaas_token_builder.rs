use crate::access_token;
use crate::utils;

// Build room user token.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// room_uuid: The room's id, must be unique.
// user_uuid: The user's id, must be unique.
// role: The user's role.
// expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current timestamp + 600 (seconds).
// return The room user token.
pub fn build_room_user_token(
    app_id: &str, app_certificate: &str, room_uuid: &str, user_uuid: &str, role: i16, expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, expire);

    let chat_user_id = utils::md5(user_uuid);
    let mut service_apaas = access_token::new_service_apaas(room_uuid, user_uuid, role);
    service_apaas.service.add_privilege(access_token::PRIVILEGE_APAAS_ROOM_USER, expire);
    token.add_service(Box::new(service_apaas));

    let mut service_rtm = access_token::new_service_rtm(user_uuid);
    service_rtm.service.add_privilege(access_token::PRIVILEGE_LOGIN, expire);
    token.add_service(Box::new(service_rtm));

    let mut service_chat = access_token::new_service_chat(&chat_user_id);
    service_chat.service.add_privilege(access_token::PRIVILEGE_CHAT_USER, expire);
    token.add_service(Box::new(service_chat));

    return token.build();
}

// Build user token.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// user_uuid: The user's id, must be unique.
// expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current timestamp + 600 (seconds).
// return The user token.
pub fn build_user_token(app_id: &str, app_certificate: &str, user_uuid: &str, expire: u32) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, expire);

    let mut service_apaas = access_token::new_service_apaas("", user_uuid, -1);
    service_apaas.service.add_privilege(access_token::PRIVILEGE_APAAS_USER, expire);
    token.add_service(Box::new(service_apaas));

    return token.build();
}

// Build app token.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current timestamp + 600 (seconds).
// return The app token.
pub fn build_app_token(app_id: &str, app_certificate: &str, expire: u32) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, expire);

    let mut service_apaas = access_token::new_service_apaas("", "", -1);
    service_apaas.service.add_privilege(access_token::PRIVILEGE_APAAS_APP, expire);
    token.add_service(Box::new(service_apaas));

    return token.build();
}
