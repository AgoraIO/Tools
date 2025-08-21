# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import sys
import unittest
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtmTokenBuilder2 import *


class RtmTokenBuilder2Test(unittest.TestCase):
    def setUp(self):
        self.__app_id = "970CA35de60c44645bbae8a215061b33"
        self.__app_cert = "5CFd2fd1755d40ecb72977518be15d3b"
        self.__user_id = "test_user"
        self.__expire = 600

    def test_token(self):
        token = RtmTokenBuilder.build_token(self.__app_id, self.__app_cert, self.__user_id, self.__expire)
        parser = AccessToken()
        parser.from_string(token)

        self.assertEqual(parser._AccessToken__app_id, self.__app_id.encode('utf-8'))
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        self.assertIn(ServiceRtm.kServiceType, parser._AccessToken__service)

        parser_service = parser._AccessToken__service[ServiceRtm.kServiceType]

        self.assertEqual(parser_service._ServiceRtm__user_id, self.__user_id.encode('utf-8'))
        self.assertIn(ServiceRtm.kPrivilegeLogin, parser_service._Service__privileges)
        self.assertEqual(parser_service._Service__privileges[ServiceRtm.kPrivilegeLogin], self.__expire)

    def test_token_with_permissions(self):
        """Test building token with ServiceRtm2 and permissions"""
        permissions = ServiceRtm2.Permissions()
        permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                       ServiceRtm2.Permissions.kRead, ["channelA", "channelB"])
        permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                       ServiceRtm2.Permissions.kWrite, ["channelC"])
        
        token = RtmTokenBuilder.build_token_with_permissions(
            self.__app_id, self.__app_cert, self.__user_id, permissions, self.__expire
        )
        self.assertIsNotNone(token)
        self.assertTrue(len(token) > 0)
        self.assertTrue(token.startswith('007'))

    def test_token_parsing_with_permissions(self):
        """Test parsing a token with permissions"""
        permissions = ServiceRtm2.Permissions()
        read_channels = ["channelA", "channelB"]
        write_channels = ["channelC", "channelD"]
        
        permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                       ServiceRtm2.Permissions.kRead, read_channels)
        permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                       ServiceRtm2.Permissions.kWrite, write_channels)
        
        token = RtmTokenBuilder.build_token_with_permissions(
            self.__app_id, self.__app_cert, self.__user_id, permissions, self.__expire
        )
        
        # Parse the token
        parser = AccessToken()
        result = parser.from_string(token)
        self.assertTrue(result)
        
        # Verify parsed data
        self.assertEqual(parser._AccessToken__app_id.decode('utf-8'), self.__app_id)
        self.assertEqual(parser._AccessToken__expire, self.__expire)
        
        # Verify ServiceRtm2 data
        rtm2_service = parser._AccessToken__service[ServiceRtm2.kServiceType]
        self.assertEqual(rtm2_service.get_user_id(), self.__user_id)
        
        # Verify permissions
        permissions_obj = rtm2_service.get_permissions()
        self.assertIn(ServiceRtm2.Permissions.kMessageChannels, permissions_obj.details)
        
        message_channels = permissions_obj.details[ServiceRtm2.Permissions.kMessageChannels]
        self.assertEqual(message_channels[ServiceRtm2.Permissions.kRead], read_channels)
        self.assertEqual(message_channels[ServiceRtm2.Permissions.kWrite], write_channels)

    def test_permissions_class(self):
        """Test ServiceRtm2.Permissions class"""
        permissions = ServiceRtm2.Permissions()
        
        # Test adding permissions
        permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                       ServiceRtm2.Permissions.kRead, ["channel1"])
        permissions.add(ServiceRtm2.Permissions.kStreamChannels,
                       ServiceRtm2.Permissions.kWrite, ["stream1", "stream2"])
        
        # Verify structure
        self.assertIn(ServiceRtm2.Permissions.kMessageChannels, permissions.details)
        self.assertIn(ServiceRtm2.Permissions.kStreamChannels, permissions.details)
        
        self.assertEqual(
            permissions.details[ServiceRtm2.Permissions.kMessageChannels][ServiceRtm2.Permissions.kRead],
            ["channel1"]
        )
        self.assertEqual(
            permissions.details[ServiceRtm2.Permissions.kStreamChannels][ServiceRtm2.Permissions.kWrite],
            ["stream1", "stream2"]
        )
