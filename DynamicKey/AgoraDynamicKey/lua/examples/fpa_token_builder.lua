local fpa_token_builder = require("agora_token.fpa_token_builder")

-- Need to set environment variable AGORA_APP_ID
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

print("App Id: " .. app_id)
print("App Certificate: " .. app_certificate)

if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local status, token = pcall(function()
    return fpa_token_builder.build_token(app_id, app_certificate)
end)
if status then
    print("Token with FPA service: " .. token)
else
    print("Error: " .. token)
end
