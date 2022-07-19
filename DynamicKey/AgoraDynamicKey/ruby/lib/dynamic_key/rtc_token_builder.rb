module AgoraDynamicKey

  class RTCTokenBuilder
    class InvalidParamsError < StandardError
      attr_reader :params, :missing_keys
      def initialize args={}
        super
        @params = args[:params]
        @missing_keys = args[:missing_keys]
      end
    end

    module Role
      # DEPRECATED. Role::ATTENDEE has the same privileges as Role::PUBLISHER.
      ATTENDEE = 0

      # RECOMMENDED. Use this role for a voice/video call or a live broadcast, if your scenario does not require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
      PUBLISHER = 1

      # Only use this role if your scenario require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
      # @note In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role::SUBSCRIBER still has the same privileges as Role::PUBLISHER.
      SUBSCRIBER = 2

      # DEPRECATED. Role::ADMIN has the same privileges as Role::PUBLISHER.
      ADMIN = 101
    end

    class << self

      #
      # Builds an RTC token using an Integer uid.
      # @param payload
      # :app_id The App ID issued to you by Agora.
      # :app_certificate Certificate of the application that you registered in the Agora Dashboard.
      # :channel_name The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
      # - The 26 lowercase English letters: a to z.
      # - The 26 uppercase English letters: A to Z.
      # - The 10 digits: 0 to 9.
      # - The space.
      # - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
      # :uid User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
      # :role See #userRole.
      # - Role::PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
      # - Role::SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
      # :privilege_expired_ts represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
      # 
      # @return The new Token.
      #
      def build_token_with_uid payload
        check! payload, %i[app_id app_certificate channel_name role uid privilege_expired_ts]
        build_token_with_account @params.merge(:account => @params[:uid])
      end

      #
      # Builds an RTC token using a string user_account.
      # @param payload
      # :app_id The App ID issued to you by Agora.
      # :app_certificate Certificate of the application that you registered in the Agora Dashboard.
      # :channel_name The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
      # - The 26 lowercase English letters: a to z.
      # - The 26 uppercase English letters: A to Z.
      # - The 10 digits: 0 to 9.
      # - The space.
      # - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
      # :account The user account.
      # :role See #userRole.
      # - Role::PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
      # - Role::SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
      # :privilege_expired_ts represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
      # 
      # @return The new Token.
      #                        
      def build_token_with_account payload
        check! payload, %i[app_id app_certificate channel_name role account privilege_expired_ts]
        @params.merge!(:uid => @params[:account])
        generate_access_token!
      end

      private

      # generate access token
      def generate_access_token!
        # Assign appropriate access privileges to each role.
        AgoraDynamicKey::AccessToken.generate!(@params) do |t|
          t.grant AgoraDynamicKey::Privilege::JOIN_CHANNEL, t.privilege_expired_ts
          if @params[:role] == Role::PUBLISHER ||
            @params[:role] == Role::SUBSCRIBER ||
            @params[:role] == Role::ADMIN
            t.grant AgoraDynamicKey::Privilege::PUBLISH_AUDIO_STREAM, t.privilege_expired_ts
            t.grant AgoraDynamicKey::Privilege::PUBLISH_VIDEO_STREAM, t.privilege_expired_ts
            t.grant AgoraDynamicKey::Privilege::PUBLISH_DATA_STREAM, t.privilege_expired_ts
          end
        end
      end

      # params check
      def check!(payload, args)
        raise InvalidParamsError.new(params: payload), "invalid params" if payload.nil? or payload.empty?
        symbolize_keys payload.select { |key| args.include? key }
        missing_keys = args - @params.keys
        raise InvalidParamsError.new(params: payload, missing_keys: missing_keys), "missing params" if missing_keys.size != 0
        _invalid_params = @params.select { |hash, (k, v)| v.nil? or v.empty?}
        raise InvalidParamsError.new(params: payload), "invalid params" if _invalid_params.empty?
      end
      
      # symbolize keys
      def symbolize_keys payload
        @params = payload.inject({}) { |hash, (k, v)| hash[k.to_sym] = v; hash }
      end
    end
  end
end