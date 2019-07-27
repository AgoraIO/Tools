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
      ATTENDEE = 0 # for communication
      PUBLISHER = 1 # for live broadcast
      SUBSCRIBER = 2 # for live broadcast 
      ADMIN = 101
    end

    class << self

      #
      # @param app_id The App ID issued to you by Agora. Apply for a new App ID from 
      #        Agora Dashboard if it is missing from your kit. See Get an App ID.
      # @param app_certificate Certificate of the application that you registered in 
      #        the Agora Dashboard. See Get an App Certificate.
      # @param channel_name Unique channel name for the AgoraRTC session in the string format
      # @param uid  User ID. A 32-bit unsigned integer with a value ranging from 
      #        1 to (232-1). optionalUid must be unique.
      # @param role AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER = 1: A broadcaster (host) in a live-broadcast profile.
      #             AgoraDynamicKey::RTCTokenBuilder::Role::SUBSCRIBER = 2: (Default) A audience in a live-broadcast profile.
      # @param privilege_expired_ts represented by the number of seconds elapsed since 1/1/1970.
      #        If, for example, you want to access the Agora Service within 10 minutes
      #        after the token is generated, set expireTimestamp as the current time stamp
      #        + 600 (seconds).                             
      def build_token_with_uid payload
        check! payload, %i[app_id app_certificate channel_name role uid privilege_expired_ts]
        build_token_with_account @params.merge(:account => @params[:uid])
      end

      # @param app_id The App ID issued to you by Agora. Apply for a new App ID from 
      #        Agora Dashboard if it is missing from your kit. See Get an App ID.
      # @param app_certificate Certificate of the application that you registered in 
      #        the Agora Dashboard. See Get an App Certificate.
      # @param channel_name Unique channel name for the AgoraRTC session in the string format
      # @param account User account
      # @param role AgoraDynamicKey::Role::PUBLISHER = 1: A broadcaster (host) in a live-broadcast profile.
      #             AgoraDynamicKey::Role::SUBSCRIBER = 2: (Default) A audience in a live-broadcast profile.
      # @param privilege_expired_ts represented by the number of seconds elapsed since 1/1/1970.
      #        If, for example, you want to access the Agora Service within 10 minutes
      #        after the token is generated, set expireTimestamp as the current time stamp
      #        + 600 (seconds).                             
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