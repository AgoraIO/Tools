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

        expected = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcw' \
                   'Mk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertEqual(expected, result)

    def test_service_rtc_uid_0(self):
        token = AccessToken(self.__app_id, self.__app_cert, issue_ts=self.__ts, expire=self.__expire)
        token._AccessToken__salt = self.__salt

        service = ServiceRtc(self.__channel_name, 0)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        token.add_service(service)
        result = token.build()

        expected = '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcw' \
                   'Mk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='
        self.assertEqual(expected, result)

