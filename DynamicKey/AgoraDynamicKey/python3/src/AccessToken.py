# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import hmac
import time
import base64
import secrets
import warnings

from zlib import crc32
from hashlib import sha256
from collections import OrderedDict

from .Packer import *


warnings.warn('The AccessToken module is deprecated', DeprecationWarning)


kJoinChannel = 1
kPublishAudioStream = 2
kPublishVideoStream = 3
kPublishDataStream = 4

kPublishAudioCdn = 5  # deprecated, unused
kPublishVideoCdn = 6  # deprecated, unused
kRequestPublishAudioStream = 7  # deprecated, unused
kRequestPublishVideoStream = 8  # deprecated, unused
kRequestPublishDataStream = 9  # deprecated, unused
kInvitePublishAudioStream = 10  # deprecated, unused
kInvitePublishVideoStream = 11  # deprecated, unused
kInvitePublishDataStream = 12  # deprecated, unused
kAdministrateChannel = 101  # deprecated, unused

kRtmLogin = 1000

VERSION_LENGTH = 3
APP_ID_LENGTH = 32


def getVersion():
    return '006'


def unPackContent(buff):
    signature, buff = unpack_string(buff)
    crc_channel_name, buff = unpack_uint32(buff)
    crc_uid, buff = unpack_uint32(buff)
    m, buff = unpack_string(buff)
    return signature, crc_channel_name, crc_uid, m


def unPackMessages(buff):
    salt, buff = unpack_uint32(buff)
    ts, buff = unpack_uint32(buff)
    messages, buff = unpack_map_uint32(buff)
    return salt, ts, messages


class AccessToken:
    def __init__(self, appID='', appCertificate='', channelName='', uid=''):
        self.appID = appID
        self.appCertificate = appCertificate
        self.channelName = channelName
        self.ts = int(time.time()) + 24 * 3600
        self.salt = secrets.SystemRandom().randint(1, 99999999)
        self.messages = {}
        self.uidStr = '' if uid == 0 else str(uid)

    def addPrivilege(self, privilege, expireTimestamp):
        self.messages[privilege] = expireTimestamp

    def fromString(self, originToken):
        try:
            dk6version = getVersion()
            originVersion = originToken[:VERSION_LENGTH]
            if originVersion != dk6version:
                return False

            originAppID = originToken[VERSION_LENGTH:(VERSION_LENGTH + APP_ID_LENGTH)]
            originContent = originToken[(VERSION_LENGTH + APP_ID_LENGTH):]
            originContentDecoded = base64.b64decode(originContent)

            signature, crc_channel_name, crc_uid, m = unPackContent(originContentDecoded)
            self.salt, self.ts, self.messages = unPackMessages(m)

        except Exception as e:
            print("error:", str(e))
            return False

        return True

    def build(self):
        self.messages = OrderedDict(sorted(iter(self.messages.items()), key=lambda x: int(x[0])))

        m = pack_uint32(self.salt) + pack_uint32(self.ts) + pack_map_uint32(self.messages)
        val = self.appID.encode('utf-8') + self.channelName.encode('utf-8') + self.uidStr.encode('utf-8') + m

        signature = hmac.new(self.appCertificate.encode('utf-8'), val, sha256).digest()
        crc_channel_name = crc32(self.channelName.encode('utf-8')) & 0xffffffff
        crc_uid = crc32(self.uidStr.encode('utf-8')) & 0xffffffff

        content = pack_string(signature) + pack_uint32(crc_channel_name) + pack_uint32(crc_uid) + pack_string(m)

        version = getVersion()
        ret = version + self.appID + base64.b64encode(content).decode('utf-8')
        return ret
