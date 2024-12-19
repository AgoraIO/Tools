local access_token = require("agora_token.access_token")
local utils = require("agora_token.utils")

-- Build room user token.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
-- room_uuid: The room's id, must be unique.
-- user_uuid: The user's id, must be unique.
-- role: The user's role.
-- expire: represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- return The room user token.
local function build_room_user_token(app_id, app_certificate, room_uuid, user_uuid, role, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)

    local chat_user_id = utils.md5_hash(user_uuid)
    local service_apaas = access_token.new_service_apaas(room_uuid, user_uuid, role)
    service_apaas.service:add_privilege(access_token.PRIVILEGE_APAAS_ROOM_USER, expire)
    token:add_service(service_apaas)

    local service_rtm = access_token.new_service_rtm(user_uuid)
    service_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, expire)
    token:add_service(service_rtm)

    local service_chat = access_token.new_service_chat(chat_user_id)
    service_chat.service:add_privilege(access_token.PRIVILEGE_CHAT_USER, expire)
    token:add_service(service_chat)

    return token:build()
end

-- Build user token.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
-- user_uuid: The user's id, must be unique.
-- expire: represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- return The user token.
local function build_user_token(app_id, app_certificate, user_uuid, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)

    local service_apaas = access_token.new_service_apaas("", user_uuid, -1)
    service_apaas.service:add_privilege(access_token.PRIVILEGE_APAAS_USER, expire)
    token:add_service(service_apaas)

    return token:build()
end

-- Build app token.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
-- expire: represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
-- return The app token.
local function build_app_token(app_id, app_certificate, expire)
    local token = access_token.new_access_token(app_id, app_certificate, expire)

    local service_apaas = access_token.new_service_apaas("", "", -1)
    service_apaas.service:add_privilege(access_token.PRIVILEGE_APAAS_APP, expire)
    token:add_service(service_apaas)

    return token:build()
end

return {
    build_room_user_token = build_room_user_token,
    build_user_token = build_user_token,
    build_app_token = build_app_token,
}
