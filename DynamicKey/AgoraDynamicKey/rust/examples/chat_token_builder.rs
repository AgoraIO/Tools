use agora_token::chat_token_builder;
use std::env;

fn main() {
    // Need to set environment variable AGORA_APP_ID
    let app_id = env::var("AGORA_APP_ID").unwrap();
    // Need to set environment variable AGORA_APP_CERTIFICATE
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap();

    let user_uuid = "a7180cb0-1d4a-11ed-9210-89ff47c9da5e";
    let expire = 600;

    println!("App Id: {}", app_id);
    println!("App Certificate: {}", app_certificate);
    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match chat_token_builder::build_chat_app_token(&app_id, &app_certificate, expire) {
        Ok(result) => println!("ChatAppToken: {}", result),
        Err(err) => println!("{}", err),
    }

    match chat_token_builder::build_chat_user_token(&app_id, &app_certificate, user_uuid, expire) {
        Ok(result) => println!("ChatUserToken: {}", result),
        Err(err) => println!("{}", err),
    }
}
