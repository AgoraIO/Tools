# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import os
import sys

sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))

from src.fpa_token_builder import *


def main():
    app_id = "970CA35de60c44645bbae8a215061b33"
    app_certificate = "5CFd2fd1755d40ecb72977518be15d3b"

    token = FpaTokenBuilder.build_token(app_id, app_certificate)
    print("Token with FPA service: {}".format(token))


if __name__ == "__main__":
    main()
