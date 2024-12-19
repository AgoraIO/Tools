local apaas_token_builder = require("agora_token.apaas_token_builder")

-- Need to set environment variable AGORA_APP_ID
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local room_uuid = "123"
local user_uuid = "2882341273"
local role = 1
local expire = 600

print("App Id: " .. app_id)
print("App Certificate: " .. app_certificate)
if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local status, token = pcall(function()
    return apaas_token_builder.build_room_user_token(app_id, app_certificate, room_uuid, user_uuid, role, expire)
end)
if status then
    print("Apaas room user token: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return apaas_token_builder.build_user_token(app_id, app_certificate, user_uuid, expire)
end)
if status then
    print("Apaas user token: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return apaas_token_builder.build_app_token(app_id, app_certificate, expire)
end)
if status then
    print("Apaas app token: " .. token)
else
    print("Error: " .. token)
end
