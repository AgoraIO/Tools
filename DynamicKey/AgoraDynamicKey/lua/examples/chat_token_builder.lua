local chat_token_builder = require("agora_token.chat_token_builder")

-- Need to set environment variable AGORA_APP_ID
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local user_uuid = "a7180cb0-1d4a-11ed-9210-89ff47c9da5e"
local expire = 600

print("App Id: " .. app_id)
print("App Certificate: " .. app_certificate)
if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local status, token = pcall(function()
    return chat_token_builder.build_chat_app_token(app_id, app_certificate, expire)
end)
if status then
    print("ChatAppToken: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return chat_token_builder.build_chat_user_token(app_id, app_certificate, user_uuid, expire)
end)
if status then
    print("ChatUserToken: " .. token)
else
    print("Error: " .. token)
end
