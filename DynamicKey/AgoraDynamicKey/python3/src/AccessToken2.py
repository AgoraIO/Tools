# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import time
import hmac
import zlib
import base64
import secrets

from hashlib import sha256
from collections import OrderedDict

from .Packer import *

VERSION_LENGTH = 3


def get_version():
    """Return the AccessToken2 version prefix."""
    return '007'


class Service:
    def __init__(self, service_type):
        """Create a service with its numeric type and an empty privilege map."""
        self.__type = service_type
        self.__privileges = {}

    def __pack_type(self):
        """Serialize the numeric service type."""
        return pack_uint16(self.__type)

    def __pack_privileges(self):
        """Serialize privileges in stable privilege ID order."""
        privileges = OrderedDict(
            sorted(iter(self.__privileges.items()), key=lambda x: int(x[0])))
        return pack_map_uint32(privileges)

    def add_privilege(self, privilege, expire):
        """Set the expiration timestamp for a service privilege."""
        self.__privileges[privilege] = expire

    def service_type(self):
        """Return the numeric service type."""
        return self.__type

    def pack(self):
        """Serialize the service type and privileges."""
        return self.__pack_type() + self.__pack_privileges()

    def unpack(self, buffer):
        """Deserialize service privileges and return the remaining buffer."""
        self.__privileges, buffer = unpack_map_uint32(buffer)
        return buffer


class ServiceRtc(Service):
    kServiceType = 1

    kPrivilegeJoinChannel = 1
    kPrivilegePublishAudioStream = 2
    kPrivilegePublishVideoStream = 3
    kPrivilegePublishDataStream = 4

    def __init__(self, channel_name='', uid=0):
        """Create an RTC service for a channel and user ID."""
        super(ServiceRtc, self).__init__(ServiceRtc.kServiceType)
        self.__channel_name = channel_name.encode('utf-8')
        self.__uid = b'' if uid == 0 else str(uid).encode('utf-8')

    def pack(self):
        """Serialize the RTC service, channel name, and user ID."""
        return super(ServiceRtc, self).pack() + pack_string(self.__channel_name) + pack_string(self.__uid)

    def unpack(self, buffer):
        """Deserialize RTC privileges, channel name, and user ID."""
        buffer = super(ServiceRtc, self).unpack(buffer)
        self.__channel_name, buffer = unpack_string(buffer)
        self.__uid, buffer = unpack_string(buffer)
        return buffer


