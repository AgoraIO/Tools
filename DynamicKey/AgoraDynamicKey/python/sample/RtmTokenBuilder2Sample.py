# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2024 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtmTokenBuilder2 import *


def main():
    # Need to set environment variable AGORA_APP_ID
    app_id = os.environ.get("AGORA_APP_ID")
    # Need to set environment variable AGORA_APP_CERTIFICATE
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")

    user_id = "test_user_id"
    expiration_in_seconds = 3600

    print("App Id: %s" % app_id)
    print("App Certificate: %s" % app_certificate)
    if not app_id or not app_certificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return
    
    # Build RTM token using ServiceRtm (legacy)
    token = RtmTokenBuilder.build_token(app_id, app_certificate, user_id, expiration_in_seconds)
    print("RTM Token: {}".format(token))
    
    # Build RTM token with permissions using ServiceRtm2
    permissions = ServiceRtm2.Permissions()
    message_channel_reads = ["channelA", "channelB"]
    message_channel_writes = ["channelA*", "channelC"]
    
    permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                   ServiceRtm2.Permissions.kRead, message_channel_reads)
    permissions.add(ServiceRtm2.Permissions.kMessageChannels,
                   ServiceRtm2.Permissions.kWrite, message_channel_writes)
    
    token_with_permissions = RtmTokenBuilder.build_token_with_permissions(
        app_id, app_certificate, user_id, permissions, expiration_in_seconds)
    print("RTM Token with permissions:\n{}".format(token_with_permissions))


if __name__ == "__main__":
    main()
