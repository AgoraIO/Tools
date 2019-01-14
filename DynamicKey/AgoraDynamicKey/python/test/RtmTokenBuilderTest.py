import sys
import unittest
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import RtmTokenBuilder
import AccessToken

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
userId = "test_user"
expireTimestamp = 1446455471
salt = 1
ts = 1111111


class RtmTokenBuilderTest(unittest.TestCase):

    def test_(self):
        expected = "006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW"

        builder = RtmTokenBuilder.RtmTokenBuilder(appID, appCertificate, userId)
        builder.token.salt = salt
        builder.token.ts = ts
        builder.token.messages[AccessToken.kRtmLogin] = expireTimestamp

        result = builder.buildToken()
        self.assertEqual(expected, result)

if __name__ == "__main__":
    unittest.main()
