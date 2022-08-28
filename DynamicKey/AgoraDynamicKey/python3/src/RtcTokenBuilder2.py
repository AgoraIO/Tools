# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

from .AccessToken2 import *

Role_Publisher = 1  # for live broadcaster
Role_Subscriber = 2  # default, for live audience


class RtcTokenBuilder:
    @staticmethod
    def build_token_with_uid(app_id, app_certificate, channel_name, uid, role, token_expire, privilege_expire=0):
        """
        Build the RTC token with uid.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param channel_name: Unique channel name for the AgoraRTC session in the string format.
        :param uid: User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
            optionalUid must be unique.
        :param role: Role_Publisher: A broadcaster/host in a live-broadcast profile.
            Role_Subscriber: An audience(default) in a live-broadcast profile.
        :param token_expire: represented by the number of seconds elapsed since now. If, for example,
            you want to access the Agora Service within 10 minutes after the token is generated,
            set token_expire as 600(seconds).
        :param privilege_expire: represented by the number of seconds elapsed since now. If, for example,
            you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
        :return: The RTC token.
        """
        return RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, uid, role,
                                                             token_expire, privilege_expire)

    @staticmethod
    def build_token_with_user_account(app_id, app_certificate, channel_name, account, role, token_expire,
                                      privilege_expire=0):
        """
        Build the RTC token with account.
        :param app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
            from your kit. See Get an App ID.
        :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
            See Get an App Certificate.
        :param channel_name: Unique channel name for the AgoraRTC session in the string format.
        :param account: The user's account, max length is 255 Bytes.
        :param role: Role_Publisher: A broadcaster/host in a live-broadcast profile.
            Role_Subscriber: An audience(default) in a live-broadcast profile.
        :param token_expire: represented by the number of seconds elapsed since now. If, for example,
            you want to access the Agora Service within 10 minutes after the token is generated,
            set token_expire as 600(seconds).
        :param privilege_expire: represented by the number of seconds elapsed since now. If, for example,
            you want to enable your privilege for 10 minutes, set privilege_expire as 600(seconds).
        :return: The RTC token.
        """
        token = AccessToken(app_id, app_certificate, expire=token_expire)

        service_rtc = ServiceRtc(channel_name, account)
        service_rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, privilege_expire)
        if role == Role_Publisher:
            service_rtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, privilege_expire)
            service_rtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, privilege_expire)
            service_rtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, privilege_expire)
        token.add_service(service_rtc)

        return token.build()

    @staticmethod
    def build_token_with_uid_and_privilege(app_id, app_certificate, channel_name, uid, token_expire,
                                           join_channel_privilege_expire, pub_audio_privilege_expire,
                                           pub_video_privilege_expire, pub_data_stream_privilege_expire):
        """
        Generates an RTC token with the specified privilege.
                This method supports generating a token with the following privileges:
        - Joining an RTC channel.
        - Publishing audio in an RTC channel.
        - Publishing video in an RTC channel.
        - Publishing data streams in an RTC channel.
                The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
        enabled co-host authentication.
                A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
        The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
        or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
        the respective timestamp for each privilege in your app logic. After receiving the callback, you need
        to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
        the channel.
                @note
        Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
        Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
        When the token for joining the channel expires, the user is immediately kicked off the RTC channel
        and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
                :param app_id The App ID of your Agora project.
        :param app_certificate: The App Certificate of your Agora project.
        :param channel_name: The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
        - All lowercase English letters: a to z.
        - All uppercase English letters: A to Z.
        - All numeric characters: 0 to 9.
        - The space character.
        - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
        :param uid: The user ID. A 32-bit unsigned integer with a value range from 1 to (2^32 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
        :param token_expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
        Agora Service within 10 minutes after the token is generated, set token_expire as 600(seconds).
        :param join_channel_privilege_expire: The Unix timestamp when the privilege for joining the channel expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set join_channel_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes.
        :param pub_audio_privilege_expire: The Unix timestamp when the privilege for publishing audio expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_audio_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_audio_privilege_expire as the current Unix timestamp.
        :param pub_video_privilege_expire: The Unix timestamp when the privilege for publishing video expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_video_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_video_privilege_expire as the current Unix timestamp.
        :param pub_data_stream_privilege_expire: The Unix timestamp when the privilege for publishing data streams expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_data_stream_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_data_stream_privilege_expire as the current Unix timestamp.
        :return: The new Token
        """
        return RtcTokenBuilder.build_token_with_user_account_and_privilege(
            app_id, app_certificate, channel_name, uid, token_expire, join_channel_privilege_expire,
            pub_audio_privilege_expire, pub_video_privilege_expire, pub_data_stream_privilege_expire)

    @staticmethod
    def build_token_with_user_account_and_privilege(app_id, app_certificate, channel_name, account, token_expire,
                                                    join_channel_privilege_expire, pub_audio_privilege_expire,
                                                    pub_video_privilege_expire, pub_data_stream_privilege_expire):
        """
        Generates an RTC token with the specified privilege.

        This method supports generating a token with the following privileges:
        - Joining an RTC channel.
        - Publishing audio in an RTC channel.
        - Publishing video in an RTC channel.
        - Publishing data streams in an RTC channel.

        The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
        enabled co-host authentication.

        A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
        The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
        or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
        the respective timestamp for each privilege in your app logic. After receiving the callback, you need
        to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
        the channel.

        @note
        Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
        Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
        When the token for joining the channel expires, the user is immediately kicked off the RTC channel
        and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.

        :param app_id: The App ID of your Agora project.
        :param app_certificate: The App Certificate of your Agora project.
        :param channel_name: The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
        - All lowercase English letters: a to z.
        - All uppercase English letters: A to Z.
        - All numeric characters: 0 to 9.
        - The space character.
        - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
        :param account: The user account.
        :param token_expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
        Agora Service within 10 minutes after the token is generated, set token_expire as 600(seconds).
        :param join_channel_privilege_expire: The Unix timestamp when the privilege for joining the channel expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set join_channel_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes.
        :param pub_audio_privilege_expire: The Unix timestamp when the privilege for publishing audio expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_audio_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_audio_privilege_expire as the current Unix timestamp.
        :param pub_video_privilege_expire: The Unix timestamp when the privilege for publishing video expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_video_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_video_privilege_expire as the current Unix timestamp.
        :param pub_data_stream_privilege_expire: The Unix timestamp when the privilege for publishing data streams expires, represented
        by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_data_stream_privilege_expire as the
        current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
        set pub_data_stream_privilege_expire as the current Unix timestamp.
        :return: The new Token
        """
        token = AccessToken(app_id, app_certificate, expire=token_expire)

        service_rtc = ServiceRtc(channel_name, account)
        service_rtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, join_channel_privilege_expire)
        service_rtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pub_audio_privilege_expire)
        service_rtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pub_video_privilege_expire)
        service_rtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pub_data_stream_privilege_expire)
        token.add_service(service_rtc)

        return token.build()
