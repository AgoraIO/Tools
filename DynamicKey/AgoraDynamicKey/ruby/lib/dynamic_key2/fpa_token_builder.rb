module AgoraDynamicKey2
  class FpaTokenBuilder
    # Build the FPA token.
    #
    # @param app_id The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    # from your kit. See Get an App ID.
    # @param app_certificate Certificate of the application that you registered in the Agora Dashboard.
    # See Get an App Certificate.
    # @return The FPA token.
    def self.build_token(app_id, app_certificate)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, 24 * 3600)

      service_fpa = AgoraDynamicKey2::ServiceFpa.new
      service_fpa.add_privilege(AgoraDynamicKey2::ServiceFpa::PRIVILEGE_LOGIN, 0)
      access_token.add_service(service_fpa)

      access_token.build
    end
  end
end
