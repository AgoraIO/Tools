require 'openssl'
require 'zlib'
require 'base64'

module AgoraDynamicKey2
  # Stores a service type and its privilege expiration timestamps.
  class Service
    attr_accessor :type, :privileges

    # Creates a service with the specified numeric type.
    def initialize(type)
      @type = type
      @privileges = {}
    end

    # Adds or replaces a privilege expiration timestamp.
    def add_privilege(privilege, expire)
      @privileges[privilege] = expire
    end

    # Converts a user ID to its token string representation.
    def fetch_uid(uid)
      return '' if uid.eql?(0)

      uid.to_s
    end

    # Serializes the service type and privileges.
    def pack
      Util.pack_uint16(@type) + Util.pack_map_uint32(@privileges)
    end

    # Deserializes service privileges after the type has been consumed.
    def unpack(data)
      @privileges, data = Util.unpack_map_uint32(data)
    end
  end

  # Stores an RTC service payload.
  class ServiceRtc < Service
    attr_accessor :channel_name, :uid

    SERVICE_TYPE = 1
    PRIVILEGE_JOIN_CHANNEL = 1
    PRIVILEGE_PUBLISH_AUDIO_STREAM = 2
    PRIVILEGE_PUBLISH_VIDEO_STREAM = 3
    PRIVILEGE_PUBLISH_DATA_STREAM = 4

    # Creates an RTC service for a channel and user ID.
    def initialize(channel_name = '', uid = '')
      super(SERVICE_TYPE)
      @channel_name = channel_name
      @uid = fetch_uid(uid)
    end

    # Serializes the RTC service payload.
    def pack
      super() + Util.pack_string(@channel_name) + Util.pack_string(@uid)
    end

    # Deserializes the RTC service payload.
    def unpack(data)
      _, data = super(data)
      @channel_name, data = Util.unpack_string(data)
      @uid, data = Util.unpack_string(data)
    end
  end

  # Stores an RTM service payload.
  class ServiceRtm < Service
    attr_accessor :user_id

    SERVICE_TYPE = 2
    PRIVILEGE_JOIN_LOGIN = 1

    # Creates an RTM service for a user ID.
    def initialize(user_id = '')
      super(SERVICE_TYPE)
      @user_id = user_id
    end

    # Serializes the RTM service payload.
    def pack
      super() + Util.pack_string(@user_id)
    end

    # Deserializes the RTM service payload.
    def unpack(data)
      _, data = super(data)
      @user_id, data = Util.unpack_string(data)
    end
  end

  # Stores an FPA service payload.
  class ServiceFpa < Service
    SERVICE_TYPE = 4
    PRIVILEGE_LOGIN = 1

    # Creates an FPA service.
    def initialize
      super(SERVICE_TYPE)
    end

    # Serializes the FPA service payload.
    def pack
      super()
    end

    # Deserializes the FPA service payload.
    def unpack(data)
      _, data = super(data)
    end
  end

  # Stores a Chat service payload.
  class ServiceChat < Service
    attr_accessor :uid

    SERVICE_TYPE = 5
    PRIVILEGE_USER = 1
    PRIVILEGE_APP = 2

    # Creates a Chat service for a user ID.
    def initialize(uid = '')
      super(SERVICE_TYPE)
      @uid = fetch_uid(uid)
    end

    # Serializes the Chat service payload.
    def pack
      super() + Util.pack_string(@uid)
    end

    # Deserializes the Chat service payload.
    def unpack(data)
      _, data = super(data)
      @uid, data = Util.unpack_string(data)
    end
  end

  # Stores an APaaS service payload.
  class ServiceApaas < Service
    attr_accessor :room_uuid, :user_uuid, :role

    SERVICE_TYPE = 7
    PRIVILEGE_ROOM_USER = 1
    PRIVILEGE_USER = 2
    PRIVILEGE_APP = 3

    # Creates an APaaS service for a room, user, and role.
    def initialize(room_uuid = '', user_uuid = '', role = -1)
      super(SERVICE_TYPE)
      @room_uuid = room_uuid
      @user_uuid = user_uuid
      @role = role
    end

    # Serializes the APaaS service payload.
    def pack
      super() + Util.pack_string(@room_uuid) + Util.pack_string(@user_uuid) + Util.pack_int16(@role)
    end

    # Deserializes the APaaS service payload.
    def unpack(data)
      _, data = super(data)
      @room_uuid, data = Util.unpack_string(data)
      @user_uuid, data = Util.unpack_string(data)
      @role, data = Util.unpack_int16(data)
    end
  end

  # Builds, parses, and verifies Token007 tokens containing one or more services.
  class AccessToken
    attr_accessor :app_cert, :app_id, :expire, :issue_ts, :salt, :services

    VERSION = '007'.freeze
    VERSION_LENGTH = 3
    SERVICES = { ServiceRtc::SERVICE_TYPE => ServiceRtc,
                 ServiceRtm::SERVICE_TYPE => ServiceRtm,
                 ServiceFpa::SERVICE_TYPE => ServiceFpa,
                 ServiceChat::SERVICE_TYPE => ServiceChat,
                 ServiceApaas::SERVICE_TYPE => ServiceApaas }.freeze

    # Creates a token builder or an empty token parser.
    def initialize(app_id = '', app_cert = '', expire = 900)
      @app_id = app_id
      @app_cert = app_cert
      @expire = expire
      @issue_ts = Time.now.to_i
      @salt = rand(1...99_999_999)
      @services = []
      @signature = ''.b
      @signing_info = ''.b
    end

    # Adds a service without replacing services of the same type.
    def add_service(service)
      @services << service
    end

    # Returns all services of the requested type in insertion or token order.
    def get_services(service_type)
      @services.select { |service| service.type == service_type }
    end

    # Builds a Token007 token and requires at least one service.
    def build
      return '' if !uuid?(@app_id) || !uuid?(@app_cert) || @services.empty?

      signing = fetch_sign
      services = services_for_packing
      data = Util.pack_string(@app_id) + Util.pack_uint32(@issue_ts) + Util.pack_uint32(@expire) \
                   + Util.pack_uint32(@salt) + Util.pack_uint16(services.size)

      services.each do |service|
        data += service.pack
      end

      signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing, data)
      fetch_version + Base64.strict_encode64(Zlib::Deflate.deflate(Util.pack_string(signature) + data))
    end

    # Derives the signing key with the stored or supplied App Certificate.
    def fetch_sign(app_certificate = @app_cert)
      sign = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Util.pack_uint32(@issue_ts), app_certificate)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), Util.pack_uint32(@salt), sign)
    end

    # Returns the Token007 version prefix.
    def fetch_version
      VERSION
    end

    # Returns whether a value is a 32-character hexadecimal identifier.
    def uuid?(str)
      str.is_a?(String) && str.match?(/\A[0-9a-fA-F]{32}\z/)
    end

    # Parses known services and retains the original bytes for signature verification.
    def parse(token)
      return false unless token.is_a?(String) && token.bytesize >= VERSION_LENGTH
      return false if token[0, VERSION_LENGTH] != fetch_version

      data = Zlib::Inflate.inflate(Base64.strict_decode64(token[VERSION_LENGTH..]))
      @signature, data = Util.unpack_string(data)
      @signing_info = data.dup
      @services = []
      @app_id, data = Util.unpack_string(data)
      @issue_ts, data = Util.unpack_uint32(data)
      @expire, data = Util.unpack_uint32(data)
      @salt, data = Util.unpack_uint32(data)
      service_num, data = Util.unpack_uint16(data)

      service_num.times do
        service_type, data = Util.unpack_uint16(data)
        service_class = SERVICES[service_type]
        return true unless service_class

        service = service_class.new
        _, data = service.unpack(data)
        add_service(service)
      end
      true
    rescue StandardError
      false
    end

    # Verifies the signature of a successfully parsed token.
    def verify_signature(app_certificate)
      return false if @signature.empty? || @signing_info.empty?
      return false if !uuid?(@app_id) || !uuid?(app_certificate)

      signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), fetch_sign(app_certificate), @signing_info)
      return false if signature.bytesize != @signature.bytesize

      OpenSSL.fixed_length_secure_compare(signature, @signature)
    rescue StandardError
      false
    end

    private

    # Returns services in stable type order while preserving duplicate insertion order.
    def services_for_packing
      @services.each_with_index.sort_by { |service, index| [service.type, index] }.map(&:first)
    end
  end
end
