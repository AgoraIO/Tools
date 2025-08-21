# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


from .AccessToken2 import *


class RtmTokenBuilder:
    @staticmethod
    def build_token(app_id, app_certificate, user_id, expire):
        """
        Build the RTM token.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param user_id: The user's account, max length is 64 Bytes.
        :param expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
            Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
        :return: The RTC token.
        """
        token = AccessToken(app_id, app_certificate, expire=expire)

        rtm_service = ServiceRtm(user_id)
        rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, expire)

        token.add_service(rtm_service)

        return token.build()

    @staticmethod
    def build_token_with_permissions(app_id, app_certificate, user_id, permissions, expire=0):
        """
        Build the RTM token using ServiceRtm2 with specific permissions.
        :param app_id: The App ID issued to you by Agora.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
        :param user_id: The user's account, max length is 64 Bytes.
        :param permissions: ServiceRtm2.Permissions object specifying the permissions
        :param expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
            Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
        :return: The RTM token.
        """
        token = AccessToken(app_id, app_certificate, expire=expire)

        rtm_service = ServiceRtm2(user_id, permissions)
        rtm_service.add_privilege(ServiceRtm2.kPrivilegeLogin, expire)

        token.add_service(rtm_service)

        return token.build()
