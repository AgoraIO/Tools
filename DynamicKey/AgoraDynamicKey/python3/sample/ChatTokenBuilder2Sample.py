# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.ChatTokenBuilder2 import *


def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    user_id = "2882341273"
    expiration_in_seconds = 600

    token = ChatTokenBuilder.build_user_token(app_id, app_certificate, user_id, expiration_in_seconds)
    print("Chat user token: {}".format(token))

    token = ChatTokenBuilder.build_app_token(app_id, app_certificate, expiration_in_seconds)
    print("Chat app token: {}".format(token))


if __name__ == "__main__":
    main()
