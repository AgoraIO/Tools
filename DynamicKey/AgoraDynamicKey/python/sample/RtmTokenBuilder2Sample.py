# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

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

    token = RtmTokenBuilder.build_token(app_id, app_certificate, user_id, expiration_in_seconds)
    print("Rtm Token: {}".format(token))


if __name__ == "__main__":
    main()
