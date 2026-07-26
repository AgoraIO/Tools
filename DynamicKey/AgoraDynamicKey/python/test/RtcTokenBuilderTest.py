import sys
import unittest
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from RtcTokenBuilder import *
from AccessToken import *

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
expireTimestamp = 1446455471
salt = 1
ts = 1111111


class RtcTokenBuilderTest(unittest.TestCase):
    def test_buildTokenWithUid(self):
        """Build the expected legacy RTC token for a numeric user ID."""
        token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Subscriber, expireTimestamp)
        parser = AccessToken()
        parser.fromString(token)

        self.assertEqual(parser.messages[kJoinChannel], expireTimestamp)
        self.assertNotIn(kPublishVideoStream, parser.messages)
        self.assertNotIn(kPublishAudioStream, parser.messages)
        self.assertNotIn(kPublishDataStream, parser.messages)

    def test_build_token_with_publisher_account(self):
        """Include all legacy publish privileges for a publisher account."""
        token = RtcTokenBuilder.buildTokenWithAccount(
            appID, appCertificate, channelName, str(uid), Role_Publisher, expireTimestamp)
        parser = AccessToken()
        self.assertTrue(parser.fromString(token))

        self.assertEqual(parser.messages[kJoinChannel], expireTimestamp)
        self.assertEqual(parser.messages[kPublishVideoStream], expireTimestamp)
        self.assertEqual(parser.messages[kPublishAudioStream], expireTimestamp)
        self.assertEqual(parser.messages[kPublishDataStream], expireTimestamp)


if __name__ == "__main__":
    unittest.main()
