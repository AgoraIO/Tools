local ngx = ngx
local require = require
local rtc_token_builder = require "resty.agoradynamickey.rtc_token_builder"
local now = ngx.now

local app_id = "970CA35de60c44645bbae8a215061b33"
local app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
local channel_name = "7d72365eb983485397e3e3f9d460bdda"
local uid = 2882341273
local user_account = "2882341273"
local expire_delay_ts = 3600
local current_ts = now()
local privilege_expired_ts = current_ts + expire_delay_ts
local role = rtc_token_builder.Role_Attendee

local token = rtc_token_builder.build_token_with_uid(app_id, app_certificate, channel_name, uid, role, privilege_expired_ts)
ngx.log(ngx.ERR, "Token with int uid: ", token)
token = rtc_token_builder.build_token_with_account(app_id, app_certificate, channel_name, user_account, role, privilege_expired_ts)
ngx.log(ngx.ERR, "Token with user account: ", token)