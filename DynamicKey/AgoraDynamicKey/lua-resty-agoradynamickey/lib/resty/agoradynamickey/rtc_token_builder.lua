local require = require

local access_token = require("resty.agoradynamickey.access_token")

local Role_Attendee = 0 -- depreated, same as publisher
local Role_Publisher = 1 -- for live broadcaster
local Role_Subscriber = 2 -- default, for live audience
local Role_Admin = 101 -- deprecated, same as publisher


local _M = {
    Role_Attendee = 0, -- depreated, same as publisher
    Role_Publisher = 1, -- for live broadcaster
    Role_Subscriber = 2, -- default, for live audience
    Role_Admin = 101 -- deprecated, same as publisher
}


local function build_token_with_account(app_id, app_certificate, channel_name, account, role, privilege_expired_ts)
    local token = access_token.new(app_id, app_certificate, channel_name, account)
    token:add_privilege(token.kJoinChannel, privilege_expired_ts)
    if (role == Role_Attendee) or (role == Role_Admin) or (role == Role_Publisher) then
        token:add_privilege(token.kPublishVideoStream, privilege_expired_ts)
        token:add_privilege(token.kPublishAudioStream, privilege_expired_ts)
        token:add_privilege(token.kPublishDataStream, privilege_expired_ts)
    end

    return token:build()
end


local function build_token_with_uid(app_id, app_certificate, channel_name, uid, role, privilege_expired_ts)
    return build_token_with_account(app_id, app_certificate, channel_name, uid, role, privilege_expired_ts)
end


_M.build_token_with_uid = build_token_with_uid
_M.build_token_with_account = build_token_with_account

return _M


