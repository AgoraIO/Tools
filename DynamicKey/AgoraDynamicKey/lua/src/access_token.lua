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

-- Creates a generic service for a service type.
local function new_service(service_type)
    local instance = {
        privileges = {},
        service_type = service_type,
    }
    setmetatable(instance, Service)
    return instance
end

-- Adds or replaces a privilege on the service.
function Service:add_privilege(privilege, expire)
    self.privileges[privilege] = expire
end

-- Returns the numeric service type.
function Service:get_service_type()
    return self.service_type
end

-- Packs the service privileges.
function Service:pack_privileges()
    return utils.pack_map_uint32(self.privileges)
end

-- Packs the numeric service type.
function Service:pack_type()
    return utils.pack_uint16(self.service_type)
end

-- Packs the generic service payload.
function Service:pack()
    return self:pack_type() .. self:pack_privileges()
end

-- Unpacks the generic service payload and returns the remaining data.
function Service:unpack(data)
    self.privileges, data = utils.unpack_map_uint32(data)
    return data
end

local ServiceRtc = {}
ServiceRtc.__index = ServiceRtc

-- Creates an RTC service.
local function new_service_rtc(channel_name, uid)
    local instance = {
        service = new_service(SERVICE_TYPE_RTC),
        channel_name = channel_name,
        uid = uid,
    }
    setmetatable(instance, ServiceRtc)
    return instance
end

-- Packs an RTC service payload.
function ServiceRtc:pack()
    return self.service:pack() .. utils.pack_string(self.channel_name) .. utils.pack_string(self.uid)
end

-- Unpacks an RTC service payload and returns the remaining data.
function ServiceRtc:unpack(data)
    data = self.service:unpack(data)
    self.channel_name, data = utils.unpack_string(data)
    self.uid, data = utils.unpack_string(data)
    return data
end

local ServiceRtm = {}
ServiceRtm.__index = ServiceRtm

-- Creates an RTM service.
local function new_service_rtm(user_id)
    local instance = {
        service = new_service(SERVICE_TYPE_RTM),
        user_id = user_id,
    }
    setmetatable(instance, ServiceRtm)
    return instance
end

-- Packs an RTM service payload.
function ServiceRtm:pack()
    return self.service:pack() .. utils.pack_string(self.user_id)
end

-- Unpacks an RTM service payload and returns the remaining data.
function ServiceRtm:unpack(data)
    data = self.service:unpack(data)
    self.user_id, data = utils.unpack_string(data)
    return data
end

local ServiceFpa = {}
ServiceFpa.__index = ServiceFpa

-- Creates an FPA service.
local function new_service_fpa()
    local instance = {
        service = new_service(SERVICE_TYPE_FPA),
    }
    setmetatable(instance, ServiceFpa)
    return instance
end

-- Packs an FPA service payload.
function ServiceFpa:pack()
    return self.service:pack()
end

-- Unpacks an FPA service payload and returns the remaining data.
function ServiceFpa:unpack(data)
    data = self.service:unpack(data)
    return data
end

local ServiceChat = {}
ServiceChat.__index = ServiceChat

-- Creates a Chat service.
local function new_service_chat(user_id)
    local instance = {
        service = new_service(SERVICE_TYPE_CHAT),
        user_id = user_id,
    }
    setmetatable(instance, ServiceChat)
    return instance
end

-- Packs a Chat service payload.
function ServiceChat:pack()
    return self.service:pack() .. utils.pack_string(self.user_id)
end

-- Unpacks a Chat service payload and returns the remaining data.
function ServiceChat:unpack(data)
    data = self.service:unpack(data)
    self.user_id, data = utils.unpack_string(data)
    return data
end

local ServiceApaas = {}
ServiceApaas.__index = ServiceApaas

-- Creates an APaaS service.
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

-- Packs an APaaS service payload.
function ServiceApaas:pack()
    return self.service:pack() ..
        utils.pack_string(self.room_uuid) .. utils.pack_string(self.user_uuid) .. utils.pack_int16(self.role)
end

-- Unpacks an APaaS service payload and returns the remaining data.
function ServiceApaas:unpack(data)
    data = self.service:unpack(data)
    self.room_uuid, data = utils.unpack_string(data)
    self.user_uuid, data = utils.unpack_string(data)
    self.role, data = utils.unpack_int16(data)
    return data
end

local AccessToken = {}
AccessToken.__index = AccessToken

-- Returns the numeric type for a generic or specialized service.
local function get_service_type(service)
    if service.service then
        return service.service:get_service_type()
    end

    return service:get_service_type()
end

