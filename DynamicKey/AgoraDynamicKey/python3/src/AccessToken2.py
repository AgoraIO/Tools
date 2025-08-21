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
    return '007'


class Service:
    def __init__(self, service_type):
        self.__type = service_type
        self.__privileges = {}

    def __pack_type(self):
        return pack_uint16(self.__type)

    def __pack_privileges(self):
        privileges = OrderedDict(
            sorted(iter(self.__privileges.items()), key=lambda x: int(x[0])))
        return pack_map_uint32(privileges)

    def add_privilege(self, privilege, expire):
        self.__privileges[privilege] = expire

    def service_type(self):
        return self.__type

    def pack(self):
        return self.__pack_type() + self.__pack_privileges()

    def unpack(self, buffer):
        self.__privileges, buffer = unpack_map_uint32(buffer)
        return buffer


class ServiceRtc(Service):
    kServiceType = 1

    kPrivilegeJoinChannel = 1
    kPrivilegePublishAudioStream = 2
    kPrivilegePublishVideoStream = 3
    kPrivilegePublishDataStream = 4

    def __init__(self, channel_name='', uid=0):
        super(ServiceRtc, self).__init__(ServiceRtc.kServiceType)
        self.__channel_name = channel_name.encode('utf-8')
        self.__uid = b'' if uid == 0 else str(uid).encode('utf-8')

    def pack(self):
        return super(ServiceRtc, self).pack() + pack_string(self.__channel_name) + pack_string(self.__uid)

    def unpack(self, buffer):
        buffer = super(ServiceRtc, self).unpack(buffer)
        self.__channel_name, buffer = unpack_string(buffer)
        self.__uid, buffer = unpack_string(buffer)
        return buffer


