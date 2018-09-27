#! /usr/bin/python
# ! -*- coding: utf-8 -*-

import sys
import unittest
import os
import time

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import SignalingToken

account = "2882341273"
appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
now = int(time.time())
validTimeInSeconds = 3600 * 24
expiredTsInSeconds = now + validTimeInSeconds


def main():
    print "Signal Token:", SignalingToken.generateSignalingToken(
        account, appID, appCertificate, expiredTsInSeconds)


if __name__ == "__main__":
    main()
