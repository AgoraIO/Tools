import sys
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from DynamicKey5 import *

appID = "970ca35de60c44645bbae8a215061b33"
appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
channelname = "7d72365eb983485397e3e3f9d460bdda"
unixts = int(time.time())
uid = 2882341273
randomint = 2147483699
expiredts = 0

print "%.8x" % (randomint & 0xFFFFFFFF)

if __name__ == "__main__":
    print generateRecordingKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts)
    print generateMediaChannelKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts)
    print generatePublicSharingKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts)
    print generateInChannelPermissionKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts,
                                         NoUpload)
    print generateInChannelPermissionKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts,
                                         AudioVideoUpload)
