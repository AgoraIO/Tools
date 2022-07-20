# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.ChatTokenBuilder2 import *


class ChatTokenBuilder2Test(unittest.TestCase):
    def setUp(self):
        self.__app_id = '970CA35de60c44645bbae8a215061b33'
        self.__app_cert = '5CFd2fd1755d40ecb72977518be15d3b'
        self.__user_id = '2882341273'
        self.__expire = 600

    def test_user_token(self):
        token = ChatTokenBuilder.build_user_token(self.__app_id, self.__app_cert, self.__user_id, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceChat.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceChat.kServiceType]

        self.assertEqual(parser_service._ServiceChat__user_id, self.__user_id.encode('utf-8'))
        self.assertIn(ServiceChat.kPrivilegeUser, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceChat.kPrivilegeUser], self.__expire)
        self.assertNotIn(ServiceChat.kPrivilegeApp, parser_service._Service__privileges)

    def test_app_token(self):
        token = ChatTokenBuilder.build_app_token(self.__app_id, self.__app_cert, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceChat.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceChat.kServiceType]

        self.assertIn(ServiceChat.kPrivilegeApp, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceChat.kPrivilegeApp], self.__expire)
        self.assertNotIn(ServiceChat.kPrivilegeUser, parser_service._Service__privileges)
