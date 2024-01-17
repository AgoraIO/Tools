# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2024 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))

from src.education_token_builder import EducationTokenBuilder


def main():
    # Need to set environment variable AGORA_APP_ID
    app_id = os.environ.get("AGORA_APP_ID")
    # Need to set environment variable AGORA_APP_CERTIFICATE
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")

    room_uuid = "123"
    role = 1
    user_id = "2882341273"
    expiration_in_seconds = 600

    print("App Id: %s" % app_id)
    print("App Certificate: %s" % app_certificate)
    if not app_id or not app_certificate:
        print("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return
    
    token = EducationTokenBuilder.build_room_user_token(app_id, app_certificate, room_uuid, user_id, role, expiration_in_seconds)
    print("Education room user token: {}".format(token))

    token = EducationTokenBuilder.build_user_token(app_id, app_certificate, user_id, expiration_in_seconds)
    print("Education user token: {}".format(token))

    token = EducationTokenBuilder.build_app_token(app_id, app_certificate, expiration_in_seconds)
    print("Education app token: {}".format(token))


if __name__ == "__main__":
    main()
