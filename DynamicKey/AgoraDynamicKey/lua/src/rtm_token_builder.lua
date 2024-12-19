local access_token = require("agora_token.access_token")

-- Build the RTM token.
--
-- app_id:           The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate:  Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
-- user_id:          The user's account, max length is 64 Bytes.
-- expire:           represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- return The RTM token.
local function build_token(app_id, app_certificate, user_id, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)

    local service_rtm = access_token.new_service_rtm(user_id)
    service_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, expire)
    token:add_service(service_rtm)

    return token:build()
end

return {
    build_token = build_token,
}
