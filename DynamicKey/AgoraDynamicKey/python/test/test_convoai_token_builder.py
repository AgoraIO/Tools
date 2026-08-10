# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.convoai_token_builder import *
from src.RtcTokenBuilder2 import Role_Publisher, Role_Subscriber


class TestConvoAITokenBuilder(unittest.TestCase):
    def setUp(self):
        self.__app_id = '970CA35de60c44645bbae8a215061b33'
        self.__app_cert = '5CFd2fd1755d40ecb72977518be15d3b'
        self.__channel_name = 'convoai-channel'
        self.__rtc_account = 'convoai-rtc-user'
        self.__rtm_user_id = 'convoai-rtm-user'
        self.__rtc_token_expire = 3600
        self.__join_channel_privilege_expire = 1800
        self.__pub_audio_privilege_expire = 1700
        self.__pub_video_privilege_expire = 1600
        self.__pub_data_stream_privilege_expire = 1500
        self.__rtm_token_expire = 1400

    def test_build_token(self):
        token = ConvoAITokenBuilder.build_token(
            self.__app_id, self.__app_cert, self.__channel_name, self.__rtc_account, Role_Publisher,
            self.__rtc_token_expire, self.__join_channel_privilege_expire, self.__pub_audio_privilege_expire,
            self.__pub_video_privilege_expire, self.__pub_data_stream_privilege_expire, self.__rtm_user_id,
            self.__rtm_token_expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(self.__app_id.encode('utf-8'), parser._AccessToken__app_id)
        self.assertEqual(self.__rtc_token_expire, parser._AccessToken__expire)
        self.assertEqual(self.__rtc_account.encode('utf-8'), parser.get_services(ServiceRtc.kServiceType)[0]._ServiceRtc__uid)
        self.assertEqual(self.__rtm_user_id.encode('utf-8'), parser.get_services(ServiceRtm.kServiceType)[0]._ServiceRtm__user_id)
        self.assertEqual({}, parser.get_services(ServiceConvoAI.kServiceType)[0]._Service__privileges)

    def test_build_subscriber_token(self):
        token = ConvoAITokenBuilder.build_token(
            self.__app_id, self.__app_cert, self.__channel_name, self.__rtc_account, Role_Subscriber,
            self.__rtc_token_expire, self.__join_channel_privilege_expire, self.__pub_audio_privilege_expire,
            self.__pub_video_privilege_expire, self.__pub_data_stream_privilege_expire, self.__rtm_user_id,
            self.__rtm_token_expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(
            {ServiceRtc.kPrivilegeJoinChannel: self.__join_channel_privilege_expire},
            parser.get_services(ServiceRtc.kServiceType)[0]._Service__privileges)
