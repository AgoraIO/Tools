# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import time

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtcTokenBuilder import *


def main():
    appID = "970CA35de60c44645bbae8a215061b33"
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
    channelName = "7d72365eb983485397e3e3f9d460bdda"
    uid = 2882341273
    userAccount = "2882341273"
    expireTimeInSeconds = 3600
    currentTimestamp = int(time.time())
    privilegeExpiredTs = currentTimestamp + expireTimeInSeconds

    token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Attendee, privilegeExpiredTs)
    print("Token with int uid: {}".format(token))
    token = RtcTokenBuilder.buildTokenWithAccount(appID, appCertificate, channelName, userAccount, Role_Attendee, privilegeExpiredTs)
    print("Token with user account: {}".format(token))


if __name__ == "__main__":
    main()
