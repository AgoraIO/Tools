# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.stt_token_builder import *
from src.RtcTokenBuilder2 import Role_Publisher, Role_Subscriber


class TestSttTokenBuilder(unittest.TestCase):
    def setUp(self) -> None:
        """Create STT token fixtures shared by each test."""
        self.__app_id = '970CA35de60c44645bbae8a215061b33'
        self.__app_cert = '5CFd2fd1755d40ecb72977518be15d3b'
        self.__channel_name = '7d72365eb983485397e3e3f9d460bdda'
        self.__rtc_account = '2882341273'
        self.__rtm_user_id = '2882341273'
        self.__rtc_token_expire = 600
        self.__join_channel_privilege_expire = 600
        self.__pub_audio_privilege_expire = 600
        self.__pub_video_privilege_expire = 600
        self.__pub_data_stream_privilege_expire = 600
        self.__rtm_token_expire = 600

    def test_build_token(self):
        """Build and parse a publisher STT token."""
        token = SttTokenBuilder.build_token(
            self.__app_id, self.__app_cert, self.__channel_name, self.__rtc_account,
            Role_Publisher, self.__rtc_token_expire, self.__join_channel_privilege_expire,
            self.__pub_audio_privilege_expire, self.__pub_video_privilege_expire,
            self.__pub_data_stream_privilege_expire, self.__rtm_user_id, self.__rtm_token_expire)
        parser = AccessToken()

        self.assertTrue(parser.from_string(token))
        self.assertTrue(parser.verify_signature(self.__app_cert))
        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__rtc_token_expire)

        rtc_services = parser.get_services(ServiceRtc.kServiceType)
        self.assertEqual(1, len(rtc_services))
        self.assertEqual(self.__channel_name.encode('utf-8'), rtc_services[0]._ServiceRtc__channel_name)
        self.assertEqual(self.__rtc_account.encode('utf-8'), rtc_services[0]._ServiceRtc__uid)
        self.assertEqual(
            self.__join_channel_privilege_expire,
            rtc_services[0]._Service__privileges[ServiceRtc.kPrivilegeJoinChannel])
        self.assertEqual(
            self.__pub_audio_privilege_expire,
            rtc_services[0]._Service__privileges[ServiceRtc.kPrivilegePublishAudioStream])
        self.assertEqual(
            self.__pub_video_privilege_expire,
            rtc_services[0]._Service__privileges[ServiceRtc.kPrivilegePublishVideoStream])
        self.assertEqual(
            self.__pub_data_stream_privilege_expire,
            rtc_services[0]._Service__privileges[ServiceRtc.kPrivilegePublishDataStream])

        rtm_services = parser.get_services(ServiceRtm.kServiceType)
        self.assertEqual(1, len(rtm_services))
        self.assertEqual(self.__rtm_user_id.encode('utf-8'), rtm_services[0]._ServiceRtm__user_id)
        self.assertEqual(self.__rtm_token_expire, rtm_services[0]._Service__privileges[ServiceRtm.kPrivilegeLogin])

        stt_services = parser.get_services(ServiceStt.kServiceType)
        self.assertEqual(1, len(stt_services))
        self.assertEqual(ServiceStt.kServiceType, stt_services[0].service_type())
        self.assertEqual({}, stt_services[0]._Service__privileges)

    def test_build_subscriber_token(self):
        """Build and parse a subscriber STT token."""
        token = SttTokenBuilder.build_token(
            self.__app_id, self.__app_cert, self.__channel_name, self.__rtc_account,
            Role_Subscriber, self.__rtc_token_expire, self.__join_channel_privilege_expire,
            self.__pub_audio_privilege_expire, self.__pub_video_privilege_expire,
            self.__pub_data_stream_privilege_expire, self.__rtm_user_id, self.__rtm_token_expire)
        parser = AccessToken()

        self.assertTrue(parser.from_string(token))
        rtc_service = parser.get_services(ServiceRtc.kServiceType)[0]
        self.assertEqual(
            {ServiceRtc.kPrivilegeJoinChannel: self.__join_channel_privilege_expire},
            rtc_service._Service__privileges)

        rtm_service = parser.get_services(ServiceRtm.kServiceType)[0]
        self.assertEqual(self.__rtm_token_expire, rtm_service._Service__privileges[ServiceRtm.kPrivilegeLogin])

    def test_build_token_with_invalid_credentials(self):
        """Return an empty string when credentials are invalid."""
        self.assertEqual(
            '',
            SttTokenBuilder.build_token(
                'invalid', self.__app_cert, self.__channel_name, self.__rtc_account,
                Role_Publisher, self.__rtc_token_expire, self.__join_channel_privilege_expire,
                self.__pub_audio_privilege_expire, self.__pub_video_privilege_expire,
                self.__pub_data_stream_privilege_expire, self.__rtm_user_id, self.__rtm_token_expire))
        self.assertEqual(
            '',
            SttTokenBuilder.build_token(
                self.__app_id, 'invalid', self.__channel_name, self.__rtc_account,
                Role_Publisher, self.__rtc_token_expire, self.__join_channel_privilege_expire,
                self.__pub_audio_privilege_expire, self.__pub_video_privilege_expire,
                self.__pub_data_stream_privilege_expire, self.__rtm_user_id, self.__rtm_token_expire))
