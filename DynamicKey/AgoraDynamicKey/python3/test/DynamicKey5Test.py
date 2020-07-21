# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from src.DynamicKey5 import *


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
        expected = "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9bu" \
                   "DA68oN1YAAA=="
        actual = generatePublicSharingKey(self.appID, self.appCertificate, self.channelname, self.unixts,
                                          self.randomint, self.uid, self.expiredts)
        self.assertEqual(expected, actual)

    def test_recording(self):
        expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9bu" \
                   "DA68oN1YAAA=="
        actual = generateRecordingKey(self.appID, self.appCertificate, self.channelname, self.unixts, self.randomint,
                                      self.uid, self.expiredts)
        # self.assertEqual(expected, actual)

    def test_mediachannel(self):
        expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9bu" \
                   "DA68oN1YAAA=="
        actual = generateMediaChannelKey(self.appID, self.appCertificate, self.channelname, self.unixts, self.randomint,
                                         self.uid, self.expiredts)
        # self.assertEqual(expected, actual)

    def test_InChannelPermission(self):
        noUpload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9bu" \
                   "DA68oN1YBAAEAAQAw"
        actual = generateInChannelPermissionKey(self.appID, self.appCertificate, self.channelname, self.unixts,
                                                self.randomint, self.uid, self.expiredts, NoUpload)
        self.assertEqual(noUpload, actual)

        audioVideoUpload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzO" \
                           "wKDdW9buDA68oN1YBAAEAAQAz"
        actual = generateInChannelPermissionKey(self.appID, self.appCertificate, self.channelname, self.unixts,
                                                self.randomint, self.uid, self.expiredts, AudioVideoUpload)
        self.assertEqual(audioVideoUpload, actual)

