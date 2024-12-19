local utils = require("agora_token.utils")

local VERSION = "007"
local VERSION_LENGTH = 3

-- Service type
local SERVICE_TYPE_RTC = 1
local SERVICE_TYPE_RTM = 2
local SERVICE_TYPE_FPA = 4
local SERVICE_TYPE_CHAT = 5
local SERVICE_TYPE_APAAS = 7

-- Rtc
local PRIVILEGE_JOIN_CHANNEL = 1
local PRIVILEGE_PUBLISH_AUDIO_STREAM = 2
local PRIVILEGE_PUBLISH_VIDEO_STREAM = 3
local PRIVILEGE_PUBLISH_DATA_STREAM = 4

-- Rtm
-- Fpa
local PRIVILEGE_LOGIN = 1

-- Chat
local PRIVILEGE_CHAT_USER = 1
local PRIVILEGE_CHAT_APP = 2

-- Apaas
local PRIVILEGE_APAAS_ROOM_USER = 1
local PRIVILEGE_APAAS_USER = 2
local PRIVILEGE_APAAS_APP = 3

local get_version
local is_uuid

local Service = {}
Service.__index = Service

local function new_service(service_type)
    local instance = {
        privileges = {},
        service_type = service_type,
    }
    setmetatable(instance, Service)
    return instance
end

function Service:add_privilege(privilege, expire)
    self.privileges[privilege] = expire
end

function Service:get_service_type()
    return self.service_type
end

function Service:pack_privileges()
    return utils.pack_map_uint32(self.privileges)
end

function Service:pack_type()
    return utils.pack_uint16(self.service_type)
end

function Service:pack()
    return self:pack_type() .. self:pack_privileges()
end

function Service:unpack(data)
    self.privileges, data = utils.unpack_map_uint32(data)
    return data
end

local ServiceRtc = {}
ServiceRtc.__index = ServiceRtc

local function new_service_rtc(channel_name, uid)
    local instance = {
        service = new_service(SERVICE_TYPE_RTC),
        channel_name = channel_name,
        uid = uid,
    }
    setmetatable(instance, ServiceRtc)
    return instance
end

function ServiceRtc:pack()
    return self.service:pack() .. utils.pack_string(self.channel_name) .. utils.pack_string(self.uid)
end

function ServiceRtc:unpack(data)
    data = self.service:unpack(data)
    self.channel_name, data = utils.unpack_string(data)
    self.uid, data = utils.unpack_string(data)
    return data
end

local ServiceRtm = {}
ServiceRtm.__index = ServiceRtm

local function new_service_rtm(user_id)
    local instance = {
        service = new_service(SERVICE_TYPE_RTM),
        user_id = user_id,
    }
    setmetatable(instance, ServiceRtm)
    return instance
end

function ServiceRtm:pack()
    return self.service:pack() .. utils.pack_string(self.user_id)
end

function ServiceRtm:unpack(data)
    data = self.service:unpack(data)
    self.user_id, data = utils.unpack_string(data)
    return data
end

local ServiceFpa = {}
ServiceFpa.__index = ServiceFpa

local function new_service_fpa()
    local instance = {
        service = new_service(SERVICE_TYPE_FPA),
    }
    setmetatable(instance, ServiceFpa)
    return instance
end

function ServiceFpa:pack()
    return self.service:pack()
end

function ServiceFpa:unpack(data)
    data = self.service:unpack(data)
    return data
end

local ServiceChat = {}
ServiceChat.__index = ServiceChat

local function new_service_chat(user_id)
    local instance = {
        service = new_service(SERVICE_TYPE_CHAT),
        user_id = user_id,
    }
    setmetatable(instance, ServiceChat)
    return instance
end

function ServiceChat:pack()
    return self.service:pack() .. utils.pack_string(self.user_id)
end

function ServiceChat:unpack(data)
    data = self.service:unpack(data)
    self.user_id, data = utils.unpack_string(data)
    return data
end

local ServiceApaas = {}
ServiceApaas.__index = ServiceApaas

local function new_service_apaas(room_uuid, user_uuid, role)
    local instance = {
        service = new_service(SERVICE_TYPE_APAAS),
        room_uuid = room_uuid,
        user_uuid = user_uuid,
        role = role,
    }
    setmetatable(instance, ServiceApaas)
    return instance
end

function ServiceApaas:pack()
    return self.service:pack() ..
        utils.pack_string(self.room_uuid) .. utils.pack_string(self.user_uuid) .. utils.pack_int16(self.role)
end

function ServiceApaas:unpack(data)
    data = self.service:unpack(data)
    self.room_uuid, data = utils.unpack_string(data)
    self.user_uuid, data = utils.unpack_string(data)
    self.role, data = utils.unpack_int16(data)
    return data
end

local AccessToken = {}
AccessToken.__index = AccessToken

local function new_access_token(app_id, app_cert, expire)
    local issue_ts = os.time()
    local salt = utils.get_rand(1, 99999999)

    local instance = {
        app_cert = app_cert,
        app_id = app_id,
        expire = expire,
        issue_ts = issue_ts,
        salt = salt,
        services = {},
    }
    setmetatable(instance, AccessToken)
    return instance
end

local function create_access_token()
    return new_access_token("", "", 900)
