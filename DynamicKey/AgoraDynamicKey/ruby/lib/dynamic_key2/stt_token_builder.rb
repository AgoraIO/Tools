module AgoraDynamicKey2
  class SttTokenBuilder
    # Build a Token007 that carries RTC, RTM, and STT services.
    #
    # app_id: The App ID issued to you by Agora.
    # app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    # channel_name: Unique channel name for the AgoraRTC session in the string format.
    # rtc_account: The RTC user's account, max length is 255 Bytes.
    # rtc_role: ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
    #     ROLE_SUBSCRIBER: An audience member in a live-broadcast profile.
    # rtc_token_expire: represented by the number of seconds elapsed since now.
    # join_channel_privilege_expire: represented by the number of seconds elapsed since now.
    # pub_audio_privilege_expire: represented by the number of seconds elapsed since now.
    # pub_video_privilege_expire: represented by the number of seconds elapsed since now.
    # pub_data_stream_privilege_expire: represented by the number of seconds elapsed since now.
    # rtm_user_id: The RTM user's account, max length is 255 Bytes.
    # rtm_token_expire: represented by the number of seconds elapsed since now.
    # return: The RTC, RTM, and STT token.
    def self.build_token(app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
                         join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
                         pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, rtc_token_expire)
      service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, rtc_account)

      service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, join_channel_privilege_expire)
      if rtc_role == AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, pub_audio_privilege_expire)
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, pub_video_privilege_expire)
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, pub_data_stream_privilege_expire)
      end
      access_token.add_service(service_rtc)

      service_rtm = AgoraDynamicKey2::ServiceRtm.new(rtm_user_id)
      service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, rtm_token_expire)
      access_token.add_service(service_rtm)

      access_token.add_service(AgoraDynamicKey2::ServiceStt.new)
      access_token.build
    end
  end
end
