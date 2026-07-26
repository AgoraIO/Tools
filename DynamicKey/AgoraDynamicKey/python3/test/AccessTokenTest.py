import sys
import unittest
import os
import time
from random import randint
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src import AccessToken as AccessTokenModule
from src.AccessToken import AccessToken, kJoinChannel

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
expireTimestamp = 1446455471
salt = 1
ts = 1111111


class AccessTokenTest(unittest.TestCase):

    def test_(self):
        """Build the expected legacy access token."""
        expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW"

        key = AccessToken(appID, appCertificate, channelName, uid)
        key.salt = salt
        key.ts = ts
        key.messages[kJoinChannel] = expireTimestamp

        result = key.build()
        self.assertEqual(expected, result)

    def test_pack_and_parse_helpers(self):
        """Round-trip legacy scalar, string, and map packing helpers."""
        self.assertEqual(AccessTokenModule.packInt32(-7), b'\xf9\xff\xff\xff')
        packed_map = AccessTokenModule.packMap({1: b'one', 2: b'two'})
        self.assertEqual(packed_map, b'\x02\x00\x01\x00\x03\x00one\x02\x00\x03\x00two')

        token = AccessToken(appID, appCertificate, channelName, uid)
        token.salt = salt
        token.ts = ts
        token.addPrivilege(kJoinChannel, expireTimestamp)
        encoded = token.build()

        parsed = AccessToken()
        self.assertTrue(parsed.fromString(encoded))
        self.assertEqual(parsed.salt, salt)
        self.assertEqual(parsed.ts, ts)
        self.assertEqual(parsed.messages[kJoinChannel], expireTimestamp)

    def test_parse_rejects_invalid_legacy_tokens(self):
        """Reject legacy tokens with an unsupported version or malformed payload."""
        parsed = AccessToken()
        self.assertFalse(parsed.fromString('007'))
        self.assertFalse(parsed.fromString('006' + appID + '!'))

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
