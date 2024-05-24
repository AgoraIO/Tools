use agora_token::fpa_token_builder;
use std::env;

fn main() {
    // Need to set environment variable AGORA_APP_ID
    let app_id = env::var("AGORA_APP_ID").unwrap();
    // Need to set environment variable AGORA_APP_CERTIFICATE
    let app_certificate = env::var("AGORA_APP_CERTIFICATE").unwrap();

    println!("App Id: {}", app_id);
    println!("App Certificate: {}", app_certificate);

    if app_id.is_empty() || app_certificate.is_empty() {
        println!("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
        return;
    }

    match fpa_token_builder::build_token(&app_id, &app_certificate) {
        Ok(token) => println!("Token with FPA service: {}", token),
        Err(err) => println!("{}", err),
    }
}
