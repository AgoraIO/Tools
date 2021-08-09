import hmac
from hashlib import sha256
import base64
import struct
from zlib import crc32
import secrets
import time
from collections import OrderedDict

Role_Attendee = 0  # depreated, same as publisher
Role_Publisher = 1  # for live broadcaster
Role_Subscriber = 2  # default, for live audience
Role_Admin = 101  # deprecated, same as publisher

kJoinChannel = 1
kPublishAudioStream = 2
kPublishVideoStream = 3
kPublishDataStream = 4
kPublishAudiocdn = 5
kPublishVideoCdn = 6
kRequestPublishAudioStream = 7
kRequestPublishVideoStream = 8
kRequestPublishDataStream = 9
kInvitePublishAudioStream = 10
kInvitePublishVideoStream = 11
kInvitePublishDataStream = 12
kAdministrateChannel = 101
kRtmLogin = 1000

VERSION_LENGTH = 3
APP_ID_LENGTH = 32


def getVersion():
    return '006'


def packUint16(x):
    return struct.pack('<H', int(x))


def packUint32(x):
    return struct.pack('<I', int(x))


def packInt32(x):
    return struct.pack('<i', int(x))


def packString(string):
    return packUint16(len(string)) + string


def packMap(m):
    ret = packUint16(len(list(m.items())))
    for k, v in list(m.items()):
        ret += packUint16(k) + packString(v)
    return ret


def packMapUint32(m):
    ret = packUint16(len(list(m.items())))
    for k, v in list(m.items()):
        ret += packUint16(k) + packUint32(v)
    return ret


class ReadByteBuffer:

    def __init__(self, bytes):
        self.buffer = bytes
        self.position = 0

    def unPackUint16(self):
        len = struct.calcsize('H')
        buff = self.buffer[self.position: self.position + len]
        ret = struct.unpack('<H', buff)[0]
        self.position += len
        return ret

    def unPackUint32(self):
        len = struct.calcsize('I')
        buff = self.buffer[self.position: self.position + len]
        ret = struct.unpack('<I', buff)[0]
        self.position += len
        return ret

    def unPackString(self):
        strlen = self.unPackUint16()
        buff = self.buffer[self.position: self.position + strlen]
        ret = struct.unpack('<' + str(strlen) + 's', buff)[0]
        self.position += strlen
        return ret

    def unPackMapUint32(self):
        messages = {}
        maplen = self.unPackUint16()

        for index in range(maplen):
            key = self.unPackUint16()
            value = self.unPackUint32()
            messages[key] = value
        return messages


def unPackContent(buff):
    readbuf = ReadByteBuffer(buff)
    signature = readbuf.unPackString()
    crc_channel_name = readbuf.unPackUint32()
    crc_uid = readbuf.unPackUint32()
    m = readbuf.unPackString()

    return signature, crc_channel_name, crc_uid, m


def unPackMessages(buff):
    readbuf = ReadByteBuffer(buff)
    salt = readbuf.unPackUint32()
    ts = readbuf.unPackUint32()
    messages = readbuf.unPackMapUint32()

    return salt, ts, messages


class AccessToken:

    def __init__(self, app_id='', app_cert='', channel_name='', uid=''):
        self.appID = app_id
        self.appCertificate = app_cert
        self.channelName = channel_name
        self.ts = int(time.time()) + 24 * 3600
        self.salt = secrets.SystemRandom().randint(1, 99999999)
        self.messages = {}

        self.uidStr = str(uid)

    def add_privilege(self, privilege, expire_timestamp):
        self.messages[privilege] = expire_timestamp

    def fromString(self, originToken):
        try:
            dk6version = getVersion()
            originVersion = originToken[:VERSION_LENGTH]
            if (originVersion != dk6version):
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

        m = packUint32(self.salt) + packUint32(self.ts) \
            + packMapUint32(self.messages)

        val = self.appID.encode('utf-8') + self.channelName.encode('utf-8') + self.uidStr.encode('utf-8') + m

        signature = hmac.new(self.appCertificate.encode('utf-8'), val, sha256).digest()
        crc_channel_name = crc32(self.channelName.encode('utf-8')) & 0xffffffff
        crc_uid = crc32(self.uidStr.encode('utf-8')) & 0xffffffff

        content = packString(signature) \
                  + packUint32(crc_channel_name) \
                  + packUint32(crc_uid) \
                  + packString(m)

        version = getVersion()
        ret = version + self.appID + base64.b64encode(content).decode('utf-8')
        return ret


def build_token_with_account(app_id, app_cert, scene_name, inner_user, role, expired_ts):
    token_obj = AccessToken(app_id, app_cert, scene_name, inner_user)
    token_obj.add_privilege(kJoinChannel, expired_ts)
    if role == Role_Attendee or role == Role_Admin or role == Role_Publisher:
        token_obj.add_privilege(kPublishVideoStream, expired_ts)
        token_obj.add_privilege(kPublishAudioStream, expired_ts)
        token_obj.add_privilege(kPublishDataStream, expired_ts)
    return token_obj.build()

