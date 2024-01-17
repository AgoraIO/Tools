# ! -*- coding: utf-8 -*-

import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from RtmTokenBuilder import *

# Need to set environment variable AGORA_APP_ID
appId = os.environ.get("AGORA_APP_ID")
# Need to set environment variable AGORA_APP_CERTIFICATE
appCertificate = os.environ.get("AGORA_APP_CERTIFICATE")

user = "test_user_id"
expirationTimeInSeconds = 3600
currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

def main():
    print("App Id: %s" % appId)
    print("App Certificate: %s" % appCertificate)
    if not appId or not appCertificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return
    
    token = RtmTokenBuilder.buildToken(appId, appCertificate, user, Role_Rtm_User, privilegeExpiredTs)
    print("Rtm Token: {}".format(token))


if __name__ == "__main__":
    main()
