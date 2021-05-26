import sys
import unittest
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from RtmTokenBuilder import *
from AccessToken import *

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
userAccount = "test_user"
expireTimestamp = 1446455471
salt = 1
ts = 1111111


class RtmTokenBuilderTest(unittest.TestCase):

    def test_(self):
        token = RtmTokenBuilder.buildToken(appID, appCertificate, userAccount, Role_Rtm_User, expireTimestamp)
        parser = AccessToken()
        parser.fromString(token)
        self.assertEqual(parser.messages[kRtmLogin], expireTimestamp)

if __name__ == "__main__":
    unittest.main()
