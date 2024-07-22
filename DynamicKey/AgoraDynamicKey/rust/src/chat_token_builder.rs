use crate::access_token;

// Build the chat user token.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// user_uuid: The user's id, must be unique.
// expire: represented by the number of seconds elapsed since
// 1/1/1970. If, for example, you want to access the
// Agora Service within 10 minutes after the token is
// generated, set expireTimestamp as the current timestamp + 600 (seconds).
// @return The Chat User token.
pub fn build_chat_user_token(
    app_id: &str,
    app_certificate: &str,
    user_uuid: &str,
    expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut access_token = access_token::new_access_token(app_id, app_certificate, expire);
    let mut service_chat = access_token::new_service_chat(user_uuid);
    service_chat
        .service
        .add_privilege(access_token::PRIVILEGE_CHAT_USER, expire);
    access_token.add_service(Box::new(service_chat));

    return access_token.build();
}

// Build the chat app token.
//
// app_id: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// expire: represented by the number of seconds elapsed since
// 1/1/1970. If, for example, you want to access the
// Agora Service within 10 minutes after the token is
// generated, set expireTimestamp as the current timestamp + 600 (seconds).
// @return The Chat App token.
pub fn build_chat_app_token(
    app_id: &str,
    app_certificate: &str,
    expire: u32,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut access_token = access_token::new_access_token(app_id, app_certificate, expire);

    let mut service_chat = access_token::new_service_chat("");
    service_chat
        .service
        .add_privilege(access_token::PRIVILEGE_CHAT_APP, expire);
    access_token.add_service(Box::new(service_chat));

    return access_token.build();
}
