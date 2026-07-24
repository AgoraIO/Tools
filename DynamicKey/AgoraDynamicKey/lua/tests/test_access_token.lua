local luaunit = require("luaunit")
local access_token = require("agora_token.access_token")

local APP_ID = "970CA35de60c44645bbae8a215061b33"
local APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
local WRONG_APP_CERTIFICATE = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
local CHANNEL_NAME = "7d72365eb983485397e3e3f9d460bdda"
local UID = 2882341273
local UID_STRING = "2882341273"
local ROOM_UUID = "123"
local ROLE = 1
local EXPIRE = 600
local ISSUE_TS = 1111111
local SALT = 1

-- Creates a deterministic AccessToken2 instance.
local function create_token()
    local token = access_token.new_access_token(APP_ID, APP_CERTIFICATE, EXPIRE)
    token.issue_ts = ISSUE_TS
    token.salt = SALT
    return token
end

-- Creates a fully privileged RTC service.
local function create_rtc_service(channel_name, uid, expire)
    local service = access_token.new_service_rtc(channel_name or CHANNEL_NAME, uid or UID_STRING)
    local privilege_expire = expire or EXPIRE
    service.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, privilege_expire)
    service.service:add_privilege(access_token.PRIVILEGE_PUBLISH_AUDIO_STREAM, privilege_expire)
    service.service:add_privilege(access_token.PRIVILEGE_PUBLISH_VIDEO_STREAM, privilege_expire)
    service.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, privilege_expire)
    return service
end

-- Verifies token generation rejects an empty service list.
function test_build_rejects_empty_services()
    luaunit.assertEquals("", create_token():build())
end

-- Verifies deterministic single-service generation remains compatible.
function test_build_service_rtc()
    local token = create_token()
    local service = access_token.new_service_rtc(CHANNEL_NAME, UID_STRING)
    service.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, EXPIRE)
    token:add_service(service)

    luaunit.assertEquals(
        "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
        token:build()
    )
    luaunit.assertTrue(token:verify_signature(APP_CERTIFICATE))
end

-- Verifies parsing and signature validation for an existing Token007.
function test_parse_existing_token()
    local old_token =
        "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj"
    local token = access_token.create_access_token()

    luaunit.assertTrue(token:parse(old_token))
    luaunit.assertEquals(APP_ID, token.app_id)
    luaunit.assertEquals(EXPIRE, token.expire)
    luaunit.assertEquals(SALT, token.salt)
    luaunit.assertEquals(ISSUE_TS, token.issue_ts)
    luaunit.assertTrue(token:verify_signature(APP_CERTIFICATE))

    local services = token:get_services(access_token.SERVICE_TYPE_RTC)
    luaunit.assertEquals(1, #services)
    luaunit.assertEquals(CHANNEL_NAME, services[1].channel_name)
    luaunit.assertEquals(UID_STRING, services[1].uid)
end

-- Verifies repeated ServiceTypes remain separate after a round trip.
function test_repeated_service_type_round_trip()
    local token = create_token()
    local first_rtc = create_rtc_service()
    local stream_rtc = access_token.new_service_rtc(CHANNEL_NAME, UID_STRING)
    stream_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, EXPIRE + 200)
    stream_rtc.service:add_privilege(access_token.PRIVILEGE_PUBLISH_DATA_STREAM, EXPIRE + 200)
    local rtm = access_token.new_service_rtm(UID_STRING)
    rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, EXPIRE + 100)

    token:add_service(rtm)
    token:add_service(first_rtc)
    token:add_service(stream_rtc)

    luaunit.assertEquals(3, #token.services)
    luaunit.assertEquals(2, #token:get_services(access_token.SERVICE_TYPE_RTC))

    local parsed = access_token.create_access_token()
    luaunit.assertTrue(parsed:parse(token:build()))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))

    local rtc_services = parsed:get_services(access_token.SERVICE_TYPE_RTC)
    luaunit.assertEquals(2, #rtc_services)
    luaunit.assertEquals(CHANNEL_NAME, rtc_services[1].channel_name)
    luaunit.assertEquals(CHANNEL_NAME, rtc_services[2].channel_name)
    luaunit.assertEquals(UID_STRING, rtc_services[2].uid)
    luaunit.assertEquals(
        EXPIRE + 200,
        rtc_services[2].service.privileges[access_token.PRIVILEGE_PUBLISH_DATA_STREAM]
    )
end

-- Verifies packing uses stable numeric ServiceType order.
function test_stable_service_type_order()
    local forward = create_token()
    local forward_rtm = access_token.new_service_rtm(UID_STRING)
    forward_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, EXPIRE)
    forward:add_service(create_rtc_service())
    forward:add_service(forward_rtm)

    local reverse = create_token()
    local reverse_rtm = access_token.new_service_rtm(UID_STRING)
    reverse_rtm.service:add_privilege(access_token.PRIVILEGE_LOGIN, EXPIRE)
    reverse:add_service(reverse_rtm)
    reverse:add_service(create_rtc_service())

    luaunit.assertEquals(forward:build(), reverse:build())
    luaunit.assertEquals(reverse_rtm, reverse.services[1])
