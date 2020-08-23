#! /usr/bin/python
# ! -*- coding: utf-8 -*-

import sys
import os
import time
from random import randint
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.RtcTokenBuilder import RtcTokenBuilder,Role_Attendee

appID = "8ff0a6fff35f491c82a7f4aa3dc2ed8a"
appCertificate = "688ee821b2fc4fdcb27a281cc1184018"
channelName = "pp"
uid = 2882341273
userAccount = "2882341273"
expireTimeInSeconds = 3600
# currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expireTimeInSeconds
# privilegeExpiredTs = 1594721225


def main():
    token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Attendee, privilegeExpiredTs)
    print("Token with int uid: {}".format(token))
    # token = RtcTokenBuilder.buildTokenWithAccount(appID, appCertificate, channelName, userAccount, Role_Attendee, privilegeExpiredTs)
    # print("Token with user account: {}".format(token))

if __name__ == "__main__":
    main()
