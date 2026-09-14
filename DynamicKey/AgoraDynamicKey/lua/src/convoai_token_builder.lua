local access_token = require("agora_token.access_token")
local rtc_token_builder = require("agora_token.rtc_token_builder")

-- Builds a ConvoAI token with RTC and RTM services.
-- app_id: The App ID issued to you by Agora.
-- app_certificate: Certificate of the application registered in the Agora Dashboard.
-- channel_name: The unique channel name for the Agora RTC session in string format. The string length must
-- be less than 64 bytes. The channel name may contain the following characters:
-- - All lowercase English letters: a to z.
-- - All uppercase English letters: A to Z.
-- - All numeric characters: 0 to 9.
-- - The space character.
-- - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
-- rtc_account: The RTC user's account, max length is 255 bytes.
-- rtc_role: ROLE_PUBLISHER for a broadcaster or ROLE_SUBSCRIBER for an audience member.
-- rtc_token_expire: Represented by the number of seconds elapsed since now. For example, set it to 600 to
-- access the Agora Service within 10 minutes after the token is generated. This is the whole token expiration.
-- join_channel_privilege_expire: Represented by the number of seconds elapsed since now. For example, set it
-- to 600 to join the channel and stay in it for 10 minutes.
-- pub_audio_privilege_expire: Represented by the number of seconds elapsed since now. For example, set it to
-- 600 to publish audio for 10 minutes.
-- pub_video_privilege_expire: Represented by the number of seconds elapsed since now. For example, set it to
-- 600 to publish video for 10 minutes.
-- pub_data_stream_privilege_expire: Represented by the number of seconds elapsed since now. For example, set
-- it to 600 to publish data streams for 10 minutes.
-- rtm_user_id: The RTM user's account, max length is 255 bytes.
-- rtm_token_expire: Represented by the number of seconds elapsed since now. For example, set it to 600 to
-- access the Agora Service within 10 minutes after the token is generated.
-- All privilege expiration values must not exceed rtc_token_expire; otherwise, they are limited by the token
-- expiration time. The whole token is invalid after rtc_token_expire, even if a privilege expires later.
-- return: The ConvoAI token.
local function build_token_with_privilege(app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
                           join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
                           pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire)
    local token = access_token.new_access_token(app_id, app_certificate, rtc_token_expire)

    local service_rtc = access_token.new_service_rtc(channel_name, rtc_account)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, join_channel_privilege_expire)
    if rtc_role == rtc_token_builder.ROLE_PUBLISHER then
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM, pub_audio_privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_VIDEO_STREAM, pub_video_privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, pub_data_stream_privilege_expire)
    end
    token:add_service(service_rtc)

    local service_rtm = access_token.new_service_rtm(rtm_user_id)
    service_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, rtm_token_expire)
    token:add_service(service_rtm)

    token:add_service(access_token.new_service_convoai())

    return token:build()
end

-- Builds a ConvoAI token with RTC and RTM services.
-- app_id: The App ID issued to you by Agora.
-- app_certificate: Certificate of the application registered in the Agora Dashboard.
-- channel_name: The unique channel name for the Agora RTC session in string format. The string length must
-- be less than 64 bytes. The channel name may contain the following characters:
-- - All lowercase English letters: a to z.
-- - All uppercase English letters: A to Z.
-- - All numeric characters: 0 to 9.
-- - The space character.
-- - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
-- account: The account used by both RTC and RTM, max length is 255 bytes.
-- token_expire: The whole token lifetime in seconds from now. Defaults to 86400.
-- privilege_expire: The RTC and RTM privilege lifetime in seconds from now. Defaults to 0 and must not
-- exceed token_expire; otherwise, it is limited by the token expiration time.
-- return: The ConvoAI token.
local function build_token(app_id, app_certificate, channel_name, account, token_expire, privilege_expire)
    token_expire = token_expire or 86400
    privilege_expire = privilege_expire or 0
    return build_token_with_privilege(
        app_id, app_certificate, channel_name, account, rtc_token_builder.ROLE_PUBLISHER,
        token_expire, privilege_expire, privilege_expire, privilege_expire, privilege_expire,
        account, privilege_expire)
end

return {
    build_token = build_token,
    build_token_with_privilege = build_token_with_privilege,
}