end

-- Verifies known services before an unknown ServiceType remain available.
function test_unknown_service_after_known_service()
    local token = create_token()
    token:add_service(create_rtc_service())
    local unknown = access_token.new_service(999)
    unknown:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, EXPIRE)
    token:add_service(unknown)

    local parsed = access_token.create_access_token()
    luaunit.assertTrue(parsed:parse(token:build()))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_RTC))
    luaunit.assertEquals(0, #parsed:get_services(999))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))
end

-- Verifies parsing stops safely when an unknown ServiceType appears first.
function test_unknown_service_before_known_service()
    local token = create_token()
    token:add_service(create_rtc_service())
    local unknown = access_token.new_service(0)
    unknown:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, EXPIRE)
    token:add_service(unknown)

    local parsed = access_token.create_access_token()
    luaunit.assertTrue(parsed:parse(token:build()))
    luaunit.assertEquals(0, #parsed:get_services(access_token.SERVICE_TYPE_RTC))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))
end

-- Verifies all known service payloads round trip correctly.
function test_all_known_service_payloads()
    local token = create_token()
    local fpa = access_token.new_service_fpa()
    fpa.service:add_privilege(access_token.PRIVILEGE_LOGIN, EXPIRE)
    local chat = access_token.new_service_chat(UID_STRING)
    chat.service:add_privilege(access_token.PRIVILEGE_CHAT_USER, EXPIRE)
    local apaas = access_token.new_service_apaas(ROOM_UUID, UID_STRING, ROLE)
    apaas.service:add_privilege(access_token.PRIVILEGE_APAAS_ROOM_USER, EXPIRE)
    token:add_service(fpa)
    token:add_service(chat)
    token:add_service(apaas)

    local parsed = access_token.create_access_token()
    luaunit.assertTrue(parsed:parse(token:build()))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))
    luaunit.assertEquals(1, #parsed:get_services(access_token.SERVICE_TYPE_FPA))

    local parsed_chat = parsed:get_services(access_token.SERVICE_TYPE_CHAT)[1]
    luaunit.assertEquals(UID_STRING, parsed_chat.user_id)
    local parsed_apaas = parsed:get_services(access_token.SERVICE_TYPE_APAAS)[1]
    luaunit.assertEquals(ROOM_UUID, parsed_apaas.room_uuid)
    luaunit.assertEquals(UID_STRING, parsed_apaas.user_uuid)
    luaunit.assertEquals(ROLE, parsed_apaas.role)
end

-- Verifies malformed tokens and invalid signatures are rejected.
function test_invalid_token_inputs_and_signatures()
    local parsed = access_token.create_access_token()
    luaunit.assertFalse(parsed:parse(nil))
    luaunit.assertFalse(parsed:parse("006invalid"))
    luaunit.assertFalse(parsed:parse("007invalid"))
    luaunit.assertFalse(parsed:verify_signature(APP_CERTIFICATE))

    local token = create_token()
    token:add_service(create_rtc_service())
    luaunit.assertTrue(parsed:parse(token:build()))
    luaunit.assertFalse(parsed:verify_signature(WRONG_APP_CERTIFICATE))
    luaunit.assertFalse(parsed:verify_signature("invalid"))
    luaunit.assertTrue(parsed:verify_signature(APP_CERTIFICATE))

    luaunit.assertFalse(parsed:parse("006invalid"))
    luaunit.assertFalse(parsed:verify_signature(APP_CERTIFICATE))
    luaunit.assertEquals(0, #parsed.services)
end

-- Verifies UID conversion and identifier validation helpers.
function test_access_token_helpers()
    luaunit.assertEquals("", access_token.get_uid_str(0))
    luaunit.assertEquals(UID_STRING, access_token.get_uid_str(UID))
    luaunit.assertEquals("007", access_token.get_version())
    luaunit.assertTrue(access_token.is_uuid(APP_ID))
    luaunit.assertFalse(access_token.is_uuid(nil))
    luaunit.assertFalse(access_token.is_uuid("invalid"))
end

os.exit(luaunit.LuaUnit.run())
