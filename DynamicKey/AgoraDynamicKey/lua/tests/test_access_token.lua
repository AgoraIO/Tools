local luaunit = require('luaunit')
local access_token = require('agora_token.access_token')

function test_service_rtc()
    local app_id = "970CA35de60c44645bbae8a215061b33"
    local app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
    local channel_name = "7d72365eb983485397e3e3f9d460bdda"
    local uid_str = "2882341273"
    local expire = 600
    local salt = 1
    local ts = 1111111

    local access_token_instance = access_token.new_access_token(app_id, app_cert, expire)
    access_token_instance.issue_ts = ts
    access_token_instance.salt = salt

    local service_rtc = access_token.new_service_rtc(channel_name, uid_str)
    service_rtc.service:add_privilege(access_token.PRIVILEGE_JOIN_CHANNEL, expire)

    access_token_instance:add_service(service_rtc)

    luaunit.assertEquals(
        "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
        access_token_instance:build())
end

function test_parse()
    local app_id = "970CA35de60c44645bbae8a215061b33"
    local channel_name = "7d72365eb983485397e3e3f9d460bdda"
    local uid_str = "2882341273"
    local expire = 600
    local salt = 1
    local ts = 1111111

    local access_token_instance = access_token.create_access_token()
    local token =
    "007eJwBigB1/yAAFqC4TFpegsv3T7gT0J9ZxUvaycBhIFgFOayXV46VixogADk3MENBMzVkZTYwYzQ0NjQ1YmJhZThhMjE1MDYxYjMzR/QQAFgCAAABAAAAAQABAAEAAQBYAgAAIAA3ZDcyMzY1ZWI5ODM0ODUzOTdlM2UzZjlkNDYwYmRkYQoAMjg4MjM0MTI3M8JqJOM="

    local res = access_token_instance:parse(token)
    local service_rtc = access_token_instance.services[access_token.SERVICE_TYPE_RTC]

    luaunit.assertEquals(true, res)
    luaunit.assertEquals(app_id, access_token_instance.app_id)
    luaunit.assertEquals(expire, access_token_instance.expire)
    luaunit.assertEquals(salt, access_token_instance.salt)
    luaunit.assertEquals(ts, access_token_instance.issue_ts)
    luaunit.assertEquals(access_token.SERVICE_TYPE_RTC, service_rtc.service:get_service_type())
    luaunit.assertEquals(channel_name, service_rtc.channel_name)
    luaunit.assertEquals(uid_str, service_rtc.uid)
end

os.exit(luaunit.LuaUnit.run())
