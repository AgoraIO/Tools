module AgoraDynamicKey2
  class EducationTokenBuilder
    # Build the Education token.
    #
    # app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    #     from your kit. See Get an App ID.
    # app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    #     See Get an App Certificate.
    # room_uuid: The room's id, must be unique.
    # user_uuid: The user's id, must be unique.
    # role: The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
    # expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
    #     Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
    # return: The Education token.
    def self.build_room_user_token(app_id, app_certificate, room_uuid, user_uuid, role, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

      chat_user_id = Digest::MD5.hexdigest user_uuid
      service_education = AgoraDynamicKey2::ServiceEducation.new(room_uuid, user_uuid, role)
      service_education.add_privilege(AgoraDynamicKey2::ServiceEducation::PRIVILEGE_ROOM_USER, expire)
      access_token.add_service(service_education)

      service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_uuid)
      service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire)
      access_token.add_service(service_rtm)

      service_chat = AgoraDynamicKey2::ServiceChat.new(chat_user_id)
      service_chat.add_privilege(AgoraDynamicKey2::ServiceChat::PRIVILEGE_USER, expire)
      access_token.add_service(service_chat)

      access_token.build
    end

    # Build the Education token.
    #
    # app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    #     from your kit. See Get an App ID.
    # app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    #     See Get an App Certificate.
    # user_uuid: The user's id, must be unique.
    # expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
    #     Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
    # return: The Education token.
    def self.build_user_token(app_id, app_certificate, user_uuid, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

      service_education = AgoraDynamicKey2::ServiceEducation.new('', user_uuid)
      service_education.add_privilege(AgoraDynamicKey2::ServiceEducation::PRIVILEGE_USER, expire)
      access_token.add_service(service_education)

      access_token.build
    end

    # Build the Education token.
    #
    # app_id: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing
    #     from your kit. See Get an App ID.
    # app_certificate: Certificate of the application that you registered in the Agora Dashboard.
    #     See Get an App Certificate.
    # expire: represented by the number of seconds elapsed since now. If, for example, you want to access the
    #     Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
    # return: The Education token.
    def self.build_app_token(app_id, app_certificate, expire)
      access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

      service_education = AgoraDynamicKey2::ServiceEducation.new
      service_education.add_privilege(AgoraDynamicKey2::ServiceEducation::PRIVILEGE_APP, expire)
      access_token.add_service(service_education)

      access_token.build
    end
  end
end
