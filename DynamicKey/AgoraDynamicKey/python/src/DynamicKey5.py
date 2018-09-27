import hmac
from hashlib import sha1
import ctypes
import base64
import struct

# service type
MEDIA_CHANNEL_SERVICE = 1
RECORDING_SERVICE = 2
PUBLIC_SHARING_SERVICE = 3
IN_CHANNEL_PERMISSION = 4

# extra key
ALLOW_UPLOAD_IN_CHANNEL = 1

# permision
NoUpload = "0"
AudioVideoUpload = "3"


def generatePublicSharingKey(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs
):
    return generateDynamicKey(
        PUBLIC_SHARING_SERVICE,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs, {}
    )


def generateRecordingKey(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs):
    return generateDynamicKey(
        RECORDING_SERVICE,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        {})


def generateMediaChannelKey(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs):
    return generateDynamicKey(
        MEDIA_CHANNEL_SERVICE,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        {})


def generateInChannelPermissionKey(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs, permission):
    extra = {}
    extra[ALLOW_UPLOAD_IN_CHANNEL] = permission
    return generateDynamicKey(
        IN_CHANNEL_PERMISSION,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        extra)


def generateDynamicKey(
        servicetype,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        extra
):
    uid = ctypes.c_uint(uid).value
    randomInt = ctypes.c_uint(randomInt).value
    signature = generateSignature(
        servicetype,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        extra
    )
    version = '{0:0>3}'.format(5)
    content = packUint16(servicetype) \
              + packString(signature) \
              + packString(appID.decode('hex')) \
              + packUint32(unixTs) \
              + packUint32(randomInt) \
              + packUint32(expiredTs) \
              + packMap(extra)
    return version + base64.b64encode(content)


def packUint16(x):
    return struct.pack('<H', int(x))


def packUint32(x):
    return struct.pack('<I', int(x))


def packInt32(x):
    return struct.pack('<i', int(x))


def packString(string):
    return packUint16(len(string)) + string


def packMap(m):
    ret = packUint16(len(m.items()))
    for k, v in m.items():
        ret += packUint16(k) + packString(v)
    return ret


def generateSignature(
        servicetype,
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        extra,
):
    content = packUint16(servicetype) \
              + packString(appID.decode('hex')) \
              + packUint32(unixTs) \
              + packUint32(randomInt) \
              + packString(channelName) \
              + packUint32(uid) \
              + packUint32(expiredTs) \
              + packMap(extra)
    signature = hmac.new(appCertificate.decode('hex'), content, sha1).hexdigest()
    return signature.upper()
