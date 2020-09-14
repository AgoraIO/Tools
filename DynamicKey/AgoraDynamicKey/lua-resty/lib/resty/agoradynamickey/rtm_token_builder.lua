local require = require
local access_token = require "resty.agoradynamickey.access_token"

local _M = {
    Role_Rtm_User = 1
}


local function build_token(app_id, app_certificate, user_account, role, privilege_expired_ts)
    local token = access_token.new(app_id, app_certificate, user_account, "")
    token:add_privilege(token.kRtmLogin, privilege_expired_ts)
    return token:build()
end


_M.build_token = build_token

return _M