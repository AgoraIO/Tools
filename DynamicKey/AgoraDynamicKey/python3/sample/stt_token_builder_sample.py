# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.stt_token_builder import SttTokenBuilder
from src.RtcTokenBuilder2 import Role_Publisher


def main():
    """Read credentials from environment variables and build an STT token."""
    app_id = os.environ.get("AGORA_APP_ID")
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")
    channel_name = "stt-channel"
    rtc_account = "stt-rtc-user"
    rtc_role = Role_Publisher
    rtc_token_expire = 3600
    join_channel_privilege_expire = 3600
    pub_audio_privilege_expire = 3600
    pub_video_privilege_expire = 3600
    pub_data_stream_privilege_expire = 3600
    rtm_user_id = "stt-rtm-user"
    rtm_token_expire = 3600

    print("App Id: %s" % app_id)
    if not app_id or not app_certificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return

    token = SttTokenBuilder.build_token(
        app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
        join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
        pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire)
    print("STT token: {}".format(token))


if __name__ == "__main__":
    main()
