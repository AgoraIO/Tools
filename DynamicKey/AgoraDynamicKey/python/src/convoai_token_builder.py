# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2026 Agora.io, Inc."

from .AccessToken2 import *
from .RtcTokenBuilder2 import Role_Publisher


class ConvoAITokenBuilder(object):
    @staticmethod
    def build_token(app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
                    join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
                    pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire):
        """Build a Token007 that carries RTC, RTM, and ConvoAI services."""
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
