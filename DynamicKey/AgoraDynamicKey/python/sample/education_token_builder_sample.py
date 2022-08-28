# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2022 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))

from src.education_token_builder import *

def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
    room_uuid = "123"
    role = 1
    user_id = "2882341273"
    expiration_in_seconds = 600

    token = EducationTokenBuilder.build_room_user_token(
        app_id, app_certificate, room_uuid, user_id, role, expiration_in_seconds)
    print("Education room user token: {}".format(token))

    token = EducationTokenBuilder.build_user_token(
        app_id, app_certificate, user_id, expiration_in_seconds)
    print("Education user token: {}".format(token))

    token = EducationTokenBuilder.build_app_token(
        app_id, app_certificate, expiration_in_seconds)
    print("Education app token: {}".format(token))


if __name__ == "__main__":
    main()
