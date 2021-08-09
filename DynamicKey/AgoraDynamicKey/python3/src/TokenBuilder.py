import os
import sys
from AccessToken import *
import json



class TokenBuilder:
    @staticmethod
    def build_token_for_scene(app_id, app_cert, scene_name, user_id, role, expired_ts):
        url_userid = "u={0}".format(user_id)
        return build_token_with_account(app_id, app_cert, scene_name, url_userid, role, expired_ts)

    @staticmethod
    def build_token_for_account(app_id, app_cert, scene_name, stream_id, user_id, role, expired_ts):
        url_userid = "v=1&u={0}&s={1}".format(user_id, stream_id)
        return build_token_with_account(app_id, app_cert, scene_name, url_userid, role, expired_ts)

    @staticmethod
    def build_token_for_compatible(app_id, app_cert, channel_name, userid, role, expired_ts):
        return build_token_with_account(app_id, app_cert, channel_name, userid, role, expired_ts)



