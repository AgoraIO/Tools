use crate::access_token;

// Build the FPA token.
//
// app_id:          The App ID issued to you by Agora. Apply for a new App ID from
//                  Agora Dashboard if it is missing from your kit. See Get an App ID.
// app_certificate: Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// return The FPA token.
pub fn build_token(
    app_id: &str,
    app_certificate: &str,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut token = access_token::new_access_token(app_id, app_certificate, 24 * 3600);

    let mut service_fpa = access_token::new_service_fpa();
    service_fpa
        .service
        .add_privilege(access_token::PRIVILEGE_LOGIN, 0);
    token.add_service(Box::new(service_fpa));

    return token.build();
}
