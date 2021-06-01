# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import flask
import logging
import token_service


app = flask.Flask(__name__)
app.logger.setLevel(logging.INFO)
app.config.from_object('setting.BaseConfig')
app.register_blueprint(token_service.bp)


if __name__ == '__main__':
    app.run()
