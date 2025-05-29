# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2024 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtcTokenBuilder2 import *


def main():
    # Need to set environment variable AGORA_APP_ID
    app_id = os.environ.get("AGORA_APP_ID")
    # Need to set environment variable AGORA_APP_CERTIFICATE
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")

    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    uid = 2882341273
    account = "2882341273"
    token_expiration_in_seconds = 3600
    privilege_expiration_in_seconds = 3600
    join_channel_privilege_expiration_in_seconds = 3600
    pub_audio_privilege_expiration_in_seconds = 3600
    pub_video_privilege_expiration_in_seconds = 3600
    pub_data_stream_privilege_expiration_in_seconds = 3600

    print("App Id: %s" % app_id)
    print("App Certificate: %s" % app_certificate)
    if not app_id or not app_certificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return

    token = RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name, uid, Role_Publisher,
                                                 token_expiration_in_seconds, privilege_expiration_in_seconds)
    print("Token with int uid: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, account, Role_Publisher,
                                                          token_expiration_in_seconds, privilege_expiration_in_seconds)
    print("Token with user account: {}".format(token))

    token = RtcTokenBuilder.build_token_with_uid_and_privilege(
        app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with int uid and privilege: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account_and_privilege(
        app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with user account and privilege: {}".format(token))

    token = RtcTokenBuilder.build_token_with_rtm(app_id, app_certificate, channel_name, account, Role_Publisher,
                                                 token_expiration_in_seconds, privilege_expiration_in_seconds)
    print("Token with RTM: {}".format(token))

    token = RtcTokenBuilder.build_token_with_rtm2(
        app_id, app_certificate, channel_name, account, Role_Publisher, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds,
        account, token_expiration_in_seconds)
    print("Token with RTM: {}".format(token))

if __name__ == "__main__":
    main()
