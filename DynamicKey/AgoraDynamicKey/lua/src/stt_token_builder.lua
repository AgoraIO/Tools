local access_token = require("agora_token.access_token")
local rtc_token_builder = require("agora_token.rtc_token_builder")

-- Builds a Token007 that carries RTC, RTM, and STT services.
-- rtc_token_expire is the whole token expiration. The whole token is invalid after this time.
-- RTC privilege expiration values and rtm_token_expire must not exceed rtc_token_expire.
local function build_token(app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
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

    token:add_service(access_token.new_service_stt())

    return token:build()
end

return {
    build_token = build_token,
}
