import sys
import time
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import SignalingToken

appID = "970ca35de60c44645bbae8a215061b33"
appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
channelName = "7d72365eb983485397e3e3f9d460bdda"
unixts = int(time.time())
account = "TestAccount"
uid = 2882341273
expiredTs = unixts + 1800  # Valid 30 minutes after authorization


def main():
    print(SignalingToken.getToken(account, appID, appCertificate, expiredTs))


if __name__ == '__main__':
    main()
