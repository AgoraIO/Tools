# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.convoai_token_builder import ConvoAITokenBuilder
from src.RtcTokenBuilder2 import Role_Publisher


def main():
    app_id = os.environ.get("AGORA_APP_ID")
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")
    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    rtc_account = "2882341273"
    rtc_role = Role_Publisher
    rtc_token_expire = 3600
    join_channel_privilege_expire = 3600
    pub_audio_privilege_expire = 3600
    pub_video_privilege_expire = 3600
    pub_data_stream_privilege_expire = 3600
    rtm_user_id = "2882341273"
    rtm_token_expire = 3600

    print("App Id: %s" % app_id)
    if not app_id or not app_certificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return

    token = ConvoAITokenBuilder.build_token(
        app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
        join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
        pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire)
    print("ConvoAI token: {}".format(token))


if __name__ == "__main__":
    main()
