import sys
import unittest
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from DynamicKey4 import generateRecordingKey
from DynamicKey4 import generateMediaChannelKey
from DynamicKey4 import generatePublicSharingKey

appID = "970ca35de60c44645bbae8a215061b33"
appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
channelname = "7d72365eb983485397e3e3f9d460bdda"
unixts = 1446455472
uid = 2882341273
# randomint = -252347445
randomint = 58964981
expiredts = 1446455471


class DynamicKeyTest(unittest.TestCase):

    def test_publicsharing(self):
        expected = "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generatePublicSharingKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        print actual
        self.assertEqual(expected, actual)

    def test_recording(self):
        expected = "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generateRecordingKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        print actual
        self.assertEqual(expected, actual)

    def test_mediachannel(self):
        expected = "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
        actual = generateMediaChannelKey(
            appID,
            appCertificate,
            channelname,
            unixts,
            randomint,
            uid,
            expiredts)
        print actual
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
