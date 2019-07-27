module AgoraDynamicKey
  module Privilege
    JOIN_CHANNEL = 1
    PUBLISH_AUDIO_STREAM = 2
    PUBLISH_VIDEO_STREAM = 3
    PUBLISH_DATA_STREAM = 4
    RTM_LOGIN = 1000 # for RTM Only
  end

  class AccessToken
    VERSION = "006"

    ONE_DAY = 864_00
    SEED = 2 ** 32 - 1

    attr_accessor :app_id, :channel_name, :app_certificate,
                  :uid, :privileges, :privilege_expired_ts,
                  :salt, :expired_ts

    def initialize args={}
      @app_id = args[:app_id]
      @channel_name = args.fetch(:channel_name, "")
      @app_certificate = args[:app_certificate]
      @uid = "#{args.fetch(:uid, "")}"
      @privileges = {}
      @privilege_expired_ts = args[:privilege_expired_ts]
      @salt = SecureRandom.rand(SEED)
      @expired_ts = Time.now.to_i + ONE_DAY
    end

    def add_privilege privilege, ts
      privileges[privilege] = ts
    end

    alias grant add_privilege

    def build
      Sign.encode self
    end

    def build!
      Sign.encode! self
    end

    def from_string token
      Sign.decode token
    end

    def self.generate! payload={}, &block
      token = AccessToken.new payload
      block.call token
      token.build!
    end
  end
end