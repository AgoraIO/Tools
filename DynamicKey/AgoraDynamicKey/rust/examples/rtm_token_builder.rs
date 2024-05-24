use agora_token::rtm_token_builder;
use std::env;

fn main() {
    // Need to set environment variable AGORA_APP_ID
    let app_id = env::var("AGORA_APP_ID").unwrap();
    // Need to set environment variable AGORA_APP_CERTIFICATE
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap();

    let user_id = "test_user_id";
    let expiration_seconds: u32 = 3600;

    println!("App Id: {}", app_id);
    println!("App Certificate: {}", app_certificate);

    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match rtm_token_builder::build_token(&app_id, &app_certificate, &user_id, expiration_seconds) {
        Ok(result) => println!("Rtm Token: {}", result),
        Err(err) => println!("{}", err),
    }
}
