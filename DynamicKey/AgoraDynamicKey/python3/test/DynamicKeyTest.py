# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.DynamicKey import *


class DynamicKeyTest(unittest.TestCase):
    def setUp(self) -> None:
        self.appID = "970ca35de60c44645bbae8a215061b33"
        self.appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
        self.channelname = "7d72365eb983485397e3e3f9d460bdda"
        self.unixts = 1446455472
        self.uid = 2882341273
        self.randomint = 58964981
        self.expiredts = 1446455471

    def test_generate(self):
        expected = "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5"
        actual = generate(self.appID, self.appCertificate, self.channelname, self.unixts, self.randomint)
        self.assertEqual(expected, actual)

