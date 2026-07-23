local access_token = require("agora_token.access_token")

-- Need to set environment variable AGORA_APP_ID.
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE.
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local channel_name = "7d72365eb983485397e3e3f9d460bdda"
local account = "2882341273"
local expiration_in_seconds = 3600

if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    os.exit(1)
end

local token = access_token.new_access_token(app_id, app_certificate, expiration_in_seconds)

local rtc_service = access_token.new_service_rtc(channel_name, account)
rtc_service.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, expiration_in_seconds)
token:add_service(rtc_service)

local rtm_service = access_token.new_service_rtm(account)
rtm_service.service:add_privilege(access_token.PRIVILEGE_LOGIN, expiration_in_seconds)
token:add_service(rtm_service)

local stream_rtc_service = access_token.new_service_rtc(channel_name, account)
stream_rtc_service.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, expiration_in_seconds)
stream_rtc_service.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, expiration_in_seconds)
token:add_service(stream_rtc_service)

local chat_service = access_token.new_service_chat(account)
chat_service.service:add_privilege(access_token.PRIVILEGE_CHAT_USER, expiration_in_seconds)
token:add_service(chat_service)

print("The token for RTC, RTM, RTC stream, and Chat is: " .. token:build())
