# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.DynamicKey4 import *


class DynamicKeyTest(unittest.TestCase):
    def setUp(self) -> None:
        self.appID = "970ca35de60c44645bbae8a215061b33"
        self.appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
        self.channelname = "7d72365eb983485397e3e3f9d460bdda"
        self.unixts = 1446455472
        self.uid = 2882341273
        self.randomint = 58964981
        self.expiredts = 1446455471

    def test_publicsharing(self):
        expected = "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generatePublicSharingKey(self.appID, self.appCertificate, self.channelname, self.unixts,
                                          self.randomint, self.uid, self.expiredts)
        print(actual)
        self.assertEqual(expected, actual)

    def test_recording(self):
        expected = "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generateRecordingKey(self.appID, self.appCertificate, self.channelname, self.unixts, self.randomint,
                                      self.uid, self.expiredts)
        print(actual)
        self.assertEqual(expected, actual)

    def test_mediachannel(self):
        expected = "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generateMediaChannelKey(self.appID, self.appCertificate, self.channelname, self.unixts, self.randomint,
                                         self.uid, self.expiredts)
        print(actual)
        self.assertEqual(expected, actual)

