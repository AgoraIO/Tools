# coding: utf-8
require 'openssl'
require 'base64'
module DynamicKey5
  module_function

# service type
  MEDIA_CHANNEL_SERVICE = 1
  RECORDING_SERVICE = 2
  PUBLIC_SHARING_SERVICE = 3
  IN_CHANNEL_PERMISSION = 4

# extra key
  ALLOW_UPLOAD_IN_CHANNEL = 1

# permision
  NO_UPLOAD = "0"
  AUDIO_VIDEO_UPLOAD= "3"

  def gen_public_sharing_key(
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts)
    gen_dynamic_key(
        PUBLIC_SHARING_SERVICE,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts, {})
  end


  def gen_recording_key(
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts)

    gen_dynamic_key(
        RECORDING_SERVICE,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts,
        {})
  end

  def gen_media_channel_key(
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts)

    gen_dynamic_key(
        MEDIA_CHANNEL_SERVICE,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts,
        {})
  end

  def gen_in_channel_permission_key(
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts,
      permission)

    extra={}
    extra[ALLOW_UPLOAD_IN_CHANNEL]=permission
    gen_dynamic_key(
        IN_CHANNEL_PERMISSION,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts,
        extra)
  end

  def gen_dynamic_key(
      service_type,
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts,
      extra
  )
    uid = uid & 0xFFFFFFFF
    random_int = random_int & 0xFFFFFFFF
    signature = gen_signature(
        service_type,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts,
        extra
    )
    version = sprintf('%03d', 5)
    content = pack_uint16(service_type)
    content+= pack_string(signature)
    content+= pack_string([app_id].pack("H*"))
    content+= pack_uint32(unix_ts)
    content+= pack_uint32(random_int)
    content+= pack_uint32(expired_ts)
    content+= pack_map(extra)

    version + Base64.encode64(content).gsub(/\n/,'')
  end

  def gen_signature(
      service_type,
      app_id,
      app_certificate,
      channel_name,
      unix_ts,
      random_int,
      uid,
      expired_ts,
      extra)
    raw_app_certificate = [app_certificate].pack("H*")
    raw_app_id = [app_id].pack("H*")

    content = pack_uint16(service_type)
    content += pack_string(raw_app_id)
    content += pack_uint32(unix_ts)
    content += pack_int32(random_int)
    content += pack_string(channel_name)
    content += pack_uint32(uid)
    content += pack_uint32(expired_ts)
    content += pack_map(extra)

    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), raw_app_certificate, content).upcase
  end

  def pack_uint16(x)
    [x].pack('<S')
  end

  def pack_uint32(x)
    [x].pack('<I')
  end

  def pack_int32(x)
    [x].pack('<i')
  end

  def pack_string(string)
    pack_uint16(string.length) + string
  end

  def pack_map(m)
    ret = pack_uint16(m.size)
    m.each do |k, v|
      pack_uint16(k) + pack_string(v.to_s)
    end
    ret
  end
end

