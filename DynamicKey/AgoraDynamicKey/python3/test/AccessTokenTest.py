import sys
import unittest
import os
import time
from random import randint
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.AccessToken import AccessToken,kJoinChannel

appID = "test_app_id"
appCertificate = "test_app_certificate"
channelName = "test_channel_name"
uid = 123456
expireTimestamp = 1598881347
salt = 1
ts = 1598181347


class AccessTokenTest(unittest.TestCase):

    def test_(self):
        expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW"

        key = AccessToken(appID, appCertificate, channelName, uid)
        key.salt = salt
        key.ts = ts
        key.messages[kJoinChannel] = expireTimestamp

        result = key.build()
        print(result)
        self.assertEqual(expected, result)

        # test uid = 0
        expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW"

        uid_zero = 0
        key = AccessToken(appID, appCertificate, channelName, uid_zero)
        key.salt = salt
        key.ts = ts
        key.messages[kJoinChannel] = expireTimestamp

        result = key.build()
        self.assertEqual(expected, result)


if __name__ == "__main__":
    unittest.main()
