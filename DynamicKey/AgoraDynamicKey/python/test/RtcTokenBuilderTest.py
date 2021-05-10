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
joinTs =  1614049514
audioTs = 1614049515
videoTs = 1614049516
dataTs =  1614049517
expireTimestamp = 1446455471
salt = 1
ts = 1111111


class RtcTokenBuilderTest(unittest.TestCase):

    def test_(self):
        # token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Subscriber, expireTimestamp)
        # parser = AccessToken()
        # parser.fromString(token)

        # self.assertEqual(parser.messages[kJoinChannel], expireTimestamp)
        # self.assertNotIn(kPublishVideoStream, parser.messages)
        # self.assertNotIn(kPublishAudioStream, parser.messages)
        # self.assertNotIn(kPublishDataStream, parser.messages)

        token = RtcTokenBuilder.buildTokenWithUidAndPrivilege(appID, appCertificate,
                                                  channelName, uid, joinTs,
                                                  audioTs, videoTs, dataTs)
        
        print(token)
        parser = AccessToken()
        parser.fromString(token)
        self.assertEqual(parser.messages[kJoinChannel], joinTs)
        self.assertEqual(parser.messages[kPublishAudioStream], audioTs)
        self.assertEqual(parser.messages[kPublishVideoStream], videoTs)
        self.assertEqual(parser.messages[kPublishDataStream], dataTs)

if __name__ == "__main__":
    unittest.main()
