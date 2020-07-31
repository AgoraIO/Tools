module AgoraDynamicKey2
  class RtcTokenBuilder
    ROLE_PUBLISHER = 1
    ROLE_SUBSCRIBER = 2

    # Build the RTC token with uid.
    #
    # :param app_id:          The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    #                         from your kit. See Get an App ID.
    # :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    #                         See Get an App Certificate.
    # :param channel_name:    Unique channel name for the AgoraRTC session in the string format.
    # :param uid:             User ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1).
    #                         optionalUid must be unique.
    # :param role:            ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
    #                         ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
    # :param expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
    #                         Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
    # :return:                The RTC token.
    def self.build_token_with_uid(app_id, app_certificate, channel_name, uid, role, expire)
      build_token_with_account(app_id, app_certificate, channel_name, uid, role, expire)
    end

    # Build the RTC token with uid.
    #
    # :param app_id:          The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    #                         from your kit. See Get an App ID.
    # :param app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    #                         See Get an App Certificate.
    # :param channel_name:    Unique channel name for the AgoraRTC session in the string format.
    # :param uid:             User ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1).
    #                         optionalUid must be unique.
    # :param role:            ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
    #                         ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
    # :param expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
    #                         Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
    # :return:                The RTC token.
    def self.build_token_with_account(app_id, app_certificate, channel_name, account, role, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
      service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, account)

      service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
      if role == ROLE_PUBLISHER
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, expire)
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, expire)
        service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, expire)
      end
      access_token.add_service(service_rtc)
      access_token.build
    end
  end
end
