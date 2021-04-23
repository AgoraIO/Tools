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

      # Generates an RTC token with the specified privilege.
      #
      # This method supports generating a token with the following privileges:
      # - Joining an RTC channel.
      # - Publishing audio in an RTC channel.
      # - Publishing video in an RTC channel.
      # - Publishing data streams in an RTC channel.
      #
      # The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
      # enabled co-host authentication.
      #
      # A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
      # The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
      # or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
      # the respective timestamp for each privilege in your app logic. After receiving the callback, you need
      # to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
      # the channel.
      #
      # @note
      # Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
      # Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
      # When the token for joining the channel expires, the user is immediately kicked off the RTC channel
      # and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
      #
      # @param app_id The App ID of your Agora project.
      # @param app_certificate The App Certificate of your Agora project.
      # @param channel_name The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
      # - All lowercase English letters: a to z.
      # - All uppercase English letters: A to Z.
      # - All numeric characters: 0 to 9.
      # - The space character.
      # - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
      # @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (232 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
      # @param join_channel_privilege_expired_ts The Unix timestamp when the privilege for joining the channel expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set join_channel_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes.
      # @param pub_audio_privilege_expired_ts The Unix timestamp when the privilege for publishing audio expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_audio_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_audio_privilege_expired_ts as the current Unix timestamp.
      # @param pub_video_privilege_expired_ts The Unix timestamp when the privilege for publishing video expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_video_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_video_privilege_expired_ts as the current Unix timestamp.
      # @param pub_data_stream_privilege_expired_ts The Unix timestamp when the privilege for publishing data streams expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_data_stream_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_data_stream_privilege_expired_ts as the current Unix timestamp.
      # @return The new Token

      def build_token_with_uid_and_privilege payload
        check! payload, %i[app_id app_certificate channel_name uid join_channel_privilege_expired_ts pub_audio_privilege_expired_ts pub_video_privilege_expired_ts pub_data_stream_privilege_expired_ts]
        build_token_with_user_account_and_privilege @params.merge(:account => @params[:uid])
      end

      # Generates an RTC token with the specified privilege.
      #
      # This method supports generating a token with the following privileges:
      # - Joining an RTC channel.
      # - Publishing audio in an RTC channel.
      # - Publishing video in an RTC channel.
      # - Publishing data streams in an RTC channel.
      #
      # The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
      # enabled co-host authentication.
      #
      # A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
      # The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
      # or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
      # the respective timestamp for each privilege in your app logic. After receiving the callback, you need
      # to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
      # the channel.
      #
      # @note
      # Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
      # Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
      # When the token for joining the channel expires, the user is immediately kicked off the RTC channel
      # and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
      #
      # @param app_id The App ID of your Agora project.
      # @param app_certificate The App Certificate of your Agora project.
      # @param channel_name The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
      # - All lowercase English letters: a to z.
      # - All uppercase English letters: A to Z.
      # - All numeric characters: 0 to 9.
      # - The space character.
      # - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
      # @param account The user account.
      # @param join_channel_privilege_expired_ts The Unix timestamp when the privilege for joining the channel expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set join_channel_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes.
      # @param pub_audio_privilege_expired_ts The Unix timestamp when the privilege for publishing audio expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_audio_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_audio_privilege_expired_ts as the current Unix timestamp.
      # @param pub_video_privilege_expired_ts The Unix timestamp when the privilege for publishing video expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_video_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_video_privilege_expired_ts as the current Unix timestamp.
      # @param pub_data_stream_privilege_expired_ts The Unix timestamp when the privilege for publishing data streams expires, represented
      # by the sum of the current timestamp plus the valid time period of the token. For example, if you set pub_data_stream_privilege_expired_ts as the
      # current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
      # set pub_data_stream_privilege_expired_ts as the current Unix timestamp.
      # @return The new Token

      def build_token_with_user_account_and_privilege payload
        check! payload, %i[app_id app_certificate channel_name account join_channel_privilege_expired_ts pub_audio_privilege_expired_ts pub_video_privilege_expired_ts pub_data_stream_privilege_expired_ts]
        @params.merge!(:uid => @params[:account])
        generate_access_token_user_defined!
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
      # generate access token
      def generate_access_token_user_defined!
        # Assign appropriate access privileges to each role.
        AgoraDynamicKey::AccessToken.generate!(@params) do |t|
          t.grant AgoraDynamicKey::Privilege::JOIN_CHANNEL, t.join_channel_privilege_expired_ts
          t.grant AgoraDynamicKey::Privilege::PUBLISH_AUDIO_STREAM, t.pub_audio_privilege_expired_ts
          t.grant AgoraDynamicKey::Privilege::PUBLISH_VIDEO_STREAM, t.pub_video_privilege_expired_ts
          t.grant AgoraDynamicKey::Privilege::PUBLISH_DATA_STREAM, t.pub_data_stream_privilege_expired_ts
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