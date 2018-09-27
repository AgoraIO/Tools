import sys
import unittest
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import SignalingToken

account = "2882341273"
appID = "970CA35de60c44645bbae8a215061b33"
appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
now = 1514133234
validTimeInSeconds = 3600 * 24
expiredTsInSeconds = now + validTimeInSeconds


class DynamicKeyTest(unittest.TestCase):

    def test_generate(self):
        expected = "1:970CA35de60c44645bbae8a215061b33:1514219634:82539e1f3973bcfe3f0d0c8993e6c051"
        actual = SignalingToken.generateSignalingToken(
            account, appID, appCertificate, expiredTsInSeconds)
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
