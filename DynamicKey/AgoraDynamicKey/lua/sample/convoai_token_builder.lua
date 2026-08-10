local convoai_token_builder = require("agora_token.convoai_token_builder")
local rtc_token_builder = require("agora_token.rtc_token_builder")

local app_id = os.getenv("AGORA_APP_ID") or ""
local app_certificate = os.getenv("AGORA_APP_CERTIFICATE") or ""

local channel_name = "convoai-channel"
local rtc_account = "convoai-rtc-user"
local rtc_role = rtc_token_builder.ROLE_PUBLISHER
local rtc_token_expire = 3600
local join_channel_privilege_expire = 3600
local pub_audio_privilege_expire = 3600
local pub_video_privilege_expire = 3600
local pub_data_stream_privilege_expire = 3600
local rtm_user_id = "convoai-rtm-user"
local rtm_token_expire = 3600

print("App Id: " .. app_id)
if app_id == "" or app_certificate == "" then
    print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
    return
end

local token = convoai_token_builder.build_token(
    app_id,
    app_certificate,
    channel_name,
    rtc_account,
    rtc_role,
    rtc_token_expire,
    join_channel_privilege_expire,
    pub_audio_privilege_expire,
    pub_video_privilege_expire,
    pub_data_stream_privilege_expire,
    rtm_user_id,
    rtm_token_expire
)
print("ConvoAI token: " .. token)
