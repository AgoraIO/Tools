# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken import *


class AccessTokenTest(unittest.TestCase):
    def setUp(self) -> None:
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__channel_name = "7d72365eb983485397e3e3f9d460bdda"
        self.__uid = 2882341273
        self.__expire = 600
        self.__salt = 1
        self.__ts = 1111111

    def test_service_rtc(self):
        token = AccessToken(self.__app_id, self.__app_cert, issue_ts=self.__ts, expire=self.__expire)
        token._AccessToken__salt = self.__salt

        service = ServiceRtc(self.__channel_name, self.__uid)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        token.add_service(service)
        result = token.build()

        expected = '303037789c5360105bb0c3272aaee9f477ff1dc217e6471ef5be75f240a24204abe59ae9e17d53bba514182ccd0d' \
                   '9c1d8d4d5352cd0c924d4ccc4c4c939212532d128d0c4d0dcc0c938c8dddbf083044303130303280300482f80a0c' \
                   'e629e646c666a6a9499616c62616a6c696e6a9c6a9c6699629266606492929895c0c46161646c6268646e6c600c2' \
                   '6a24e3'
        self.assertEqual(bytes.fromhex(expected), result)

    def test_service_rtc_uid_0(self):
        token = AccessToken(self.__app_id, self.__app_cert, issue_ts=self.__ts, expire=self.__expire)
        token._AccessToken__salt = self.__salt

        service = ServiceRtc(self.__channel_name, 0)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        token.add_service(service)
        result = token.build()

        expected = '303037789c5360b87364fd3c2f16b53e0e7bf937176ffddc677c22e15ea46e96cea20d06d9d398936d14182ccd0d9' \
                   'c1d8d4d5352cd0c924d4ccc4c4c939212532d128d0c4d0dcc0c938c8dddbf083044303130303280300482f80a0ce6' \
                   '29e646c666a6a9499616c62616a6c696e6a9c6a9c6699629266606492929890c0c00369c226a'

        self.assertEqual(bytes.fromhex(expected), result)

