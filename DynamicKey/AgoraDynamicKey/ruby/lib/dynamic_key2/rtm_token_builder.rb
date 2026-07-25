module AgoraDynamicKey2
  class RtmTokenBuilder
    # Build the RTM token.
    #
    # @param app_id:          The App ID issued to you by Agora. Apply for a new App ID from
    #                         Agora Dashboard if it is missing from your kit. See Get an App ID.
    # @param app_certificate: Certificate of the application that you registered in
    #                         the Agora Dashboard. See Get an App Certificate.
    # @param user_id:         The user's account, max length is 64 Bytes.
    # @param expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
    #                         Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
    # @return The RTM token.
    def self.build_token(app_id, app_certificate, user_id, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
      service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_id)

      service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire)
      access_token.add_service(service_rtm)
      access_token.build
    end

    # Builds an RTM2 token with resource-level permissions.
    #
    # This special interface requires Agora assistance for proper usage.
    # @param app_id [String] The App ID issued to you by Agora.
    # @param app_certificate [String] The application certificate registered in the Agora Dashboard.
    # @param user_id [String] The user's account, max length is 64 bytes.
    # @param permissions [ServiceRtm2::Permissions] The RTM2 resource-level permissions.
    # @param expire [Integer] The number of seconds from now before the token expires.
    # @return [String] The RTM2 token.
    def self.build_token_with_permissions(app_id, app_certificate, user_id, permissions, expire = 0)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
      service_rtm2 = AgoraDynamicKey2::ServiceRtm2.new(user_id, permissions)

      service_rtm2.add_privilege(AgoraDynamicKey2::ServiceRtm2::PRIVILEGE_LOGIN, expire)
      access_token.add_service(service_rtm2)
      access_token.build
    end
  end
end