class ServiceRtm(Service):
    kServiceType = 2

    kPrivilegeLogin = 1

    def __init__(self, user_id=''):
        super(ServiceRtm, self).__init__(ServiceRtm.kServiceType)
        self.__user_id = user_id.encode('utf-8')

    def pack(self):
        return super(ServiceRtm, self).pack() + pack_string(self.__user_id)

    def unpack(self, buffer):
        buffer = super(ServiceRtm, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        return buffer


class ServiceFpa(Service):
    kServiceType = 4

    kPrivilegeLogin = 1

    def __init__(self):
        super(ServiceFpa, self).__init__(ServiceFpa.kServiceType)

    def pack(self):
        return super(ServiceFpa, self).pack()

    def unpack(self, buffer):
        buffer = super(ServiceFpa, self).unpack(buffer)
        return buffer


class ServiceChat(Service):
    kServiceType = 5

    kPrivilegeUser = 1
    kPrivilegeApp = 2

    def __init__(self, user_id=''):
        super(ServiceChat, self).__init__(ServiceChat.kServiceType)
        self.__user_id = user_id.encode('utf-8')

    def pack(self):
        return super(ServiceChat, self).pack() + pack_string(self.__user_id)

    def unpack(self, buffer):
        buffer = super(ServiceChat, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        return buffer


class ServiceApaas(Service):
    kServiceType = 7

    kPrivilegeRoomUser = 1
    kPrivilegeUser = 2
    kPrivilegeApp = 3

    def __init__(self, room_uuid='', user_uuid='', role=-1):
        super(ServiceApaas, self).__init__(ServiceApaas.kServiceType)
        self.__room_uuid = room_uuid.encode('utf-8')
        self.__user_uuid = user_uuid.encode('utf-8')
        self.__role = role

    def pack(self):
        return super(ServiceApaas, self).pack() + pack_string(self.__room_uuid) + pack_string(
            self.__user_uuid) + pack_int16(self.__role)

    def unpack(self, buffer):
        buffer = super(ServiceApaas, self).unpack(buffer)
        self.__room_uuid, buffer = unpack_string(buffer)
        self.__user_uuid, buffer = unpack_string(buffer)
        self.__role, buffer = unpack_int16(buffer)
        return buffer


class ServiceRtm2(Service):
    kServiceType = 8

    kPrivilegeLogin = 1

    class Permissions:
        # Resource types
        kMessageChannels = 0
        kStreamChannels = 1
        kGroupChannels = 2
        kServerGroups = 3
        kUsers = 4

        # Permission types
        kRead = 0
        kWrite = 1

        def __init__(self):
            self.details = {}

        def add(self, resource_type, permission_type, resources):
            if resource_type not in self.details:
                self.details[resource_type] = {}
            self.details[resource_type][permission_type] = resources

    def __init__(self, user_id='', permissions=None):
        super(ServiceRtm2, self).__init__(ServiceRtm2.kServiceType)
        self.__user_id = user_id.encode('utf-8')
        self.__permissions = permissions if permissions else ServiceRtm2.Permissions()

    def pack(self):
        permissions_data = b''
        # Pack permissions details
        permissions_data += pack_uint16(len(self.__permissions.details))
        for resource_type in sorted(self.__permissions.details.keys()):
            permissions_data += pack_uint16(resource_type)
            permission_map = self.__permissions.details[resource_type]
            permissions_data += pack_uint16(len(permission_map))
            for permission_type in sorted(permission_map.keys()):
                permissions_data += pack_uint16(permission_type)
                resources = permission_map[permission_type]
                permissions_data += pack_uint16(len(resources))
                for resource in resources:
                    permissions_data += pack_string(resource.encode('utf-8'))
        
        return super(ServiceRtm2, self).pack() + pack_string(self.__user_id) + permissions_data

    def unpack(self, buffer):
        buffer = super(ServiceRtm2, self).unpack(buffer)
        self.__user_id, buffer = unpack_string(buffer)
        
        # Unpack permissions details
        self.__permissions = ServiceRtm2.Permissions()
        resource_count, buffer = unpack_uint16(buffer)
        
        for _ in range(resource_count):
            resource_type, buffer = unpack_uint16(buffer)
            permission_count, buffer = unpack_uint16(buffer)
            
            for _ in range(permission_count):
                permission_type, buffer = unpack_uint16(buffer)
                resource_list_count, buffer = unpack_uint16(buffer)
                
                resources = []
                for _ in range(resource_list_count):
                    resource, buffer = unpack_string(buffer)
                    resources.append(resource.decode('utf-8'))
                
                self.__permissions.add(resource_type, permission_type, resources)
        
        return buffer

    def get_user_id(self):
        return self.__user_id.decode('utf-8')

    def get_permissions(self):
        return self.__permissions


class AccessToken:
    kServices = {
        ServiceRtc.kServiceType: ServiceRtc,
        ServiceRtm.kServiceType: ServiceRtm,
        ServiceFpa.kServiceType: ServiceFpa,
        ServiceChat.kServiceType: ServiceChat,
        ServiceApaas.kServiceType: ServiceApaas,
        ServiceRtm2.kServiceType: ServiceRtm2,
    }

    def __init__(self, app_id='', app_certificate='', issue_ts=0, expire=900):
        self.__app_id = app_id
        self.__app_cert = app_certificate

        self.__issue_ts = issue_ts if issue_ts != 0 else int(time.time())
        self.__expire = expire
        self.__salt = secrets.SystemRandom().randint(1, 99999999)

        self.__service = {}

    def __signing(self):
        signing = hmac.new(pack_uint32(self.__issue_ts),
                           self.__app_cert, sha256).digest()
        signing = hmac.new(pack_uint32(self.__salt), signing, sha256).digest()
        return signing

    def __build_check(self):
        def is_uuid(data):
            if len(data) != 32:
                return False
            try:
                bytes.fromhex(data)
            except:
                return False
            return True

        if not is_uuid(self.__app_id) or not is_uuid(self.__app_cert):
            return False
        if not self.__service:
            return False
        return True

    def add_service(self, service):
        self.__service[service.service_type()] = service

    def build(self):
        if not self.__build_check():
            return ''

        self.__app_id = self.__app_id.encode('utf-8')
        self.__app_cert = self.__app_cert.encode('utf-8')
        signing = self.__signing()
        signing_info = pack_string(self.__app_id) + pack_uint32(self.__issue_ts) + pack_uint32(self.__expire) + \
            pack_uint32(self.__salt) + pack_uint16(len(self.__service))

        for service_type in sorted(self.__service.keys()):
            signing_info += self.__service[service_type].pack()

        signature = hmac.new(signing, signing_info, sha256).digest()

        return get_version() + base64.b64encode(zlib.compress(pack_string(signature) + signing_info)).decode('utf-8')

    def from_string(self, origin_token):
        try:
            origin_version = origin_token[:VERSION_LENGTH]
            if origin_version != get_version():
                return False

            buffer = zlib.decompress(
                base64.b64decode(origin_token[VERSION_LENGTH:]))
            signature, buffer = unpack_string(buffer)
            self.__app_id, buffer = unpack_string(buffer)
            self.__issue_ts, buffer = unpack_uint32(buffer)
            self.__expire, buffer = unpack_uint32(buffer)
            self.__salt, buffer = unpack_uint32(buffer)
            service_count, buffer = unpack_uint16(buffer)

            for i in range(service_count):
                service_type, buffer = unpack_uint16(buffer)
                service = AccessToken.kServices[service_type]()
                buffer = service.unpack(buffer)
                self.__service[service_type] = service
        except Exception as e:
            print('Error: {}'.format(repr(e)))
            raise ValueError('Error: parse origin token failed')
        return True
