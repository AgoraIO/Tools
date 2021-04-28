# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.AccessToken2 import *


def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    uid = 2882341273
    account = "2882341273"
    chat_user_id = "2882341273"
    expiration_in_seconds = 3600

    rtc_service = ServiceRtc(channel_name, uid)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expiration_in_seconds)

    rtm_service = ServiceRtm(account)
    rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, expiration_in_seconds)

    chat_service = ServiceChat(chat_user_id)
    chat_service.add_privilege(ServiceChat.kPrivilegeUser, expiration_in_seconds)

    token = AccessToken(app_id=app_id, app_certificate=app_certificate, expire=expiration_in_seconds)
    token.add_service(rtc_service)
    token.add_service(rtm_service)
    token.add_service(chat_service)

    print("Token for RTC, RTM and CHAT: {}".format(token.build()))


if __name__ == "__main__":
    main()