end

function AccessToken:add_service(service)
    self.services[service.service:get_service_type()] = service
end

function AccessToken:build()
    if not is_uuid(self.app_id) or not is_uuid(self.app_cert) then
        error("check appId or appCertificate")
    end

    local data = utils.pack_string(self.app_id) ..
        utils.pack_uint32(self.issue_ts) ..
        utils.pack_uint32(self.expire) ..
        utils.pack_uint32(self.salt) .. utils.pack_uint16(utils.count_table_elements(self.services))

    local sign = self:get_sign()

    local service_types = {}
    for service_type in pairs(self.services) do
        table.insert(service_types, service_type)
    end
    table.sort(service_types)

    for _, service_type in ipairs(service_types) do
        local service = self.services[service_type]
        if service then
            data = data .. service:pack()
        end
    end

    local signature = utils.hmac_sha256(sign, data)

    local res = get_version() .. utils.base64_encode_str(utils.compress_zlib(utils.pack_string(signature) .. data))
    return res
end

function AccessToken:parse(token)
    local version = token:sub(1, VERSION_LENGTH)
    if version ~= get_version() then
        return false
    end

    local decode_byte = utils.base64_decode_str(token:sub(VERSION_LENGTH + 1))
    local buffer = utils.decompress_zlib(decode_byte)

    local signature
    signature, buffer = utils.unpack_string(buffer)

    self.app_id, buffer = utils.unpack_string(buffer)
    self.issue_ts, buffer = utils.unpack_uint32(buffer)
    self.expire, buffer = utils.unpack_uint32(buffer)
    self.salt, buffer = utils.unpack_uint32(buffer)

    local service_count
    local service_type
    service_count, buffer = utils.unpack_uint16(buffer)
    for _ = 1, service_count do
        service_type, buffer = utils.unpack_uint16(buffer)
        local service = self:new_service(service_type)
        buffer = service:unpack(buffer)
        self.services[service_type] = service
    end

    return true
end

function AccessToken:get_sign()
    local h_issue_ts = utils.hmac_sha256(utils.pack_uint32(self.issue_ts), self.app_cert)
    local h_salt = utils.hmac_sha256(utils.pack_uint32(self.salt), h_issue_ts)

    return h_salt
end

function AccessToken:new_service(service_type)
    if service_type == SERVICE_TYPE_RTC then
        return new_service_rtc("", "")
    elseif service_type == SERVICE_TYPE_RTM then
        return new_service_rtm("")
    elseif service_type == SERVICE_TYPE_FPA then
        return new_service_fpa()
    elseif service_type == SERVICE_TYPE_CHAT then
        return new_service_chat("")
    elseif service_type == SERVICE_TYPE_APAAS then
        return new_service_apaas("", "", -1)
    else
        error("new service failed: unknown service type " .. service_type)
    end
end

local function get_uid_str(uid)
    if uid == 0 then
        return ""
    end
    return tostring(uid)
end

get_version = function()
    return VERSION
end

is_uuid = function(s)
    return #s == 32 and s:match("^[%x]+$") ~= nil
end

return {
    AccessToken = AccessToken,
    create_access_token = create_access_token,
    get_uid_str = get_uid_str,
    get_version = get_version,
    is_uuid = is_uuid,
    new_access_token = new_access_token,
    new_service = new_service,
    new_service_rtc = new_service_rtc,
    new_service_rtm = new_service_rtm,
    new_service_fpa = new_service_fpa,
    new_service_chat = new_service_chat,
    new_service_apaas = new_service_apaas,
    PRIVILEGE_JOIN_CHANNEL = PRIVILEGE_JOIN_CHANNEL,
    PRIVILEGE_PUBLISH_AUDIO_STREAM = PRIVILEGE_PUBLISH_AUDIO_STREAM,
    PRIVILEGE_PUBLISH_VIDEO_STREAM = PRIVILEGE_PUBLISH_VIDEO_STREAM,
    PRIVILEGE_PUBLISH_DATA_STREAM = PRIVILEGE_PUBLISH_DATA_STREAM,
    PRIVILEGE_LOGIN = PRIVILEGE_LOGIN,
    PRIVILEGE_CHAT_USER = PRIVILEGE_CHAT_USER,
    PRIVILEGE_CHAT_APP = PRIVILEGE_CHAT_APP,
    PRIVILEGE_APAAS_ROOM_USER = PRIVILEGE_APAAS_ROOM_USER,
    PRIVILEGE_APAAS_USER = PRIVILEGE_APAAS_USER,
    PRIVILEGE_APAAS_APP = PRIVILEGE_APAAS_APP,
    SERVICE_TYPE_RTC = SERVICE_TYPE_RTC,
    SERVICE_TYPE_RTM = SERVICE_TYPE_RTM,
    SERVICE_TYPE_FPA = SERVICE_TYPE_FPA,
    SERVICE_TYPE_CHAT = SERVICE_TYPE_CHAT,
    SERVICE_TYPE_APAAS = SERVICE_TYPE_APAAS,
    ServiceRtc = ServiceRtc,
    ServiceRtm = ServiceRtm,
    ServiceFpa = ServiceFpa,
    ServiceChat = ServiceChat,
    ServiceApaas = ServiceApaas,
}
