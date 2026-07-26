import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src import DynamicKey2


class DynamicKey2Test(unittest.TestCase):
    def test_generate(self):
        """Generate the expected DynamicKey2 value with signed UID normalization."""
        result = DynamicKey2.generate(
            '970CA35de60c44645bbae8a215061b33',
            '5CFd2fd1755d40ecb72977518be15d3b',
            '7d72365eb983485397e3e3f9d460bdda',
            1446455471,
            1,
            -1,
            1446455471)

        self.assertEqual(len(result), 110)
        self.assertEqual(result[40:72], '970CA35de60c44645bbae8a215061b33')
        self.assertIn('4294967295', result)


if __name__ == '__main__':
    unittest.main()
