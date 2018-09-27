import sys
import unittest
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
import DynamicKey

appID = "970ca35de60c44645bbae8a215061b33"
appCertificate = "5cfd2fd1755d40ecb72977518be15d3b"
channelname = "7d72365eb983485397e3e3f9d460bdda"
unixts = 1446455472
uid = 2882341273
randomint = 58964981
expiredts = 1446455471


class DynamicKeyTest(unittest.TestCase):

    def test_generate(self):
        expected = "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5"
        actual = DynamicKey.generate(
            appID, appCertificate, channelname, unixts, randomint)
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
