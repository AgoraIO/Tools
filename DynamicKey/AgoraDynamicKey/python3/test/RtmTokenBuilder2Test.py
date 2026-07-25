# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import sys
import unittest
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken2 import *
from src.RtmTokenBuilder2 import *


class RtmTokenBuilder2Test(unittest.TestCase):
    def setUp(self) -> None:
        """Create RTM token fixtures shared by each test."""
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__user_id = "test_user"
        self.__expire = 600

    def test_token(self):
        """Build and parse an RTM login token."""
        token = RtmTokenBuilder.build_token(self.__app_id, self.__app_cert, self.__user_id, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        services = parser.get_services(ServiceRtm.kServiceType)
        self.assertEqual(len(services), 1)
        parser_service = services[0]

        self.assertEqual(parser_service._ServiceRtm__user_id, self.__user_id.encode('utf-8'))
        self.assertIn(ServiceRtm.kPrivilegeLogin, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtm.kPrivilegeLogin], self.__expire)
        print("token: ", token)

    def test_token_with_permissions(self):
        """Build, parse, and verify an RTM2 resource permission token."""
        permissions = ServiceRtm2.Permissions()
        permissions.add(ServiceRtm2.Permissions.kMessageChannels, ServiceRtm2.Permissions.kRead,
                        ['message-a', 'message-b'])
        permissions.add(ServiceRtm2.Permissions.kStreamChannels, ServiceRtm2.Permissions.kWrite,
                        ['stream-a'])

        token = RtmTokenBuilder.build_token_with_permissions(
            self.__app_id, self.__app_cert, self.__user_id, permissions, self.__expire)
        parser = AccessToken()

        self.assertTrue(parser.from_string(token))
        self.assertTrue(parser.verify_signature(self.__app_cert))
        service = parser.get_services(ServiceRtm2.kServiceType)[0]
        self.assertEqual(self.__user_id, service.get_user_id())
        self.assertEqual(permissions.details, service.get_permissions().details)
        self.assertEqual(self.__expire, service._Service__privileges[ServiceRtm2.kPrivilegeLogin])
