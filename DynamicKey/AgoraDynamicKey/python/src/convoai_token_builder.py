# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

from .AccessToken2 import *
from .RtcTokenBuilder2 import Role_Publisher


class ConvoAITokenBuilder(object):
    @staticmethod
    def build_token(app_id, app_certificate, channel_name, account, token_expire=86400, privilege_expire=0):
        """Builds a ConvoAI token with RTC and RTM services.

        :param app_id: The App ID issued to you by Agora.
        :param app_certificate: Certificate of the application registered in the Agora Dashboard.
        :param channel_name: The unique channel name for the Agora RTC session in string format. The string
            length must be less than 64 bytes. The channel name may contain the following characters:
            - All lowercase English letters: a to z.
            - All uppercase English letters: A to Z.
            - All numeric characters: 0 to 9.
            - The space character.
            - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
        :param account: The account used by both RTC and RTM, max length is 255 bytes.
        :param token_expire: The whole token lifetime in seconds from now. Defaults to 86400.
        :param privilege_expire: The RTC and RTM privilege lifetime in seconds from now. Defaults to 0 and
            must not exceed token_expire; otherwise, it is limited by the token expiration time.
        :return: The ConvoAI token.
        """
        return ConvoAITokenBuilder.build_token_with_privilege(
            app_id, app_certificate, channel_name, account, Role_Publisher, token_expire,
            privilege_expire, privilege_expire, privilege_expire, privilege_expire,
            account, privilege_expire)

    @staticmethod
    def build_token_with_privilege(app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
                    join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
                    pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire):
        """
        Builds a ConvoAI token with RTC and RTM services.
        :param app_id: The App ID issued to you by Agora.
        :param app_certificate: Certificate of the application registered in the Agora Dashboard.
        :param channel_name: The unique channel name for the Agora RTC session in string format. The string
            length must be less than 64 bytes. The channel name may contain the following characters:
            - All lowercase English letters: a to z.
            - All uppercase English letters: A to Z.
            - All numeric characters: 0 to 9.
            - The space character.
            - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
        :param rtc_account: The RTC user's account, max length is 255 bytes.
        :param rtc_role: Role_Publisher for a broadcaster or Role_Subscriber for an audience member.
        :param rtc_token_expire: Represented by the number of seconds elapsed since now. For example, set it
            to 600 to access the Agora Service within 10 minutes after the token is generated. This is the
            whole token expiration.
        :param join_channel_privilege_expire: Represented by the number of seconds elapsed since now. For
            example, set it to 600 to join the channel and stay in it for 10 minutes.
        :param pub_audio_privilege_expire: Represented by the number of seconds elapsed since now. For example,
            set it to 600 to publish audio for 10 minutes.
        :param pub_video_privilege_expire: Represented by the number of seconds elapsed since now. For example,
            set it to 600 to publish video for 10 minutes.
        :param pub_data_stream_privilege_expire: Represented by the number of seconds elapsed since now. For
            example, set it to 600 to publish data streams for 10 minutes.
        :param rtm_user_id: The RTM user's account, max length is 255 bytes.
        :param rtm_token_expire: Represented by the number of seconds elapsed since now. For example, set it
            to 600 to access the Agora Service within 10 minutes after the token is generated.
        :return: The ConvoAI token.

        rtc_token_expire is the whole token expiration. The whole token is invalid after this time,
        even if a privilege expiration time is later. The RTC privilege expiration values must not
        exceed rtc_token_expire; otherwise, the privileges are limited by the token expiration time.
        rtm_token_expire must not exceed rtc_token_expire; otherwise, the RTM login privilege is
        limited by the token expiration time.
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

        token.add_service(ServiceConvoAI())

        return token.build()