class ServiceRtm(Service):
    kServiceType = 2

    kPrivilegeLogin = 1

    def __init__(self, user_id=''):
        """Create an RTM service for a user ID."""
        super(ServiceRtm, self).__init__(ServiceRtm.kServiceType)
        self.__user_id = user_id.encode('utf-8')

    def pack(self):
        """Serialize the RTM service and user ID."""
        return super(ServiceRtm, self).pack() + pack_string(self.__user_id)

    def unpack(self, buffer):
        """Deserialize RTM privileges and the user ID."""
        buffer = super(ServiceRtm, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        return buffer


class ServiceStreaming(Service):
    kServiceType = 3

    kPrivilegePublishMixStream = 1
    kPrivilegePublishRawStream = 2

    def __init__(self, channel_name='', account=''):
        """Create a Streaming service for a channel and numeric user ID or string account."""
        if account == 0:
            account = ''
        elif not isinstance(account, str):
            account = str(account)
        super(ServiceStreaming, self).__init__(ServiceStreaming.kServiceType)
        self.__channel_name = channel_name.encode('utf-8')
        self.__account = account.encode('utf-8')

    def pack(self):
        """Serialize the Streaming service, channel name, and user account."""
        return super(ServiceStreaming, self).pack() + pack_string(self.__channel_name) + pack_string(self.__account)

    def unpack(self, buffer):
        """Deserialize Streaming privileges, channel name, and user account."""
        buffer = super(ServiceStreaming, self).unpack(buffer)
        self.__channel_name, buffer = unpack_string(buffer)
        self.__account, buffer = unpack_string(buffer)
        return buffer


class ServiceFpa(Service):
    kServiceType = 4

    kPrivilegeLogin = 1

    def __init__(self):
        """Create an FPA service with an empty privilege map."""
        super(ServiceFpa, self).__init__(ServiceFpa.kServiceType)

    def pack(self):
        """Serialize the FPA service and privileges."""
        return super(ServiceFpa, self).pack()

    def unpack(self, buffer):
        """Deserialize FPA privileges and return the remaining buffer."""
        buffer = super(ServiceFpa, self).unpack(buffer)
        return buffer


class ServiceChat(Service):
    kServiceType = 5

    kPrivilegeUser = 1
    kPrivilegeApp = 2

    def __init__(self, user_id=''):
        """Create a Chat service for a user ID."""
        super(ServiceChat, self).__init__(ServiceChat.kServiceType)
        self.__user_id = user_id.encode('utf-8')

    def pack(self):
        """Serialize the Chat service and user ID."""
        return super(ServiceChat, self).pack() + pack_string(self.__user_id)

    def unpack(self, buffer):
        """Deserialize Chat privileges and the user ID."""
        buffer = super(ServiceChat, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        return buffer


class ServiceFCdn(Service):
    kServiceType = 6

    kPrivilegePublish = 1
    kPrivilegePlay = 2

    def __init__(self, channel_name='', account=''):
        """Create an FCDN service for a channel and numeric user ID or string account."""
        if account == 0:
            account = ''
        elif not isinstance(account, str):
            account = str(account)
        super(ServiceFCdn, self).__init__(ServiceFCdn.kServiceType)
        self.__channel_name = channel_name.encode('utf-8')
        self.__account = account.encode('utf-8')

    def pack(self):
        """Serialize the FCDN service, channel name, and user account."""
        return super(ServiceFCdn, self).pack() + pack_string(self.__channel_name) + pack_string(self.__account)

    def unpack(self, buffer):
        """Deserialize FCDN privileges, channel name, and user account."""
        buffer = super(ServiceFCdn, self).unpack(buffer)
        self.__channel_name, buffer = unpack_string(buffer)
        self.__account, buffer = unpack_string(buffer)
        return buffer


class ServiceApaas(Service):
    kServiceType = 7

    kPrivilegeRoomUser = 1
    kPrivilegeUser = 2
    kPrivilegeApp = 3

    def __init__(self, room_uuid='', user_uuid='', role=-1):
        """Create an APaaS service for a room, user, and role."""
        super(ServiceApaas, self).__init__(ServiceApaas.kServiceType)
        self.__room_uuid = room_uuid.encode('utf-8')
        self.__user_uuid = user_uuid.encode('utf-8')
        self.__role = role

    def pack(self):
        """Serialize the APaaS service, room, user, and role."""
        return super(ServiceApaas, self).pack() + pack_string(self.__room_uuid) + pack_string(
            self.__user_uuid) + pack_int16(self.__role)

    def unpack(self, buffer):
        """Deserialize APaaS privileges, room, user, and role."""
        buffer = super(ServiceApaas, self).unpack(buffer)
        self.__room_uuid, buffer = unpack_string(buffer)
        self.__user_uuid, buffer = unpack_string(buffer)
        self.__role, buffer = unpack_int16(buffer)
        return buffer


class ServiceRtm2(Service):
    kServiceType = 8

    kPrivilegeLogin = 1

    class Permissions:
        kMessageChannels = 0
        kStreamChannels = 1
        kGroupChannels = 2
        kServerGroups = 3
        kUsers = 4

        kRead = 0
        kWrite = 1

        def __init__(self):
            """Create an empty RTM2 permission set."""
            self.details = {}

        def add(self, resource_type, permission_type, resources):
            """Add or replace resources for a resource and permission type."""
            if resource_type not in self.details:
                self.details[resource_type] = {}
            self.details[resource_type][permission_type] = list(resources)

    def __init__(self, user_id='', permissions=None):
        """Create an RTM2 service with resource-level permissions."""
        super(ServiceRtm2, self).__init__(ServiceRtm2.kServiceType)
        self.__user_id = user_id.encode('utf-8')
        self.__permissions = permissions if permissions is not None else ServiceRtm2.Permissions()

    def pack(self):
        """Serialize the RTM2 service, user ID, and resource permissions."""
        permissions = pack_uint16(len(self.__permissions.details))
        for resource_type in sorted(self.__permissions.details):
            permission_map = self.__permissions.details[resource_type]
            permissions += pack_uint16(resource_type) + pack_uint16(len(permission_map))
            for permission_type in sorted(permission_map):
                resources = permission_map[permission_type]
                permissions += pack_uint16(permission_type) + pack_uint16(len(resources))
                for resource in resources:
                    permissions += pack_string(resource.encode('utf-8'))

        return super(ServiceRtm2, self).pack() + pack_string(self.__user_id) + permissions

    def unpack(self, buffer):
        """Deserialize RTM2 privileges, user ID, and resource permissions."""
        buffer = super(ServiceRtm2, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        self.__permissions = ServiceRtm2.Permissions()
        resource_count, buffer = unpack_uint16(buffer)

        for _ in range(resource_count):
            resource_type, buffer = unpack_uint16(buffer)
            permission_count, buffer = unpack_uint16(buffer)
            for _ in range(permission_count):
                permission_type, buffer = unpack_uint16(buffer)
                resource_count, buffer = unpack_uint16(buffer)
                resources = []
                for _ in range(resource_count):
                    resource, buffer = unpack_string(buffer)
                    resources.append(resource.decode('utf-8'))
                self.__permissions.add(resource_type, permission_type, resources)

        return buffer

    def get_user_id(self):
        """Return the RTM2 user ID."""
        return self.__user_id.decode('utf-8')

    def get_permissions(self):
        """Return the RTM2 resource permissions."""
        return self.__permissions


class AccessToken:
    kServices = {
        ServiceRtc.kServiceType: ServiceRtc,
        ServiceRtm.kServiceType: ServiceRtm,
        ServiceStreaming.kServiceType: ServiceStreaming,
        ServiceFpa.kServiceType: ServiceFpa,
        ServiceChat.kServiceType: ServiceChat,
        ServiceFCdn.kServiceType: ServiceFCdn,
        ServiceApaas.kServiceType: ServiceApaas,
        ServiceRtm2.kServiceType: ServiceRtm2,
    }

    def __init__(self, app_id='', app_certificate='', issue_ts=0, expire=900):
        """Create an AccessToken2 builder or an empty token parser."""
        self.__app_id = app_id
        self.__app_cert = app_certificate

        self.__issue_ts = issue_ts if issue_ts != 0 else int(time.time())
        self.__expire = expire
        self.__salt = secrets.SystemRandom().randint(1, 99999999)

        self.services = []
        self.__signature = b''
        self.__signing_info = b''
        self.__parsed = False

    def __signing(self, app_certificate):
        """Derive the signing key from the timestamp, salt, and certificate."""
        signing = hmac.new(pack_uint32(self.__issue_ts),
                           app_certificate, sha256).digest()
        signing = hmac.new(pack_uint32(self.__salt), signing, sha256).digest()
        return signing

    def __build_check(self):
        """Validate token identifiers and ensure at least one service exists."""
        def is_uuid(data):
            """Return whether data is a 32-character hexadecimal identifier."""
            if len(data) != 32:
                return False
            try:
                bytes.fromhex(data)
            except:
                return False
            return True

        if not is_uuid(self.__app_id) or not is_uuid(self.__app_cert):
            return False
        if not self.services:
            return False
        return True

    def add_service(self, service):
        """Add a service without replacing services of the same type."""
        self.services.append(service)

    def get_services(self, service_type):
        """Return all services of the requested type in insertion or token order."""
        return [service for service in self.services
                if service.service_type() == service_type]

    def build(self):
        """Build a Token007 token containing all added services."""
        if not self.__build_check():
            return ''

        self.__app_id = self.__app_id.encode('utf-8')
        self.__app_cert = self.__app_cert.encode('utf-8')
        signing = self.__signing(self.__app_cert)
        services = sorted(self.services, key=lambda service: service.service_type())
        signing_info = pack_string(self.__app_id) + pack_uint32(self.__issue_ts) + pack_uint32(self.__expire) + \
            pack_uint32(self.__salt) + pack_uint16(len(services))

        for service in services:
            signing_info += service.pack()

        signature = hmac.new(signing, signing_info, sha256).digest()

        return get_version() + base64.b64encode(zlib.compress(pack_string(signature) + signing_info)).decode('utf-8')

    def from_string(self, origin_token):
        """Parse known services and retain the original bytes for signature verification."""
        # Clear the previous token state so a failed parse cannot reuse its signature or services.
        self.__app_id = ''
        self.__issue_ts = 0
        self.__expire = 0
        self.__salt = 0
        self.services = []
        self.__signature = b''
        self.__signing_info = b''
        self.__parsed = False

        try:
            origin_version = origin_token[:VERSION_LENGTH]
            if origin_version != get_version():
                return False

            buffer = zlib.decompress(
                base64.b64decode(origin_token[VERSION_LENGTH:]))
            self.__signature, buffer = unpack_string(buffer)
            self.__signing_info = buffer
            self.services = []
            self.__app_id, buffer = unpack_string(buffer)
            self.__issue_ts, buffer = unpack_uint32(buffer)
            self.__expire, buffer = unpack_uint32(buffer)
            self.__salt, buffer = unpack_uint32(buffer)
            service_count, buffer = unpack_uint16(buffer)

            for i in range(service_count):
                service_type, buffer = unpack_uint16(buffer)
                service_class = AccessToken.kServices.get(service_type)
                if service_class is None:
                    self.__parsed = True
                    return True
                service = service_class()
                buffer = service.unpack(buffer)
                self.services.append(service)
        except Exception as e:
            print('Error: {}'.format(repr(e)))
            raise ValueError('Error: parse origin token failed')
        self.__parsed = True
        return True

    def verify_signature(self, app_certificate):
        """Verify the signature of a successfully parsed token."""
        if not self.__parsed or not self.__signature or not self.__signing_info:
            return False
        if len(app_certificate) != 32:
            return False
        try:
            bytes.fromhex(app_certificate)
        except (TypeError, ValueError):
            return False

        app_certificate = app_certificate.encode('utf-8')
        signing = self.__signing(app_certificate)
        signature = hmac.new(signing, self.__signing_info, sha256).digest()
        return hmac.compare_digest(self.__signature, signature)
