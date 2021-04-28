# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import sys
import unittest
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtmTokenBuilder2 import *


class RtmTokenBuilder2Test(unittest.TestCase):
    def setUp(self):
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__user_id = "test_user"
        self.__expire = 600

    def test_token(self):
        token = RtmTokenBuilder.build_token(self.__app_id, self.__app_cert, self.__user_id, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtm.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtm.kServiceType]

        self.assertEqual(parser_service._ServiceRtm__user_id, self.__user_id.encode('utf-8'))
        self.assertIn(ServiceRtm.kPrivilegeLogin, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtm.kPrivilegeLogin], self.__expire)
