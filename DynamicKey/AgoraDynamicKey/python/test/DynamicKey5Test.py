import sys
import unittest
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from DynamicKey5 import *

appID = "970ca35de60c44645bbae8a215061b33"
appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
channelname = "7d72365eb983485397e3e3f9d460bdda"
unixts = 1446455472
uid = 2882341273
randomint = 58964981
expiredts = 1446455471


class DynamicKeyTest(unittest.TestCase):

    def test_publicsharing(self):
        expected = "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
        actual = generatePublicSharingKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        self.assertEqual(expected, actual)

    def test_recording(self):
        expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
        actual = generateRecordingKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        # self.assertEqual(expected, actual)

    def test_mediachannel(self):
        expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
        actual = generateMediaChannelKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        # self.assertEqual(expected, actual)

    def test_InChannelPermission(self):
        noUpload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw";
        actual = generateInChannelPermissionKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts, NoUpload)
        self.assertEqual(noUpload, actual)
        audioVideoUpload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz";
        actual = generateInChannelPermissionKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts, AudioVideoUpload)
        self.assertEqual(audioVideoUpload, actual)


if __name__ == "__main__":
    unittest.main()
