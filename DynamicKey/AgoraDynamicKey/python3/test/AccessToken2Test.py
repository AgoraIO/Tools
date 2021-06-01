# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken2 import *


class AccessToken2Test(unittest.TestCase):
    def setUp(self) -> None:
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__channel_name = "7d72365eb983485397e3e3f9d460bdda"
        self.__user_id = 'test_user'
        self.__uid = 2882341273
        self.__uid_str = '2882341273'
        self.__expire = 600
        self.__salt = 1
        self.__ts = 1111111

        self.__token = AccessToken(self.__app_id, self.__app_cert, issue_ts=self.__ts, expire=self.__expire)
        self.__token._AccessToken__salt = self.__salt

    def test_service_rtc(self):
        service = ServiceRtc(self.__channel_name, self.__uid)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcw' \
                   'Mk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertEqual(expected, result)

    def test_service_rtc_uid_0(self):
        service = ServiceRtc(self.__channel_name, 0)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcw' \
                   'Mk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='
        self.assertEqual(expected, result)

    def test_service_rtc_account(self):
        service = ServiceRtc(self.__channel_name, str(self.__uid))
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcw' \
                   'Mk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertEqual(expected, result)

    def test_service_chat_user(self):
        service = ServiceChat(self.__uid_str)
        service.add_privilege(ServiceChat.kPrivilegeUser, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTA' \
                   'zTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg='

        self.assertEqual(expected, result)

    def test_service_chat_app(self):
        service = ServiceChat()
        service.add_privilege(ServiceChat.kPrivilegeApp, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGa' \
                   'YZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr'

        self.assertEqual(expected, result)

    def test_multi_service(self):
        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)
        rtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, self.__expire)
        rtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, self.__expire)
        rtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, self.__expire)

        rtm = ServiceRtm(self.__user_id)
        rtm.add_privilege(ServiceRtm.kPrivilegeLogin, self.__expire)

        streaming = ServiceStreaming(self.__channel_name, self.__uid)
        streaming.add_privilege(ServiceStreaming.kPrivilegePublishMixStream, self.__expire)
        streaming.add_privilege(ServiceStreaming.kPrivilegePublishRawStream, self.__expire)

        rtns = ServiceRtns()

        chat = ServiceChat(self.__uid_str)
        chat.add_privilege(ServiceChat.kPrivilegeUser, self.__expire)

        self.__token.add_service(rtc)
        self.__token.add_service(rtm)
        self.__token.add_service(streaming)
        self.__token.add_service(rtns)
        self.__token.add_service(chat)

        result = self.__token.build()

        expected = '007eJxTYAh5UWu1drfhsnu9etvupS0v/iFs+3PC/Sbl8gdht55xSusqMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpg' \
                   'ZJhkbu38RYIhgYmBgZGBgYAWSLEAM4jOBSWYwyQImFRjMU8yNjM1MU5MsLYxNLEyNLc1TjVON0yxTTMwMklJSErkYjCwsj' \
                   'IxNDI3MjZmA5kBM4mQoSS0uiS8tTi1iZmBCMZ40I1mgToSYgCwDAGL1OcI='
                   
        self.assertEqual(expected, result)

