# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


import flask

from src.RtcTokenBuilder2 import *


bp = flask.Blueprint('token_app', __name__)


@bp.route('/v1/token', methods=('GET',))
def token():
    app = flask.current_app
    req = flask.request
    app.logger.info('recv gen-token req from {}'.format(req.remote_addr))

    query_info = req.args
    if 'channel_name' not in query_info:
        flask.abort(400)

    app_id = flask.current_app.config['APP_ID']
    app_certificate = flask.current_app.config['APP_CERTIFICATE']
    uid = 0
    channel_name = query_info['channel_name']
    expiration_in_seconds = 60 * 15

    access_token2 = ''
    try:
        access_token2 = RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name,
                                                             uid, Role_Subscriber, expiration_in_seconds)
    except Exception as e:
        app.logger.info(repr(e))
        flask.abort(500)
    app.logger.info('token {}'.format(access_token2))
    return access_token2

