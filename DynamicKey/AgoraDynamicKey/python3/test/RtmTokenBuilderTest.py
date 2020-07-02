# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken import *
from src.RtmTokenBuilder import *


class RtmTokenBuilderTest(unittest.TestCase):
    def setUp(self) -> None:
        self.appID = "970CA35de60c44645bbae8a215061b33"
        self.appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
        self.userAccount = "test_user"
        self.expireTimestamp = 1446455471
        self.salt = 1
        self.ts = 1111111

    def test_token(self):
        token = RtmTokenBuilder.buildToken(self.appID, self.appCertificate, self.userAccount, Role_Rtm_User,
                                           self.expireTimestamp)
        parser = AccessToken()
        parser.fromString(token)
        self.assertEqual(parser.messages[kRtmLogin], self.expireTimestamp)
