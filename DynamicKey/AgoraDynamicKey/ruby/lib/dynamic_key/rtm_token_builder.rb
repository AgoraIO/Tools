module AgoraDynamicKey
  class RTMTokenBuilder
    module Role
      RTM_USER = 1
    end

    class << self
      attr_accessor :token

      # 
      # @param payload
      # :app_id app_id The App ID issued to you by Agora. Apply for a new App ID from 
      #        Agora Dashboard if it is missing from your kit. See Get an App ID.
      # :app_certificate app_certificate Certificate of the application that you registered in 
      #        the Agora Dashboard. See Get an App Certificate.
      # :role role AgoraDynamicKey::RTCTokenBuilder::Role::RTM_USER = 1: RTM USER
      # :account  User Account.
      # :privilege_expired_ts represented by the number of seconds elapsed since 1/1/1970.
      #        If, for example, you want to access the Agora Service within 10 minutes
      #        after the token is generated, set expireTimestamp as the current time stamp
      #        + 600 (seconds).                             
      def build_token payload
        check! payload, %i[app_id app_certificate role account privilege_expired_ts]
        token = AccessToken.new @params.merge(:channel_name => @params[:account])
        token.grant Privilege::RTM_LOGIN, @params[:privilege_expired_ts]
        token.build!
      end

      private
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