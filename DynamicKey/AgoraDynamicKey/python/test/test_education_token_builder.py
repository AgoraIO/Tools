# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2022 Agora.io, Inc."

import sys
import unittest
import os
from src.education_token_builder import *

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))


class EducationTokenBuilderTest(unittest.TestCase):
    def setUp(self):
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__room_uuid = "123"
        self.__user_id = "2882341273"
        self.__role = 1
        self.__expire = 900

    def test_room_user_token(self):
        token = EducationTokenBuilder.build_room_user_token(
            self.__app_id, self.__app_cert, self.__room_uuid, self.__user_id, self.__role, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceEducation.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceEducation.kServiceType]

        self.assertEqual(parser_service._ServiceEducation__room_uuid, self.__room_uuid.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__user_uuid, self.__user_id.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__role, self.__role)
        self.assertIn(ServiceEducation.kPrivilegeRoomUser, parser_service._Service__privileges)

    def test_user_token(self):
        token = EducationTokenBuilder.build_user_token(
            self.__app_id, self.__app_cert, self.__user_id, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceEducation.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceEducation.kServiceType]
        self.assertEqual(parser_service._ServiceEducation__room_uuid, ''.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__user_uuid, self.__user_id.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__role, -1)
        self.assertIn(ServiceEducation.kPrivilegeUser, parser_service._Service__privileges)

    def test_app_token(self):
        token = EducationTokenBuilder.build_app_token(
            self.__app_id, self.__app_cert, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceEducation.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceEducation.kServiceType]
        self.assertEqual(parser_service._ServiceEducation__room_uuid, ''.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__user_uuid, ''.encode('utf-8'))
        self.assertEqual(parser_service._ServiceEducation__role, -1)
        self.assertIn(ServiceEducation.kPrivilegeApp, parser_service._Service__privileges)
