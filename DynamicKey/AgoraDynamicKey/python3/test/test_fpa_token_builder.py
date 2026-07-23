# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.fpa_token_builder import *


class TestFpaTokenBuilder(unittest.TestCase):
    def setUp(self) -> None:
        """Create FPA token fixtures shared by each test."""
        self.__app_id = '970CA35de60c44645bbae8a215061b33'
        self.__app_cert = '5CFd2fd1755d40ecb72977518be15d3b'
        self.__expire = 24 * 3600

    def test_build_token(self):
        """Build and parse an FPA login token."""
        token = FpaTokenBuilder.build_token(self.__app_id, self.__app_cert)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        services = parser.get_services(ServiceFpa.kServiceType)
        self.assertEqual(len(services), 1)
        parser_service = services[0]

        self.assertIn(ServiceFpa.kPrivilegeLogin, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceFpa.kPrivilegeLogin], 0)
