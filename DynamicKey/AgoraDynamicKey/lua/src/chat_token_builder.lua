local access_token = require("agora_token.access_token")

-- Build the chat user token.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from
-- Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in
-- the Agora Dashboard. See Get an App Certificate.
-- user_uuid: The user's id, must be unique.
-- expire: represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- @return The Chat User token.
local function build_chat_user_token(app_id, app_certificate, user_uuid, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)
    local service_chat = access_token.new_service_chat(user_uuid)
    service_chat.service:add_privilege(access_token.PRIVILEGE_CHAT_USER, expire)
    token:add_service(service_chat)

    return token:build()
end

-- Build the chat app token.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from
-- Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in
-- the Agora Dashboard. See Get an App Certificate.
-- expire: represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- @return The Chat App token.
local function build_chat_app_token(app_id, app_certificate, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)

    local service_chat = access_token.new_service_chat("")
    service_chat.service:add_privilege(access_token.PRIVILEGE_CHAT_APP, expire)
    token:add_service(service_chat)

    return token:build()
end

return {
    build_chat_user_token = build_chat_user_token,
    build_chat_app_token = build_chat_app_token,
}
