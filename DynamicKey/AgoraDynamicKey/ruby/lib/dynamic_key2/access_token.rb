require 'openssl'
require 'zlib'
require 'base64'

module AgoraDynamicKey2
  class Service
    attr_accessor :type, :privileges

    def initialize(type)
      @type = type
      @privileges = {}
    end

    def add_privilege(privilege, expire)
      @privileges[privilege] = expire
    end

    def fetch_uid(uid)
      return '' if uid.eql?(0)

      uid.to_s
    end

    def pack
      Util.pack_uint16(@type) + Util.pack_map_uint32(@privileges)
    end

    def unpack(data)
      @privileges, data = Util.unpack_map_uint32(data)
    end
  end

  class ServiceRtc < Service
    attr_accessor :channel_name, :uid

    SERVICE_TYPE = 1
    PRIVILEGE_JOIN_CHANNEL = 1
    PRIVILEGE_PUBLISH_AUDIO_STREAM = 2
    PRIVILEGE_PUBLISH_VIDEO_STREAM = 3
    PRIVILEGE_PUBLISH_DATA_STREAM = 4

    def initialize(channel_name = '', uid = '')
      super(SERVICE_TYPE)
      @channel_name = channel_name
      @uid = fetch_uid(uid)
    end

    def pack
      super() + Util.pack_string(@channel_name) + Util.pack_string(@uid)
    end

    def unpack(data)
      _, data = super(data)
      @channel_name, data = Util.unpack_string(data)
      @uid, data = Util.unpack_string(data)
    end
  end

  class ServiceRtm < Service
    attr_accessor :user_id

    SERVICE_TYPE = 2
    PRIVILEGE_JOIN_LOGIN = 1

    def initialize(user_id = '')
      super(SERVICE_TYPE)
      @user_id = user_id
    end

    def pack
      super() + Util.pack_string(@user_id)
    end

    def unpack(data)
      _, data = super(data)
      @user_id, data = Util.unpack_string(data)
    end
  end

  class ServiceFpa < Service
    SERVICE_TYPE = 4
    PRIVILEGE_LOGIN = 1

    def initialize
      super(SERVICE_TYPE)
    end

    def pack
      super()
    end

    def unpack(data)
      _, data = super(data)
    end
  end

  class ServiceChat < Service
    attr_accessor :uid

    SERVICE_TYPE = 5
    PRIVILEGE_USER = 1
    PRIVILEGE_APP = 2

    def initialize(uid = '')
      super(SERVICE_TYPE)
      @uid = fetch_uid(uid)
    end

    def pack
      super() + Util.pack_string(@uid)
    end

    def unpack(data)
      _, data = super(data)
      @uid, data = Util.unpack_string(data)
    end
  end

  class ServiceEducation < Service
    attr_accessor :room_uuid, :user_uuid, :role

    SERVICE_TYPE = 7
    PRIVILEGE_ROOM_USER = 1
    PRIVILEGE_USER = 2
    PRIVILEGE_APP = 3

    def initialize(room_uuid = '', user_uuid = '', role = -1)
      super(SERVICE_TYPE)
      @room_uuid = room_uuid
      @user_uuid = user_uuid
      @role = role
    end

    def pack
      super() + Util.pack_string(@room_uuid) + Util.pack_string(@user_uuid) + Util.pack_int16(@role)
    end

    def unpack(data)
      _, data = super(data)
      @room_uuid, data = Util.unpack_string(data)
      @user_uuid, data = Util.unpack_string(data)
      @role, data = Util.unpack_int16(data)
    end
  end

  class AccessToken
    attr_accessor :app_cert, :app_id, :expire, :issue_ts, :salt, :services

    VERSION = '007'.freeze
    VERSION_LENGTH = 3
    SERVICES = { ServiceRtc::SERVICE_TYPE => ServiceRtc,
                 ServiceRtm::SERVICE_TYPE => ServiceRtm,
                 ServiceFpa::SERVICE_TYPE => ServiceFpa,
                 ServiceChat::SERVICE_TYPE => ServiceChat,
                 ServiceEducation::SERVICE_TYPE => ServiceEducation }.freeze

    def initialize(app_id = '', app_cert = '', expire = 900)
      @app_id = app_id
      @app_cert = app_cert
      @expire = expire
      @issue_ts = Time.now.to_i
      @salt = rand(1...99_999_999)
      @services = {}
    end

    def add_service(service)
      @services[service.type] = service
    end

    def build
      return '' if !uuid?(@app_id) || !uuid?(@app_cert)

      signing = fetch_sign
      data = Util.pack_string(@app_id) + Util.pack_uint32(@issue_ts) + Util.pack_uint32(@expire) \
                   + Util.pack_uint32(@salt) + Util.pack_uint16(@services.size)

      @services.each do |_, service|
        data += service.pack
      end

      signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing, data)
      fetch_version + Base64.strict_encode64(Zlib::Deflate.deflate(Util.pack_string(signature) + data))
    end

    def fetch_sign
      sign = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Util.pack_uint32(@issue_ts), @app_cert)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Util.pack_uint32(@salt), sign)
    end

    def fetch_version
      VERSION
    end

    def uuid?(str)
      return false if str.length != 32

      true
    end

    def parse(token)
      return false if token[0..VERSION_LENGTH - 1] != fetch_version

      data = Zlib::Inflate.inflate(Base64.strict_decode64(token[VERSION_LENGTH..-1]))
      signature, data = Util.unpack_string(data)
      @app_id, data = Util.unpack_string(data)
      @issue_ts, data = Util.unpack_uint32(data)
      @expire, data = Util.unpack_uint32(data)
      @salt, data = Util.unpack_uint32(data)
      service_num, data = Util.unpack_uint16(data)

      (1..service_num).each do
        service_type, data = Util.unpack_uint16(data)
        service = SERVICES[service_type].new
        _, data = service.unpack(data)
        @services[service_type] = service
      end
      true
    end
  end
end
