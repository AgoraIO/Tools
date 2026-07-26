import unittest
from collections import OrderedDict

from src.Packer import *
from src.utils import *


class UtilsTest(unittest.TestCase):
    def setUp(self):
        """Create utility function fixtures shared by each test."""
        self.__md5_source = '1234567890'
        self.__md5_data = 'e807f1fcf82d132f9bb018ca6738a19f'

    def test_md5(self):
        """Calculate the expected MD5 digest."""
        data = get_md5(self.__md5_source)

        self.assertEqual(data, self.__md5_data)

    def test_string_map_packing(self):
        """Round-trip maps containing length-prefixed byte strings."""
        source = OrderedDict([(1, b'alpha'), (2, b'beta')])
        packed = pack_map_string(source)
        unpacked, remaining = unpack_map_string(packed + b'tail')

        self.assertEqual(unpacked, source)
        self.assertEqual(remaining, b'tail')
