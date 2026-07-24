local rtm_token_builder = require("agora_token.rtm_token_builder")

-- Need to set environment variable AGORA_APP_ID
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local user_id = "test_user_id"
local expiration_seconds = 3600

print("App Id: " .. app_id)
print("App Certificate: " .. app_certificate)

if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local status, token = pcall(function()
    return rtm_token_builder.build_token(app_id, app_certificate, user_id, expiration_seconds)
end)

if status then
    print("Rtm Token: " .. token)
else
    print("Error: " .. token)
end
