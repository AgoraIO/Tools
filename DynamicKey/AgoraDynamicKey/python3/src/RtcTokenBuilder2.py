# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."


from .AccessToken2 import *


Role_Publisher = 1  # for live broadcaster
Role_Subscriber = 2  # default, for live audience


class RtcTokenBuilder:
    @staticmethod
    def build_token_with_uid(app_id, app_certificate, channel_name, uid, role, expire):
        """
        Build the RTC token with uid.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param channel_name: Unique channel name for the AgoraRTC session in the string format.
        :param uid: User ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1).
            optionalUid must be unique.
        :param role:
            Role_Publisher: A broadcaster/host in a live-broadcast profile.
            Role_Subscriber: An audience(default) in a live-broadcast profile.
        :param expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
            Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
        :return: The RTC token.
        """
        return RtcTokenBuilder.build_token_with_account(app_id, app_certificate, channel_name, uid, role, expire)

    @staticmethod
    def build_token_with_account(app_id, app_certificate, channel_name, account, role, expire):
        """
        Build the RTC token with account.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param channel_name: Unique channel name for the AgoraRTC session in the string format.
        :param account: The user's account, max length is 255 Bytes.
        :param role:
            Role_Publisher: A broadcaster/host in a live-broadcast profile.
            Role_Subscriber: An audience(default) in a live-broadcast profile.
        :param expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
            Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
        :return: The RTC token.
        """
        token = AccessToken(app_id, app_certificate, expire=expire)

        rtc_service = ServiceRtc(channel_name, account)
        rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
        if role == Role_Publisher:
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)

        token.add_service(rtc_service)
        return token.build()
