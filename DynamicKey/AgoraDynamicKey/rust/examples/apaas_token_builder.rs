use agora_token::apaas_token_builder;
use std::env;

fn main() {
    // Need to set environment variable AGORA_APP_ID
    let app_id = env::var("AGORA_APP_ID").unwrap();
    // Need to set environment variable AGORA_APP_CERTIFICATE
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap();

    let room_uuid = "123";
    let user_uuid = "2882341273";
    let role: i16 = 1;
    let expire: u32 = 600;

    println!("App Id: {}", app_id);
    println!("App Certificate: {}", app_certificate);
    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match apaas_token_builder::build_room_user_token(&app_id, &app_certificate, &room_uuid, &user_uuid, role, expire) {
        Ok(token) => println!("Apaas room user token: {}", token),
        Err(err) => println!("{}", err),
    }

    match apaas_token_builder::build_user_token(&app_id, &app_certificate, &user_uuid, expire) {
        Ok(token) => println!("Apaas user token: {}", token),
        Err(err) => println!("{}", err),
    }

    match apaas_token_builder::build_app_token(&app_id, &app_certificate, expire) {
        Ok(token) => println!("Apaas app token: {}", token),
        Err(err) => println!("{}", err),
    }
}
