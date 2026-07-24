local luaunit = require("luaunit")
local access_token = require("agora_token.access_token")
local apaas_token_builder = require("agora_token.apaas_token_builder")
local chat_token_builder = require("agora_token.chat_token_builder")
local education_token_builder = require("agora_token.education_token_builder")
local fpa_token_builder = require("agora_token.fpa_token_builder")
local rtc_token_builder = require("agora_token.rtc_token_builder")
local rtm_token_builder = require("agora_token.rtm_token_builder")

local APP_ID = "970CA35de60c44645bbae8a215061b33"
local APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
local CHANNEL_NAME = "7d72365eb983485397e3e3f9d460bdda"
local UID = 2882341273
local UID_STRING = "2882341273"
local USER_ID = "test_user"
local ROOM_UUID = "123"
local ROLE = 1
local EXPIRE = 600

-- Parses a generated token and verifies its signature.
local function parse_token(token)
    local parsed = access_token.create_access_token()
    luaunit.assertTrue(parsed:parse(token))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))
    return parsed
end

-- Verifies every RTC Builder entry point remains usable.
function test_rtc_token_builder_entry_points()
    local token = rtc_token_builder.build_token_with_uid(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID,
        rtc_token_builder.ROLE_PUBLISHER,
        EXPIRE,
        EXPIRE
    )
    local parsed = parse_token(token)
    local rtc = parsed:get_services(access_token.SERVICE_TYPE_RTC)[1]
    luaunit.assertEquals(CHANNEL_NAME, rtc.channel_name)
    luaunit.assertEquals(UID_STRING, rtc.uid)
    luaunit.assertEquals(EXPIRE, rtc.service.privileges[access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM])

    token = rtc_token_builder.build_token_with_user_account(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID_STRING,
        rtc_token_builder.ROLE_SUBSCRIBER,
        EXPIRE,
        EXPIRE
    )
    parsed = parse_token(token)
    rtc = parsed:get_services(access_token.SERVICE_TYPE_RTC)[1]
    luaunit.assertNil(rtc.service.privileges[access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM])

    token = rtc_token_builder.build_token_with_uid_and_privilege(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE
    )
    parsed = parse_token(token)
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTC))

    token = rtc_token_builder.build_token_with_user_account_and_privilege(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID_STRING,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE
    )
    parsed = parse_token(token)
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTC))

    token = rtc_token_builder.build_token_with_rtm(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID_STRING,
        rtc_token_builder.ROLE_PUBLISHER,
        EXPIRE,
        EXPIRE
    )
    parsed = parse_token(token)
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTC))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTM))

    token = rtc_token_builder.build_token_with_rtm2(
        APP_ID,
        APP_CERTIFICATE,
        CHANNEL_NAME,
        UID_STRING,
        rtc_token_builder.ROLE_PUBLISHER,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        EXPIRE,
        USER_ID,
        EXPIRE
    )
    parsed = parse_token(token)
    luaunit.assertEquals(USER_ID, parsed:get_services(access_token.SERVICE_TYPE_RTM)[1].user_id)
end

-- Verifies RTM Builder token contents.
function test_rtm_token_builder()
    local token = rtm_token_builder.build_token(APP_ID, APP_CERTIFICATE, USER_ID, EXPIRE)
    local parsed = parse_token(token)
    local rtm = parsed:get_services(access_token.SERVICE_TYPE_RTM)[1]
    luaunit.assertEquals(USER_ID, rtm.user_id)
    luaunit.assertEquals(EXPIRE, rtm.service.privileges[access_token.PRIVILEGE_LOGIN])
end

-- Verifies Chat Builder user and app tokens.
function test_chat_token_builder()
    local token = chat_token_builder.build_chat_user_token(APP_ID, APP_CERTIFICATE, UID_STRING, EXPIRE)
    local parsed = parse_token(token)
    local chat = parsed:get_services(access_token.SERVICE_TYPE_CHAT)[1]
    luaunit.assertEquals(UID_STRING, chat.user_id)
    luaunit.assertEquals(EXPIRE, chat.service.privileges[access_token.PRIVILEGE_CHAT_USER])

    token = chat_token_builder.build_chat_app_token(APP_ID, APP_CERTIFICATE, EXPIRE)
    parsed = parse_token(token)
    chat = parsed:get_services(access_token.SERVICE_TYPE_CHAT)[1]
    luaunit.assertEquals("", chat.user_id)
    luaunit.assertEquals(EXPIRE, chat.service.privileges[access_token.PRIVILEGE_CHAT_APP])
end

-- Verifies FPA Builder token contents.
function test_fpa_token_builder()
    local token = fpa_token_builder.build_token(APP_ID, APP_CERTIFICATE)
    local parsed = parse_token(token)
    local fpa = parsed:get_services(access_token.SERVICE_TYPE_FPA)[1]
    luaunit.assertEquals(24 * 3600, parsed.expire)
    luaunit.assertEquals(0, fpa.service.privileges[access_token.PRIVILEGE_LOGIN])
end

-- Verifies APaaS Builder room-user, user, and app tokens.
function test_apaas_token_builder()
    local token = apaas_token_builder.build_room_user_token(
        APP_ID,
        APP_CERTIFICATE,
        ROOM_UUID,
        UID_STRING,
        ROLE,
        EXPIRE
    )
    local parsed = parse_token(token)
    local apaas = parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1]
    luaunit.assertEquals(ROOM_UUID, apaas.room_uuid)
    luaunit.assertEquals(UID_STRING, apaas.user_uuid)
    luaunit.assertEquals(ROLE, apaas.role)
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTM))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_CHAT))

    token = apaas_token_builder.build_user_token(APP_ID, APP_CERTIFICATE, UID_STRING, EXPIRE)
    parsed = parse_token(token)
    apaas = parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1]
    luaunit.assertEquals("", apaas.room_uuid)
    luaunit.assertEquals(UID_STRING, apaas.user_uuid)
    luaunit.assertEquals(-1, apaas.role)

    token = apaas_token_builder.build_app_token(APP_ID, APP_CERTIFICATE, EXPIRE)
    parsed = parse_token(token)
    apaas = parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1]
    luaunit.assertEquals("", apaas.room_uuid)
    luaunit.assertEquals("", apaas.user_uuid)
    luaunit.assertEquals(-1, apaas.role)
end

-- Verifies Education Builder room-user, user, and app tokens.
function test_education_token_builder()
    local token = education_token_builder.build_room_user_token(
        APP_ID,
        APP_CERTIFICATE,
        ROOM_UUID,
        UID_STRING,
        ROLE,
        EXPIRE
    )
    local parsed = parse_token(token)
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_APAAS))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTM))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_CHAT))

    token = education_token_builder.build_user_token(APP_ID, APP_CERTIFICATE, UID_STRING, EXPIRE)
    parsed = parse_token(token)
    luaunit.assertEquals(
        EXPIRE,
        parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1].service.privileges[
            access_token.PRIVILEGE_APAAS_USER
        ]
    )

    token = education_token_builder.build_app_token(APP_ID, APP_CERTIFICATE, EXPIRE)
    parsed = parse_token(token)
    luaunit.assertEquals(
        EXPIRE,
        parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1].service.privileges[
            access_token.PRIVILEGE_APAAS_APP
        ]
    )
end

os.exit(luaunit.LuaUnit.run())
