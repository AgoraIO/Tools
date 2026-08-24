# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

from .AccessToken2 import *
from .RtcTokenBuilder2 import Role_Publisher


class ConvoAITokenBuilder:
    @staticmethod
    def build_token(
            app_id,
            app_certificate,
            channel_name,
            rtc_account,
            rtc_role,
            rtc_token_expire,
            join_channel_privilege_expire,
            pub_audio_privilege_expire,
            pub_video_privilege_expire,
            pub_data_stream_privilege_expire,
            rtm_user_id,
            rtm_token_expire):
        """
        Build a Token007 that carries RTC, RTM, and ConvoAI services.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param channel_name: Unique channel name for the AgoraRTC session in the string format.
        :param rtc_account: The RTC user's account, max length is 255 Bytes.
        :param rtc_role: Role_Publisher: A broadcaster or host in a live-broadcast profile.
            Role_Subscriber: An audience member in a live-broadcast profile.
        :param rtc_token_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to access the Agora Service within 10 minutes after the token is generated,
            set rtc_token_expire as 600(seconds). This is the whole token expiration. The whole token is
            invalid after this time, even if a privilege expiration time is later.
        :param join_channel_privilege_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to join the channel and stay in it for 10 minutes,
            set join_channel_privilege_expire as 600(seconds). This value must not exceed the token expiration
            value; otherwise, the privilege is limited by the token expiration time.
        :param pub_audio_privilege_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to enable audio publishing for 10 minutes,
            set pub_audio_privilege_expire as 600(seconds). This value must not exceed the token expiration
            value; otherwise, the privilege is limited by the token expiration time.
        :param pub_video_privilege_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to enable video publishing for 10 minutes,
            set pub_video_privilege_expire as 600(seconds). This value must not exceed the token expiration
            value; otherwise, the privilege is limited by the token expiration time.
        :param pub_data_stream_privilege_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to enable data stream publishing for 10 minutes,
            set pub_data_stream_privilege_expire as 600(seconds). This value must not exceed the token
            expiration value; otherwise, the privilege is limited by the token expiration time.
        :param rtm_user_id: The RTM user's account, max length is 255 Bytes.
        :param rtm_token_expire: Represented by the number of seconds elapsed since now.
            If, for example, you want to access the Agora Service within 10 minutes after the token is generated,
            set rtm_token_expire as 600(seconds). This value must not exceed the RTC token expiration value;
            otherwise, the RTM login privilege is limited by the token expiration time.
        :return: The RTC, RTM, and ConvoAI token.
        """
        token = AccessToken(app_id, app_certificate, expire=rtc_token_expire)

        rtc_service = ServiceRtc(channel_name, rtc_account)
        rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, join_channel_privilege_expire)
        if rtc_role == Role_Publisher:
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pub_audio_privilege_expire)
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pub_video_privilege_expire)
            rtc_service.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pub_data_stream_privilege_expire)
        token.add_service(rtc_service)

        rtm_service = ServiceRtm(rtm_user_id)
        rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, rtm_token_expire)
        token.add_service(rtm_service)

        convoai_service = ServiceConvoAI()
        token.add_service(convoai_service)

        return token.build()
