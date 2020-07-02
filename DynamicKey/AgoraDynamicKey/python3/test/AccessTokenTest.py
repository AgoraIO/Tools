# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken import *


class AccessTokenTest(unittest.TestCase):
    def setUp(self) -> None:
        self.appID = "970CA35de60c44645bbae8a215061b33"
        self.appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
        self.channelName = "7d72365eb983485397e3e3f9d460bdda"
        self.uid = 2882341273
        self.expireTimestamp = 1446455471
        self.salt = 1
        self.ts = 1111111

    def test_token(self):
        expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlE" \
                   "AABAAAAR/QQAAEAAQCvKDdW"

        key = AccessToken(self.appID, self.appCertificate, self.channelName, self.uid)
        key.salt = self.salt
        key.ts = self.ts
        key.messages[kJoinChannel] = self.expireTimestamp

        result = key.build()
        self.assertEqual(expected, result)

    def test_token_uid_0(self):
        expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAE" \
                   "AABAAAAR/QQAAEAAQCvKDdW"

        uid_zero = 0
        key = AccessToken(self.appID, self.appCertificate, self.channelName, uid_zero)
        key.salt = self.salt
        key.ts = self.ts
        key.messages[kJoinChannel] = self.expireTimestamp

        result = key.build()
        self.assertEqual(expected, result)