-- Returns services in stable numeric type order.
local function services_for_packing(services)
    local entries = {}
    for index, service in ipairs(services) do
        table.insert(entries, {
            index = index,
            service = service,
            service_type = get_service_type(service),
        })
    end

    table.sort(entries, function(left, right)
        if left.service_type == right.service_type then
            return left.index < right.index
        end

        return left.service_type < right.service_type
    end)

    local sorted_services = {}
    for _, entry in ipairs(entries) do
        table.insert(sorted_services, entry.service)
    end

    return sorted_services
end

-- Creates an AccessToken2 instance.
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
        signature = nil,
        signing_info = nil,
    }
    setmetatable(instance, AccessToken)
    return instance
end

-- Creates an empty AccessToken2 instance for parsing.
local function create_access_token()
    return new_access_token("", "", 900)
end

-- Adds a service without replacing services of the same type.
function AccessToken:add_service(service)
    table.insert(self.services, service)
end

-- Returns all services matching a numeric service type.
function AccessToken:get_services(service_type)
    local services = {}
    for _, service in ipairs(self.services) do
        if get_service_type(service) == service_type then
            table.insert(services, service)
        end
    end

    return services
end

-- Builds and signs a Token007 string and requires at least one service.
function AccessToken:build()
    if not is_uuid(self.app_id) or not is_uuid(self.app_cert) then
        error("check appId or appCertificate")
    end

    if #self.services == 0 then
        return ""
    end

    local services = services_for_packing(self.services)
    local data = utils.pack_string(self.app_id) ..
        utils.pack_uint32(self.issue_ts) ..
        utils.pack_uint32(self.expire) ..
        utils.pack_uint32(self.salt) .. utils.pack_uint16(#services)

    local sign = self:get_sign()

    for _, service in ipairs(services) do
        data = data .. service:pack()
    end

    local signature = utils.hmac_sha256(sign, data)
    self.signature = signature
    self.signing_info = data

    local res = get_version() .. utils.base64_encode_str(utils.compress_zlib(utils.pack_string(signature) .. data))
    return res
end

-- Parses a Token007 payload into local values before updating the instance.
local function parse_token(access_token, token)
    if type(token) ~= "string" then
        return false
    end

    local version = token:sub(1, VERSION_LENGTH)
    if version ~= get_version() then
        return false
    end

    local decode_byte = utils.base64_decode_str(token:sub(VERSION_LENGTH + 1))
    local buffer = utils.decompress_zlib(decode_byte)

    local signature
    signature, buffer = utils.unpack_string(buffer)

    local signing_info = buffer
    local app_id
    local issue_ts
    local expire
    local salt
    app_id, buffer = utils.unpack_string(buffer)
    issue_ts, buffer = utils.unpack_uint32(buffer)
    expire, buffer = utils.unpack_uint32(buffer)
    salt, buffer = utils.unpack_uint32(buffer)

    local service_count
    local services = {}
    service_count, buffer = utils.unpack_uint16(buffer)
    for _ = 1, service_count do
        local service_type
        service_type, buffer = utils.unpack_uint16(buffer)
        local service = access_token:new_service(service_type)
        if not service then
            break
        end

        buffer = service:unpack(buffer)
        table.insert(services, service)
    end

    access_token.app_id = app_id
    access_token.issue_ts = issue_ts
    access_token.expire = expire
    access_token.salt = salt
    access_token.services = services
    access_token.signature = signature
    access_token.signing_info = signing_info

    return true
end

-- Parses a Token007 string and returns false for malformed input.
function AccessToken:parse(token)
    local success, parsed = pcall(parse_token, self, token)
    return success and parsed == true
end

-- Verifies the parsed or built token signature with an App Certificate.
function AccessToken:verify_signature(app_certificate)
    if not is_uuid(self.app_id) or not is_uuid(app_certificate) then
        return false
    end
    if type(self.signature) ~= "string" or type(self.signing_info) ~= "string" then
        return false
    end

    local sign = self:get_sign(app_certificate)
    local expected_signature = utils.hmac_sha256(sign, self.signing_info)
    return expected_signature == self.signature
end

-- Derives the signing key with the provided or configured App Certificate.
function AccessToken:get_sign(app_certificate)
    local certificate = app_certificate or self.app_cert
    local h_issue_ts = utils.hmac_sha256(utils.pack_uint32(self.issue_ts), certificate)
    local h_salt = utils.hmac_sha256(utils.pack_uint32(self.salt), h_issue_ts)

    return h_salt
end

-- Creates a known specialized service or returns nil for an unknown type.
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
    end

    return nil
end

-- Converts a numeric UID to its Token007 string representation.
local function get_uid_str(uid)
    if uid == 0 then
        return ""
    end
    return tostring(uid)
end

-- Returns the Token007 version prefix.
get_version = function()
    return VERSION
end

-- Returns whether a value is a 32-character hexadecimal identifier.
is_uuid = function(s)
    return type(s) == "string" and #s == 32 and s:match("^[%x]+$") ~= nil
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
