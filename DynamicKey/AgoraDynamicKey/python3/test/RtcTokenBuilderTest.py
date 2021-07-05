import sys
import unittest
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.RtcTokenBuilder import RtcTokenBuilder,Role_Attendee,Role_Subscriber
from src.AccessToken import AccessToken,kJoinChannel,kPublishVideoStream,kPublishAudioStream,kPublishDataStream

appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
expireTimestamp = 1446455471
joinTs =  1614049514
audioTs = 1614049515
videoTs = 1614049516
dataTs =  1614049517
salt = 1
ts = 1111111


class RtcTokenBuilderTest(unittest.TestCase):
    def setUp(self) -> None:
        self.appID = "970CA35de60c44645bbae8a215061b33"
        self.appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
        self.channelName = "7d72365eb983485397e3e3f9d460bdda"
        self.uid = 2882341273
        self.expireTimestamp = 1446455471
        self.salt = 1
        self.ts = 1111111

    def test_token(self):
        token = RtcTokenBuilder.buildTokenWithUid(self.appID, self.appCertificate, self.channelName, self.uid,
                                                  Role_Subscriber, self.expireTimestamp)
        parser = AccessToken()
        parser.fromString(token)

        self.assertEqual(parser.messages[kJoinChannel], expireTimestamp)
        self.assertNotIn(kPublishVideoStream, parser.messages)
        self.assertNotIn(kPublishAudioStream, parser.messages)
        self.assertNotIn(kPublishDataStream, parser.messages)

