local access_token = require("agora_token.access_token")

-- RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
-- your scenario does not require authentication for
-- [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
local ROLE_PUBLISHER = 1

-- Only use this role if your scenario requires authentication for
-- [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
-- @note In order for this role to take effect, please contact our support team
-- to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
-- still has the same privileges as Role_Publisher.
local ROLE_SUBSCRIBER = 2

local build_token_with_user_account
local build_token_with_user_account_and_privilege

-- Build the RTC token with uid.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from
--     Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in
--     the Agora Dashboard. See Get an App Certificate.
-- channel_name: Unique channel name for the AgoraRTC session in the string format
-- uid: User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1). uid must be unique.
-- role: RolePublisher: A broadcaster/host in a live-broadcast profile.
--     RoleSubscriber: An audience(default) in a live-broadcast profile.
-- token_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to access the Agora Service within 10 minutes after the token is generated,
--     set token_expire as 600(seconds).
-- privilege_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
-- return The RTC token.
local function build_token_with_uid(app_id, app_certificate, channel_name, uid, role, token_expire, privilege_expire)
    return build_token_with_user_account(
        app_id,
        app_certificate,
        channel_name,
        access_token.get_uid_str(uid),
        role,
        token_expire,
        privilege_expire
    )
end

-- Build the RTC token with account.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from
--     Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in
--     the Agora Dashboard. See Get an App Certificate.
-- channel_name: Unique channel name for the AgoraRTC session in the string format
-- account: The user's account, max length is 255 Bytes.
-- role: RolePublisher: A broadcaster/host in a live-broadcast profile.
--     RoleSubscriber: An audience(default) in a live-broadcast profile.
-- token_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to access the Agora Service within 10 minutes after the token is generated,
--     set token_expire as 600(seconds).
-- privilege_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
-- return The RTC token.
build_token_with_user_account = function(app_id, app_certificate, channel_name, account, role, token_expire,
                                         privilege_expire)
    local token = access_token.new_access_token(app_id, app_certificate, token_expire)

    local service_rtc = access_token.new_service_rtc(channel_name, account)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, privilege_expire)
    if role == ROLE_PUBLISHER then
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM, privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_VIDEO_STREAM, privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, privilege_expire)
    end
    token:add_service(service_rtc)

    return token:build()
end

-- Generates an RTC token with the specified privilege.
--
-- This method supports generating a token with the following privileges:
-- - Joining an RTC channel.
-- - Publishing audio in an RTC channel.
-- - Publishing video in an RTC channel.
-- - Publishing data streams in an RTC channel.
--
-- The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
-- enabled co-host authentication.
--
-- A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
-- The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
-- or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
-- the respective timestamp for each privilege in your app logic. After receiving the callback, you need
-- to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
-- the channel.
--
-- Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
-- Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
-- When the token for joining the channel expires, the user is immediately kicked off the RTC channel
-- and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
local function build_token_with_uid_and_privilege(app_id, app_certificate, channel_name, uid, token_expire,
                                                  join_channel_privilege_expire, pub_audio_privilege_expire,
                                                  pub_video_privilege_expire, pub_data_stream_privilege_expire)
    return build_token_with_user_account_and_privilege(
        app_id,
        app_certificate,
        channel_name,
        access_token.get_uid_str(uid),
        token_expire,
        join_channel_privilege_expire,
        pub_audio_privilege_expire,
        pub_video_privilege_expire,
        pub_data_stream_privilege_expire
    )
end

-- Generates an RTC token with the specified privilege.
--
-- This method supports generating a token with the following privileges:
-- - Joining an RTC channel.
-- - Publishing audio in an RTC channel.
-- - Publishing video in an RTC channel.
-- - Publishing data streams in an RTC channel.
--
-- The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
-- enabled co-host authentication.
--
-- A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
-- The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
-- or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
-- the respective timestamp for each privilege in your app logic. After receiving the callback, you need
-- to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
-- the channel.
--
-- @note
-- Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
-- Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
-- When the token for joining the channel expires, the user is immediately kicked off the RTC channel
-- and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
build_token_with_user_account_and_privilege = function(app_id, app_certificate, channel_name, account, token_expire,
                                                       join_channel_privilege_expire, pub_audio_privilege_expire,
                                                       pub_video_privilege_expire, pub_data_stream_privilege_expire)
    local token = access_token.new_access_token(app_id, app_certificate, token_expire)

    local service_rtc = access_token.new_service_rtc(channel_name, account)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, join_channel_privilege_expire)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM, pub_audio_privilege_expire)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_VIDEO_STREAM, pub_video_privilege_expire)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, pub_data_stream_privilege_expire)
    token:add_service(service_rtc)

    return token:build()
end

-- Build the RTC and RTM token with account.
--
-- app_id: The App ID issued to you by Agora. Apply for a new App ID from
--     Agora Dashboard if it is missing from your kit. See Get an App ID.
-- app_certificate: Certificate of the application that you registered in
--     the Agora Dashboard. See Get an App Certificate.
-- channel_name: Unique channel name for the AgoraRTC session in the string format
-- account: The user's account, max length is 255 Bytes.
-- role: RolePublisher: A broadcaster/host in a live-broadcast profile.
--     RoleSubscriber: An audience(default) in a live-broadcast profile.
-- token_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to access the Agora Service within 10 minutes after the token is generated,
--     set token_expire as 600(seconds).
-- privilege_expire: represented by the number of seconds elapsed since now. If, for example,
--     you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
-- return The RTC and RTM token.
local function build_token_with_rtm(app_id, app_certificate, channel_name, account, role, token_expire, privilege_expire)
    local token = access_token.new_access_token(app_id, app_certificate, token_expire)

    local service_rtc = access_token.new_service_rtc(channel_name, account)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, privilege_expire)
    if role == ROLE_PUBLISHER then
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM, privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_VIDEO_STREAM, privilege_expire)
        service_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, privilege_expire)
    end
    token:add_service(service_rtc)

    local service_rtm = access_token.new_service_rtm(account)
    service_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, token_expire)
    token:add_service(service_rtm)

    return token:build()
end

return {
    build_token_with_uid = build_token_with_uid,
    build_token_with_user_account = build_token_with_user_account,
    build_token_with_uid_and_privilege = build_token_with_uid_and_privilege,
    build_token_with_user_account_and_privilege = build_token_with_user_account_and_privilege,
    build_token_with_rtm = build_token_with_rtm,
    ROLE_PUBLISHER = ROLE_PUBLISHER,
    ROLE_SUBSCRIBER = ROLE_SUBSCRIBER,
}
