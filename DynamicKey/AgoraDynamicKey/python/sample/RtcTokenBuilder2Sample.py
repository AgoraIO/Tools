# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtcTokenBuilder2 import *


def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    uid = 2882341273
    account = "2882341273"
    token_expiration_in_seconds = 3600
    privilege_expiration_in_seconds = 3600
    join_channel_privilege_expiration_in_seconds = 3600
    pub_audio_privilege_expiration_in_seconds = 3600
    pub_video_privilege_expiration_in_seconds = 3600
    pub_data_stream_privilege_expiration_in_seconds = 3600

    token = RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name, uid, Role_Subscriber,
                                                 token_expiration_in_seconds, privilege_expiration_in_seconds)
    print("Token with int uid: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, account,
                                                          Role_Subscriber, token_expiration_in_seconds,
                                                          privilege_expiration_in_seconds)
    print("Token with user account: {}".format(token))

    token = RtcTokenBuilder.build_token_with_uid_and_privilege(
        app_id, app_certificate, channel_name, uid, token_expiration_in_seconds, 
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with int uid and privilege: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account_and_privilege(
        app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with user account and privilege: {}".format(token))


if __name__ == "__main__":
    main()
