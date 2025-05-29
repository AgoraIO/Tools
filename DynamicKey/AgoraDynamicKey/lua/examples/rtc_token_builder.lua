local rtc_token_builder = require("agora_token.rtc_token_builder")

-- Need to set environment variable AGORA_APP_ID
local app_id = os.getenv("AGORA_APP_ID") or ""
-- Need to set environment variable AGORA_APP_CERTIFICATE
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local channel_name = "7d72365eb983485397e3e3f9d460bdda"
local uid = 2882341273
local uid_str = "2882341273"
local token_expiration_in_seconds = 3600
local privilege_expiration_in_seconds = 3600
local join_channel_privilege_expire_in_seconds = 3600
local pub_audio_privilege_expire_in_seconds = 3600
local pub_video_privilege_expire_in_seconds = 3600
local pub_data_stream_privilege_expire_in_seconds = 3600

print("App Id: " .. app_id)
print("App Certificate: " .. app_certificate)
if app_id == nil or app_certificate == nil or app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local status, token = pcall(function()
    return rtc_token_builder.build_token_with_uid(
        app_id,
        app_certificate,
        channel_name,
        uid,
        rtc_token_builder.ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds)
end)

if status then
    print("Token with int uid: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return rtc_token_builder.build_token_with_user_account(
        app_id,
        app_certificate,
        channel_name,
        uid_str,
        rtc_token_builder.ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds
    )
end)

if status then
    print("Token with user account: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return rtc_token_builder.build_token_with_uid_and_privilege(
        app_id,
        app_certificate,
        channel_name,
        uid,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds
    )
end)

if status then
    print("Token with int uid and privilege: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return rtc_token_builder.build_token_with_user_account_and_privilege(
        app_id,
        app_certificate,
        channel_name,
        uid_str,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds
    )
end)

if status then
    print("Token with user account and privilege: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return rtc_token_builder.build_token_with_rtm(
        app_id,
        app_certificate,
        channel_name,
        uid_str,
        rtc_token_builder.ROLE_PUBLISHER,
        token_expiration_in_seconds,
        privilege_expiration_in_seconds
    )
end)

if status then
    print("Token with RTM: " .. token)
else
    print("Error: " .. token)
end

status, token = pcall(function()
    return rtc_token_builder.build_token_with_rtm2(
        app_id,
        app_certificate,
        channel_name,
        uid_str,
        rtc_token_builder.ROLE_PUBLISHER,
        token_expiration_in_seconds,
        join_channel_privilege_expire_in_seconds,
        pub_audio_privilege_expire_in_seconds,
        pub_video_privilege_expire_in_seconds,
        pub_data_stream_privilege_expire_in_seconds,
        uid_str,
        token_expiration_in_seconds
    )
end)

if status then
    print("Token with RTM: " .. token)
else
    print("Error: " .. token)
end
