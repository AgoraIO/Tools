# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtcTokenBuilder2 import *


class RtcTokenBuilder2Test(unittest.TestCase):
    def setUp(self) -> None:
        self.__app_id = '970CA35de60c44645bbae8a215061b33'
        self.__app_cert = '5CFd2fd1755d40ecb72977518be15d3b'
        self.__channel_name = '7d72365eb983485397e3e3f9d460bdda'
        self.__uid = 2882341273
        self.__account = '2882341273'
        self.__expire = 600
        self.__join_channel_privilege_expire = 600
        self.__pub_audio_privilege_expire = 600
        self.__pub_video_privilege_expire = 600
        self.__pub_data_stream_privilege_expire = 600

    def test_build_token_with_uid(self):
        token = RtcTokenBuilder.build_token_with_uid(self.__app_id, self.__app_cert, self.__channel_name, self.__uid,
                                                     Role_Subscriber, self.__expire, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtc.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtc.kServiceType]

        self.assertEqual(parser_service._ServiceRtc__channel_name, self.__channel_name.encode('utf-8'))
        self.assertEqual(parser_service._ServiceRtc__uid, str(self.__uid).encode('utf-8'))
        self.assertIn(ServiceRtc.kPrivilegeJoinChannel, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegeJoinChannel], self.__expire)
        self.assertNotIn(ServiceRtc.kPrivilegePublishAudioStream, parser_service._Service__privileges)
        self.assertNotIn(ServiceRtc.kPrivilegePublishVideoStream, parser_service._Service__privileges)
        self.assertNotIn(ServiceRtc.kPrivilegePublishDataStream, parser_service._Service__privileges)

    def test_build_token_with_user_account(self):
        token = RtcTokenBuilder.build_token_with_user_account(self.__app_id, self.__app_cert, self.__channel_name,
                                                              self.__account, Role_Subscriber, self.__expire,
                                                              self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtc.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtc.kServiceType]

        self.assertEqual(parser_service._ServiceRtc__channel_name, self.__channel_name.encode('utf-8'))
        self.assertEqual(parser_service._ServiceRtc__uid, self.__account.encode('utf-8'))
        self.assertIn(ServiceRtc.kPrivilegeJoinChannel, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegeJoinChannel], self.__expire)
        self.assertNotIn(ServiceRtc.kPrivilegePublishAudioStream, parser_service._Service__privileges)
        self.assertNotIn(ServiceRtc.kPrivilegePublishVideoStream, parser_service._Service__privileges)
        self.assertNotIn(ServiceRtc.kPrivilegePublishDataStream, parser_service._Service__privileges)

    def test_build_token_with_uid_and_privilege(self):
        token = RtcTokenBuilder.build_token_with_uid_and_privilege(
            self.__app_id, self.__app_cert, self.__channel_name, self.__uid, self.__expire,
            self.__join_channel_privilege_expire, self.__pub_audio_privilege_expire,
            self.__pub_video_privilege_expire, self.__pub_data_stream_privilege_expire)

        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtc.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtc.kServiceType]

        self.assertEqual(parser_service._ServiceRtc__channel_name, self.__channel_name.encode('utf-8'))
        self.assertEqual(parser_service._ServiceRtc__uid, str(self.__uid).encode('utf-8'))
        self.assertIn(ServiceRtc.kPrivilegeJoinChannel, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegeJoinChannel],
                         self.__join_channel_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishAudioStream],
                         self.__pub_audio_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishVideoStream],
                         self.__pub_video_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishDataStream],
                         self.__pub_data_stream_privilege_expire)
        self.assertIn(ServiceRtc.kPrivilegePublishAudioStream, parser_service._Service__privileges)
        self.assertIn(ServiceRtc.kPrivilegePublishVideoStream, parser_service._Service__privileges)
        self.assertIn(ServiceRtc.kPrivilegePublishDataStream, parser_service._Service__privileges)

    def test_build_token_with_user_account_and_privilege(self):
        token = RtcTokenBuilder.build_token_with_user_account_and_privilege(
            self.__app_id, self.__app_cert, self.__channel_name, self.__account, self.__expire,
            self.__join_channel_privilege_expire, self.__pub_audio_privilege_expire,
            self.__pub_video_privilege_expire, self.__pub_data_stream_privilege_expire)

        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtc.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtc.kServiceType]

        self.assertEqual(parser_service._ServiceRtc__channel_name, self.__channel_name.encode('utf-8'))
        self.assertEqual(parser_service._ServiceRtc__uid, self.__account.encode('utf-8'))
        self.assertIn(ServiceRtc.kPrivilegeJoinChannel, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegeJoinChannel],
                         self.__join_channel_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishAudioStream],
                         self.__pub_audio_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishVideoStream],
                         self.__pub_video_privilege_expire)
        self.assertEqual(parser_service._Service__privileges[ServiceRtc.kPrivilegePublishDataStream],
                         self.__pub_data_stream_privilege_expire)
        self.assertIn(ServiceRtc.kPrivilegePublishAudioStream, parser_service._Service__privileges)
        self.assertIn(ServiceRtc.kPrivilegePublishVideoStream, parser_service._Service__privileges)
        self.assertIn(ServiceRtc.kPrivilegePublishDataStream, parser_service._Service__privileges)
