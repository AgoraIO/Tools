# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import time
import hmac
import zlib
import random

from hashlib import sha256
from collections import OrderedDict

from .Packer import *


VERSION_LENGTH = 3


def get_version():
    return b'007'


class Service:
    def __init__(self, service_type):
        self.__type = service_type
        self.__privileges = {}

    def __pack_type(self):
        return pack_uint16(self.__type)

    def __pack_privileges(self):
        privileges = OrderedDict(sorted(iter(self.__privileges.items()), key=lambda x: int(x[0])))
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


class ServiceStreaming(Service):
    kServiceType = 3

    kPrivilegePublishMixStream = 1
    kPrivilegePublishRawStream = 2

    def __init__(self, channel_name=''):
        super(ServiceStreaming, self).__init__(ServiceStreaming.kServiceType)
        self.__channel_name = channel_name.encode('utf-8')
        self.__uid = b''

    def pack(self):
        return super(ServiceStreaming, self).pack() + pack_string(self.__channel_name) + pack_string(self.__uid)

    def unpack(self, buffer):
        buffer = super(ServiceStreaming, self).unpack(buffer)
        self.__channel_name, buffer = unpack_string(buffer)
        self.__uid, buffer = unpack_string(buffer)
        return buffer


class AccessToken:
    kServices = {
        ServiceRtc.kServiceType: ServiceRtc,
        ServiceRtm.kServiceType: ServiceRtm,
        ServiceStreaming.kServiceType: ServiceStreaming
    }

    def __init__(self, app_id='', app_certificate='', issue_ts=0, expire=900):
        random.seed(time.time())

        self.__app_id = app_id.encode('utf-8')
        self.__app_cert = app_certificate.encode('utf-8')

        self.__issue_ts = issue_ts if issue_ts != 0 else int(time.time())
        self.__expire = expire
        self.__salt = random.randint(1, 99999999)

        self.__service = {}

    def __signing(self):
        signing = hmac.new(pack_uint32(self.__issue_ts), self.__app_cert, sha256).digest()
        signing = hmac.new(pack_uint32(self.__salt), signing, sha256).digest()
        return signing

    def add_service(self, service):
        self.__service[service.service_type()] = service

    def build(self):
        signing = self.__signing()

        signing_info = pack_string(self.__app_id) + pack_uint32(self.__issue_ts) + pack_uint32(self.__expire) + \
            pack_uint32(self.__salt) + pack_uint16(len(self.__service))

        for _, service in self.__service.items():
            signing_info += service.pack()

        signature = hmac.new(signing, signing_info, sha256).digest()

        return get_version() + zlib.compress(pack_string(signature) + signing_info)

    def from_string(self, origin_token):
        if not isinstance(origin_token, bytes):
            raise TypeError('Error: expect origin_token bytes, but got {}'.format(type(origin_token).__name__))

        try:
            origin_version = origin_token[:VERSION_LENGTH]
            if origin_version != get_version():
                return False

            buffer = zlib.decompress(origin_token[VERSION_LENGTH:])
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

