# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken2 import *
from src.utils import *


class UnknownService(Service):
    """Represent an unsupported service type for forward compatibility tests."""

    def __init__(self, service_type=999):
        """Create a service whose type is not registered by AccessToken."""
        super(UnknownService, self).__init__(service_type)


class AccessToken2Test(unittest.TestCase):
    def setUp(self) -> None:
        """Create deterministic token fixtures shared by each test."""
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__channel_name = "7d72365eb983485397e3e3f9d460bdda"
        self.__room_uuid = "123"
        self.__role = 1
        self.__user_id = 'test_user'
        self.__uid = 2882341273
        self.__uid_str = '2882341273'
        self.__expire = 600
        self.__salt = 1
        self.__ts = 1111111

        self.__token = AccessToken(
            self.__app_id, self.__app_cert, issue_ts=self.__ts, expire=self.__expire)
        self.__token._AccessToken__salt = self.__salt

    def test_service_rtc(self):
        """Build the expected RTC token for a numeric user ID."""
        service = ServiceRtc(self.__channel_name, self.__uid)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertEqual(expected, result)

    def test_service_rtc_uid_0(self):
        """Build the expected RTC token with an empty encoded user ID."""
        service = ServiceRtc(self.__channel_name, 0)
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='
        self.assertEqual(expected, result)

    def test_service_rtc_account(self):
        """Build the expected RTC token for a string user account."""
        service = ServiceRtc(self.__channel_name, str(self.__uid))
        service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertEqual(expected, result)

    def test_service_chat_user(self):
        """Build the expected Chat token with user privileges."""
        service = ServiceChat(self.__uid_str)
        service.add_privilege(ServiceChat.kPrivilegeUser, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg='

        self.assertEqual(expected, result)

    def test_service_chat_app(self):
        """Build the expected Chat token with application privileges."""
        service = ServiceChat()
        service.add_privilege(ServiceChat.kPrivilegeApp, self.__expire)

        self.__token.add_service(service)
        result = self.__token.build()

        expected = '007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr'

        self.assertEqual(expected, result)

    def test_service_apaas_room_user(self):
        """Build the expected APaaS room-user token with RTM and Chat services."""
        chat_user_id = get_md5(self.__uid_str)
        apaas_service = ServiceApaas(
            self.__room_uuid, self.__uid_str, self.__role)
        apaas_service.add_privilege(
            ServiceApaas.kPrivilegeRoomUser, self.__expire)
        self.__token.add_service(apaas_service)

        rtm_service = ServiceRtm(self.__uid_str)
        rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, self.__expire)
        self.__token.add_service(rtm_service)

        chat_service = ServiceChat(chat_user_id)
        chat_service.add_privilege(ServiceChat.kPrivilegeUser, self.__expire)
        self.__token.add_service(chat_service)

        result = self.__token.build()

        expected = '007eJxTYOi6fYVB7qlA2ZWQ+Ko3N2IafQOddj+K4tjh3PS7P2vx4a0KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmBmYgDQjmM/FYGRhYWRsYmhkbswKF1VgMDMwMza2MDYxskg0NktLSjROSzIzMDZISk1OszCwNEllh6tlZjA0MkY2hpEBANqIKYQ='

        self.assertEqual(expected, result)

    def test_service_apaas_user(self):
        """Build the expected APaaS token with user privileges."""
        apaas_service = ServiceApaas(user_uuid=self.__uid_str)
        apaas_service.add_privilege(
            ServiceApaas.kPrivilegeUser, self.__expire)
        self.__token.add_service(apaas_service)

        result = self.__token.build()

        expected = '007eJxTYEg4e9Zj9gch+QkfFi1qM7tdkn1G3Kzt6FTJpTpzRQ4brixTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADC7EDMBOYzMHAxGFlYGBmbGBqZG///DwDuNR56'
        self.assertEqual(expected, result)

    def test_service_apaas_app(self):
        """Build the expected APaaS token with application privileges."""
        apaas_service = ServiceApaas()
        apaas_service.add_privilege(
            ServiceApaas.kPrivilegeApp, self.__expire)
        self.__token.add_service(apaas_service)

        result = self.__token.build()

        expected = '007eJxTYJgT3rumdJdoWJpC3aNTb4o76swyLsrHvmznOn/x1cQM9gcKDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGUCYHYiZwXwQ+P8fAADUHTQ='
        self.assertEqual(expected, result)

    def test_multi_service(self):
        """Build the expected token containing distinct service types."""
        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)
        rtc.add_privilege(
            ServiceRtc.kPrivilegePublishAudioStream, self.__expire)
        rtc.add_privilege(
            ServiceRtc.kPrivilegePublishVideoStream, self.__expire)
        rtc.add_privilege(
            ServiceRtc.kPrivilegePublishDataStream, self.__expire)

        rtm = ServiceRtm(self.__uid_str)
        rtm.add_privilege(ServiceRtm.kPrivilegeLogin, self.__expire)

        fpa = ServiceFpa()
        fpa.add_privilege(ServiceFpa.kPrivilegeLogin, self.__expire)

        chat = ServiceChat(self.__uid_str)
        chat.add_privilege(ServiceChat.kPrivilegeUser, self.__expire)

        apaas = ServiceApaas(user_uuid=self.__uid_str)
        apaas.add_privilege(ServiceApaas.kPrivilegeUser, self.__expire)

        self.__token.add_service(rtc)
        self.__token.add_service(rtm)
        self.__token.add_service(fpa)
        self.__token.add_service(chat)
        self.__token.add_service(apaas)

        result = self.__token.build()

        expected = '007eJxTYHh8IPKzTvBdf9ce8bk7G61vs06oca1e815/ot4+x7rfjDIKDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYWIEkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzYyagORCTkEVZ4KKsWOXZgWIQm1HF//8HAL01L5I='

        self.assertEqual(expected, result)

    def test_repeated_service_type_build_parse_and_verify(self):
        """Preserve repeated service types and their insertion order after parsing."""
        rtm = ServiceRtm(self.__uid_str)
        rtm.add_privilege(ServiceRtm.kPrivilegeLogin, self.__expire)
        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)
        stream_rtc = ServiceRtc('stream-channel', 'stream-user')
        stream_rtc.add_privilege(
            ServiceRtc.kPrivilegePublishDataStream, self.__expire + 100)

        self.__token.add_service(rtm)
        self.__token.add_service(rtc)
        self.__token.add_service(stream_rtc)

        token = self.__token.build()
        self.assertEqual([rtm, rtc, stream_rtc], self.__token.services)
        self.assertEqual(2, len(self.__token.get_services(ServiceRtc.kServiceType)))

        parser = AccessToken()
        self.assertTrue(parser.from_string(token))
        rtc_services = parser.get_services(ServiceRtc.kServiceType)

        self.assertEqual(2, len(rtc_services))
        self.assertEqual(
            self.__channel_name.encode('utf-8'),
            rtc_services[0]._ServiceRtc__channel_name)
        self.assertEqual(
            'stream-channel'.encode('utf-8'),
            rtc_services[1]._ServiceRtc__channel_name)
        self.assertEqual(1, len(parser.get_services(ServiceRtm.kServiceType)))
        self.assertEqual([], parser.get_services(ServiceChat.kServiceType))
        self.assertTrue(parser.verify_signature(self.__app_cert))
        self.assertFalse(parser.verify_signature('a' * 32))

    def test_parse_extended_services_from_cpp(self):
        """Parse and verify C++ Streaming, FCDN, and RTM2 services."""
        token = '007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ=='
        parser = AccessToken()

        self.assertTrue(parser.from_string(token))
        self.assertTrue(parser.verify_signature(self.__app_cert))

        streaming = parser.get_services(ServiceStreaming.kServiceType)[0]
        self.assertEqual(self.__channel_name.encode('utf-8'), streaming._ServiceStreaming__channel_name)
        self.assertEqual(self.__uid_str.encode('utf-8'), streaming._ServiceStreaming__account)
        self.assertEqual(self.__expire, streaming._Service__privileges[ServiceStreaming.kPrivilegePublishMixStream])
        self.assertEqual(self.__expire, streaming._Service__privileges[ServiceStreaming.kPrivilegePublishRawStream])

        fcdn = parser.get_services(ServiceFCdn.kServiceType)[0]
        self.assertEqual(self.__channel_name.encode('utf-8'), fcdn._ServiceFCdn__channel_name)
        self.assertEqual(self.__uid_str.encode('utf-8'), fcdn._ServiceFCdn__account)
        self.assertEqual(self.__expire, fcdn._Service__privileges[ServiceFCdn.kPrivilegePublish])
        self.assertEqual(self.__expire, fcdn._Service__privileges[ServiceFCdn.kPrivilegePlay])

        rtm2 = parser.get_services(ServiceRtm2.kServiceType)[0]
        self.assertEqual(self.__user_id, rtm2.get_user_id())
        self.assertEqual(
            {0: {0: ['message-a', 'message-b']}, 1: {1: ['stream-a']}, 4: {0: ['user-a']}},
            rtm2.get_permissions().details)

    def test_extended_service_numeric_uid_conversion(self):
        """Verify deterministic Streaming and FCDN generation and UID conversion against C++."""
        streaming_uid = ServiceStreaming(self.__channel_name, self.__uid)
        streaming_uid.add_privilege(ServiceStreaming.kPrivilegePublishMixStream, self.__expire)
        self.__token.add_service(streaming_uid)
        streaming_wildcard = ServiceStreaming(self.__channel_name, 0)
        streaming_wildcard.add_privilege(ServiceStreaming.kPrivilegePublishRawStream, self.__expire)
        self.__token.add_service(streaming_wildcard)
        streaming_account = ServiceStreaming(self.__channel_name, 'stream-account')
        streaming_account.add_privilege(ServiceStreaming.kPrivilegePublishMixStream, self.__expire)
        streaming_account.add_privilege(ServiceStreaming.kPrivilegePublishRawStream, self.__expire)
        self.__token.add_service(streaming_account)
        fcdn_uid = ServiceFCdn(self.__channel_name, self.__uid)
        fcdn_uid.add_privilege(ServiceFCdn.kPrivilegePublish, self.__expire)
        self.__token.add_service(fcdn_uid)
        fcdn_wildcard = ServiceFCdn(self.__channel_name, 0)
        fcdn_wildcard.add_privilege(ServiceFCdn.kPrivilegePlay, self.__expire)
        self.__token.add_service(fcdn_wildcard)
        fcdn_account = ServiceFCdn(self.__channel_name, 'fcdn-account')
        fcdn_account.add_privilege(ServiceFCdn.kPrivilegePublish, self.__expire)
        fcdn_account.add_privilege(ServiceFCdn.kPrivilegePlay, self.__expire)
        self.__token.add_service(fcdn_account)

        token = self.__token.build()
        self.assertEqual(
            '007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X',
            token)
        parser = AccessToken()
        self.assertTrue(parser.from_string(token))
        streaming = parser.get_services(ServiceStreaming.kServiceType)
        self.assertEqual(
            [self.__uid_str, '', 'stream-account'],
            [service._ServiceStreaming__account.decode('utf-8') for service in streaming])
        fcdn = parser.get_services(ServiceFCdn.kServiceType)
        self.assertEqual(
            [self.__uid_str, '', 'fcdn-account'],
            [service._ServiceFCdn__account.decode('utf-8') for service in fcdn])
    def test_parse_unknown_service_type(self):
        """Keep known services parsed before an unknown service type."""
        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)
        unknown = UnknownService()
        unknown.add_privilege(1, self.__expire)

        self.__token.add_service(rtc)
        self.__token.add_service(unknown)
        token = self.__token.build()

        parser = AccessToken()
        self.assertTrue(parser.from_string(token))
        self.assertEqual(1, len(parser.get_services(ServiceRtc.kServiceType)))
        self.assertEqual([], parser.get_services(999))
        self.assertTrue(parser.verify_signature(self.__app_cert))

    def test_parse_stops_at_unknown_service_type(self):
        """Stop before known services that follow an unknown service payload."""
        unknown = UnknownService(0)
        unknown.add_privilege(1, self.__expire)
        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)

        self.__token.add_service(rtc)
        self.__token.add_service(unknown)

        parser = AccessToken()
        self.assertTrue(parser.from_string(self.__token.build()))
        self.assertEqual([], parser.get_services(ServiceRtc.kServiceType))
        self.assertTrue(parser.verify_signature(self.__app_cert))

    def test_parse_old_token_and_clear_previous_services(self):
        """Parse an old token and replace services from an earlier parse."""
        rtm = ServiceRtm(self.__uid_str)
        rtm.add_privilege(ServiceRtm.kPrivilegeLogin, self.__expire)
        self.__token.add_service(rtm)

        parser = AccessToken()
        self.assertTrue(parser.from_string(self.__token.build()))
        self.assertEqual(1, len(parser.get_services(ServiceRtm.kServiceType)))

        old_token = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
        self.assertTrue(parser.from_string(old_token))

        self.assertEqual(1, len(parser.services))
        self.assertEqual(1, len(parser.get_services(ServiceRtc.kServiceType)))
        self.assertEqual([], parser.get_services(ServiceRtm.kServiceType))
        self.assertTrue(parser.verify_signature(self.__app_cert))

    def test_verify_signature_preconditions(self):
        """Reject signature verification before parsing or with invalid certificates."""
        parser = AccessToken()

        self.assertFalse(parser.verify_signature(self.__app_cert))

        rtc = ServiceRtc(self.__channel_name, self.__uid)
        rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, self.__expire)
        self.__token.add_service(rtc)
        self.assertTrue(parser.from_string(self.__token.build()))

        self.assertFalse(parser.verify_signature('invalid'))
        self.assertFalse(parser.verify_signature('z' * 32))
        self.assertTrue(parser.verify_signature(self.__app_cert))

        self.assertFalse(parser.from_string('006invalid'))
        self.assertFalse(parser.verify_signature(self.__app_cert))
        self.assertEqual([], parser.services)

    def test_invalid_build_and_parse_inputs(self):
        """Reject invalid identifiers, empty services, versions, and payloads."""
        self.assertEqual('', self.__token.build())

        service = ServiceRtc(self.__channel_name, self.__uid)
        invalid_length = AccessToken('invalid', self.__app_cert)
        invalid_length.add_service(service)
        self.assertEqual('', invalid_length.build())

        invalid_hex = AccessToken('z' * 32, self.__app_cert)
        invalid_hex.add_service(service)
        self.assertEqual('', invalid_hex.build())

        invalid_certificate = AccessToken(self.__app_id, 'invalid')
        invalid_certificate.add_service(service)
        self.assertEqual('', invalid_certificate.build())

        parser = AccessToken()
        self.assertFalse(parser.from_string('006invalid'))
        with self.assertRaises(ValueError):
            parser.from_string('007invalid')
