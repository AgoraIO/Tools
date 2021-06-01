# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtmTokenBuilder2 import *


def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"
    user_id = "test_user_id"
    expiration_in_seconds = 3600

    token = RtmTokenBuilder.build_token(app_id, app_certificate, user_id, expiration_in_seconds)
    print("Rtm Token: {}".format(token))


if __name__ == "__main__":
    main()
