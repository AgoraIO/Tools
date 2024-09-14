module AgoraDynamicKey2
  class ChatTokenBuilder
    # Build the Chat user token.
    #
    # @param app_id:          The App ID issued to you by Agora. Apply for a new App ID from
    #                         Agora Dashboard if it is missing from your kit. See Get an App ID.
    # @param app_certificate: Certificate of the application that you registered in
    #                         the Agora Dashboard. See Get an App Certificate.
    # @param user_id:         The user's account, max length is 64 Bytes.
    # @param expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
    #                         Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
    # @return The Chat User token.
    def self.build_user_token(app_id, app_certificate, user_id, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

      service_chat = AgoraDynamicKey2::ServiceChat.new(user_id)
      service_chat.add_privilege(AgoraDynamicKey2::ServiceChat::PRIVILEGE_USER, expire)
      access_token.add_service(service_chat)

      access_token.build
    end

    # Build the Chat App token.
    #
    # @param app_id:          The App ID issued to you by Agora. Apply for a new App ID from
    #                         Agora Dashboard if it is missing from your kit. See Get an App ID.
    # @param app_certificate: Certificate of the application that you registered in
    #                         the Agora Dashboard. See Get an App Certificate.
    # @param expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
    #                         Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
    # @return The Chat App token.
    def self.build_app_token(app_id, app_certificate, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

      service_chat = AgoraDynamicKey2::ServiceChat.new
      service_chat.add_privilege(AgoraDynamicKey2::ServiceChat::PRIVILEGE_APP, expire)
      access_token.add_service(service_chat)

      access_token.build
    end
  end
end
