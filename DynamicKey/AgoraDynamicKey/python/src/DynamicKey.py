import hmac
from hashlib import sha1
import ctypes


def generateSignaure(appID, appCertificate, channelName, unixTs, randomInt):
    key = "\x00" * (32 - len(appID)) + appID
    content = key + \
              '{:0>10}'.format(unixTs) + \
              "%.8x" % (int(randomInt) & 0xFFFFFFFF) + \
              str(channelName)
    signature = hmac.new(appCertificate, content, sha1).hexdigest()
    return signature


def generate(appID, appCertificate, channelName, unixTs, randomInt):
    randomInt = ctypes.c_uint(randomInt).value
    signature = generateSignaure(
        appID,
        appCertificate,
        channelName,
        unixTs,
        randomInt)
    ret = str(signature) + \
          appID + \
          '{0:0>10}'.format(unixTs) + \
          "%.8x" % (int(randomInt) & 0xFFFFFFFF)
    return ret
