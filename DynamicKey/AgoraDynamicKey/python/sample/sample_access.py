#! /usr/bin/python
# ! -*- coding: utf-8 -*-

import sys
import unittest
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import AccessToken

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
expireTimestamp = 0


def main():
    key = AccessToken.AccessToken(appID, appCertificate, channelName, uid)
    key.addPrivilege(AccessToken.kJoinChannel, expireTimestamp)

    result = key.build()
    print result


if __name__ == "__main__":
    main()
