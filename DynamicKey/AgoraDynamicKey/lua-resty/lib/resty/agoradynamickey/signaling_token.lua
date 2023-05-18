local ngx = ngx
local tostring = tostring
local concat = table.concat
local md5 = ngx.md5

local _M = {}


local function generate_signaling_token(account, app_id, app_certificate, expired_ts_in_seconds)
    local version = "1"
    local expired = tostring(expired_ts_in_seconds)
    local content = concat({account, app_id, app_certificate, expired})
    local md5sum = md5(content)
    local result = concat({version, app_id, expired, md5sum}, ":")
    return result
end


_M.generate_signaling_token = generate_signaling_token

return _M