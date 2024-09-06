#! /usr/bin/python
# ! -*- coding: utf-8 -*-

import sys
import os
import time
from random import randint
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.RtcTokenBuilder import RtcTokenBuilder, Role_Publisher

# Need to set environment variable AGORA_APP_ID
appId = os.environ.get("AGORA_APP_ID")
# Need to set environment variable AGORA_APP_CERTIFICATE
appCertificate = os.environ.get("AGORA_APP_CERTIFICATE")

channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
userAccount = "2882341273"
expireTimeInSeconds = 3600
currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expireTimeInSeconds


def main():
    print("App Id: %s" % appId)
    print("App Certificate: %s" % appCertificate)
    if not appId or not appCertificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return

    token = RtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, Role_Publisher, privilegeExpiredTs)
    print("Token with int uid: {}".format(token))

    token = RtcTokenBuilder.buildTokenWithAccount(appId, appCertificate, channelName,
                                                  userAccount, Role_Publisher, privilegeExpiredTs)
    print("Token with user account: {}".format(token))


if __name__ == "__main__":
    main()
