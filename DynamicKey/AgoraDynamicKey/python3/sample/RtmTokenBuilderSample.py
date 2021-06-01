# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import time

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtmTokenBuilder import *


def main():
    appID = "970CA35de60c44645bbae8a215061b33"
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
    user = "test_user_id"
    expirationTimeInSeconds = 3600
    currentTimestamp = int(time.time())
    privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds


    token = RtmTokenBuilder.buildToken(appID, appCertificate, user, Role_Rtm_User, privilegeExpiredTs)
    print("Rtm Token: {}".format(token))


if __name__ == "__main__":
    main()
