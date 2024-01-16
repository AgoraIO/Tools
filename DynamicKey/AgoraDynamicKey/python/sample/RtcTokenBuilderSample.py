# ! -*- coding: utf-8 -*-

import sys
import unittest
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from RtcTokenBuilder import *
import AccessToken

# Need to set environment variable AGORA_APP_ID
appID = os.environ.get("AGORA_APP_ID")
# Need to set environment variable AGORA_APP_CERTIFICATE
appCertificate = os.environ.get("AGORA_APP_CERTIFICATE")

channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
userAccount = "2882341273"
expireTimeInSeconds = 3600
currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expireTimeInSeconds


def main():
    token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Attendee, privilegeExpiredTs)
    print("Token with int uid: {}".format(token))
    token = RtcTokenBuilder.buildTokenWithAccount(appID, appCertificate, channelName, userAccount, Role_Attendee, privilegeExpiredTs)
    print("Token with user account: {}".format(token))

if __name__ == "__main__":
    main()
