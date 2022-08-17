# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.SignalingToken import *


class DynamicKeyTest(unittest.TestCase):
    def setUp(self) -> None:
        self.account = "2882341273"
        self.appID = "970CA35de60c44645bbae8a215061b33"
        self.appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"

        now = 1514133234
        validTimeInSeconds = 3600 * 24
        self.expiredTsInSeconds = now + validTimeInSeconds

    def test_generate(self):
        expected = "1:970CA35de60c44645bbae8a215061b33:1514219634:82539e1f3973bcfe3f0d0c8993e6c051"
        actual = generateSignalingToken(self.account, self.appID, self.appCertificate, self.expiredTsInSeconds)
        self.assertEqual(expected, actual)


