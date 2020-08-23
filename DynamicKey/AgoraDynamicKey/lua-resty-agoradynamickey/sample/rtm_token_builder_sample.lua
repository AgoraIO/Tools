local ngx = ngx
local require = require
local rtm_token_builder = require "resty.agoradynamickey.rtm_token_builder"
local now = ngx.now

local app_id = "970CA35de60c44645bbae8a215061b33"
local app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
local user = "test_user_id"
local expire_delay_ts = 3600
local current_ts = now()
local privilege_expired_ts = current_ts + expire_delay_ts
local role = rtm_token_builder.Role_Rtm_User

local token = rtm_token_builder.build_token(app_id, app_certificate, user, role, privilege_expired_ts)
ngx.log(ngx.ERR, "RTM Token: ", token)