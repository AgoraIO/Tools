use Test::Nginx::Socket::Lua;
use Cwd qw(cwd);

repeat_each(1);

plan tests => repeat_each() * (3 * blocks());

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path ";$pwd/lib/?.lua;$pwd/t/lib/?.lua;$pwd/t/?.lua;;";
};

run_tests();

__DATA__


=== TEST 1: access_token test

--- http_config eval: $::HttpConfig

--- config
location = /t1 {
    content_by_lua_block {
        local access_token = require "resty.agoradynamickey.access_token"
        local app_id = "970CA35de60c44645bbae8a215061b33"
        local app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
        local channel_name = "7d72365eb983485397e3e3f9d460bdda"
        local uid = 2882341273
        local expire_ts = 1446455471
        local salt = 1
        local ts = 1111111
        local expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW" 
        local token = access_token.new(app_id, app_certificate, channel_name, uid)
        token.salt = salt
        token.ts = ts
        token.messages[token.kJoinChannel] = expire_ts
        local result = token:build()
        ngx.say(result == expected)

        -- test uid = 0
        expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW"
        uid = 0
        token = access_token.new(app_id, app_certificate, channel_name, uid)
        token.salt = salt
        token.ts = ts
        token.messages[token.kJoinChannel] = expire_ts
        result = token:build()
        ngx.say(result == expected)
    }
}

--- request
GET /t1

--- response_body 
true
true
--- no_error_log
[error]



=== TEST 2: rtc_token_builder test

--- http_config eval: $::HttpConfig

--- config
location = /t2 {
    content_by_lua_block {
        local cjson = require "cjson"
        local utils = require "utils"
        local rtc_token_builder = require "resty.agoradynamickey.rtc_token_builder"
        local access_token = require "resty.agoradynamickey.access_token"
        local app_id = "970CA35de60c44645bbae8a215061b33"
        local app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
        local channel_name = "7d72365eb983485397e3e3f9d460bdda"
        local uid = 2882341273
        local expire_ts = 1446455471
        local salt = 1
        local ts = 1111111
        local expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW" 

        local token = rtc_token_builder.build_token_with_uid(app_id, app_certificate, channel_name, uid, rtc_token_builder.Role_Subscriber, expire_ts)
        local access = access_token.new()
        access:from_string(token)

        ngx.say(access.messages[access.kJoinChannel] == expire_ts)
        ngx.say(utils.contains(access.messages, access.kPublishVideoStream))
        ngx.say(utils.contains(access.messages, access.kPublishAudioStream))
        ngx.say(utils.contains(access.messages, access.kPublishDataStream))
    }
}

--- request
GET /t2

--- response_body 
true
false
false
false
--- no_error_log
[error]


=== TEST 3: rtm_token_builder test

--- http_config eval: $::HttpConfig

--- config
location = /t3 {
    content_by_lua_block {
        local cjson = require "cjson"
        local utils = require "utils"
        local rtm_token_builder = require "resty.agoradynamickey.rtm_token_builder"
        local access_token = require "resty.agoradynamickey.access_token"
        local app_id = "970CA35de60c44645bbae8a215061b33"
        local app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
        local channel_name = "7d72365eb983485397e3e3f9d460bdda"
        local user_account = "test_user"
        local expire_ts = 1446455471
        local salt = 1
        local ts = 1111111

        local token = rtm_token_builder.build_token(app_id, app_certificate, user_account, rtm_token_builder.Role_Rtm_User, expire_ts)
        local access = access_token.new()
        access:from_string(token)
        ngx.say(access.messages[access.kRtmLogin] == expire_ts)
    }
}

--- request
GET /t3

--- response_body 
true
--- no_error_log
[error]