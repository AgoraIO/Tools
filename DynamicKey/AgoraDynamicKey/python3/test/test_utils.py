import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.utils import *

class UtilsTest(unittest.TestCase):
    def setUp(self) -> None:
        self.__md5_source = '1234567890'
        self.__md5_data = 'e807f1fcf82d132f9bb018ca6738a19f'

    def test_md5(self):
        data = get_md5(self.__md5_source)

        self.assertEqual(data, self.__md5_data)
