import hmac
from hashlib import sha1
import sys

import ctypes


def generateSignaure(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs):
    key = "\x00" * (32 - len(appID)) + appID
    content = key + \
              '{:0>10}'.format(unixTs) + \
              "%.8x" % (int(randomInt) & 0xFFFFFFFF) + \
              str(channelName) + \
              '{:0>10}'.format(uid) + \
              '{:0>10}'.format(expiredTs)
    signature = hmac.new(appCertificate, content, sha1).hexdigest()
    return signature


def generate(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs):
    uid = ctypes.c_uint(uid).value
    randomInt = ctypes.c_uint(randomInt).value
    key = "\x00" * (32 - len(appID)) + appID
    signature = generateSignaure(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs)
    version = '{0:0>3}'.format(3)
    ret = version + str(signature) + \
          appID + \
          '{0:0>10}'.format(unixTs) + \
          "%.8x" % (int(randomInt) & 0xFFFFFFFF) + \
          '{:0>10}'.format(uid) + \
          '{:0>10}'.format(expiredTs)
    return ret
