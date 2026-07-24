require 'rspec'
require_relative '../../lib/dynamic_key2'

# Represents an unsupported service type for forward compatibility tests.
class UnknownService < AgoraDynamicKey2::Service
  # Creates a service whose type is not registered by AccessToken.
  def initialize(service_type = 999)
    super(service_type)
  end
end

describe 'AgoraDynamicKey2::AccessToken' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:channel_name) { '7d72365eb983485397e3e3f9d460bdda' }
  let(:expire) { 600 }
  let(:issue_ts) { 1_111_111 }
  let(:salt) { 1 }
  let(:uid) { 2_882_341_273 }
  let(:uid_s) { '2882341273' }
  let(:user_id) { 'test_user' }

  # Verifies token generation rejects an empty service list.
  it 'test_build_rejects_empty_services' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)

    expect(access_token.build).to eq('')
  end

  # Verifies deterministic RTC token generation with a numeric user ID.
  it 'test_build_ServiceRtc' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    token = access_token.build
    expect(token).to eq('007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj')
  end

  # Verifies deterministic RTC token generation with an empty user ID.
  it 'test_build_ServiceRtc_uid_0' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, 0)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    token = access_token.build
    expect(token).to eq('007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo=')
  end

  # Verifies deterministic RTC token generation with a string user account.
  it 'test_build_ServiceRtc_account' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    token = access_token.build
    expect(token).to eq('007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj')
  end

  # Verifies deterministic token generation with distinct service types.
  it 'test_build_multi_service' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, expire)
    access_token.add_service(service_rtc)

    service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_id)
    service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire)
    access_token.add_service(service_rtm)

    token = access_token.build
    expect(token).to eq('007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4')
  end

  # Parses a legacy RTC Token007 token and verifies its fields.
  it 'test_parse_TokenRtc' do
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse('007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj')

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.issue_ts).to eq(issue_ts)
    expect(access_token.salt).to eq(salt)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(nil)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(nil)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(nil)
  end

  # Parses a legacy multi-service Token007 token.
  it 'test_parse_Token_MultiService' do
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse('007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4')

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.issue_ts).to eq(issue_ts)
    expect(access_token.salt).to eq(salt)
    expect(access_token.services.size).to eq(2)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.user_id).to eq(user_id)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN]).to eq(expire)
  end

  # Parses a legacy RTM Token007 token.
  it 'test_parse_TokenRtm' do
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse('007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A')

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.issue_ts).to eq(issue_ts)
    expect(access_token.salt).to eq(salt)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN]).to eq(expire)
  end

  # Verifies numeric and string user ID conversion.
  it 'test_Service_fetch_uid' do
    service = AgoraDynamicKey2::Service.allocate

    expect(service.fetch_uid(0)).to eq('')
    expect(service.fetch_uid(uid)).to eq(uid_s)
    expect(service.fetch_uid(uid_s)).to eq(uid_s)
  end

  # Preserves repeated service types and their insertion order after parsing.
  it 'test_repeated_service_types' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_id)
    service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire + 50)
    access_token.add_service(service_rtm)

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    stream_service = AgoraDynamicKey2::ServiceRtc.new('stream-channel', 'stream-user')
    stream_service.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire + 100)
    stream_service.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, expire + 100)
    access_token.add_service(stream_service)

    token = access_token.build
    expect(access_token.services).to eq([service_rtm, service_rtc, stream_service])
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).size).to eq(2)

    parsed = AgoraDynamicKey2::AccessToken.new
    expect(parsed.parse(token)).to eq(true)
    rtc_services = parsed.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(rtc_services.size).to eq(2)
    expect(rtc_services[0].channel_name).to eq(channel_name)
    expect(rtc_services[1].channel_name).to eq('stream-channel')
    expect(rtc_services[1].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire + 100)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).size).to eq(1)
    expect(parsed.verify_signature(app_certificate)).to eq(true)
    expect(parsed.verify_signature('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')).to eq(false)
  end

  # Keeps known services parsed before an unknown service type.
  it 'test_unknown_service_after_known_service' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    unknown_service = UnknownService.new
    unknown_service.add_privilege(1, expire)
    access_token.add_service(unknown_service)

    parsed = AgoraDynamicKey2::AccessToken.new
    expect(parsed.parse(access_token.build)).to eq(true)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).size).to eq(1)
    expect(parsed.get_services(999)).to be_empty
    expect(parsed.verify_signature(app_certificate)).to eq(true)
  end

  # Stops before known services that follow an unknown service payload.
  it 'test_unknown_service_before_known_service' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)

    unknown_service = UnknownService.new(0)
    unknown_service.add_privilege(1, expire)
    access_token.add_service(unknown_service)

    parsed = AgoraDynamicKey2::AccessToken.new
    expect(parsed.parse(access_token.build)).to eq(true)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)).to be_empty
    expect(parsed.verify_signature(app_certificate)).to eq(true)
  end

  # Sorts a packing copy without changing the public service insertion order.
  it 'test_stable_service_type_ordering' do
    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    access_token.issue_ts = issue_ts
    access_token.salt = salt

    service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_id)
    service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire)
    access_token.add_service(service_rtm)

    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, expire)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, expire)
    access_token.add_service(service_rtc)

    expect(access_token.build).to eq('007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4')
    expect(access_token.services.first).to equal(service_rtm)
  end

  # Replaces services from an earlier parse when parsing an old token.
  it 'test_parse_old_token_and_clear_services' do
    generated = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    service_rtm = AgoraDynamicKey2::ServiceRtm.new(user_id)
    service_rtm.add_privilege(AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN, expire)
    generated.add_service(service_rtm)

    parsed = AgoraDynamicKey2::AccessToken.new
    expect(parsed.parse(generated.build)).to eq(true)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).size).to eq(1)

    old_token = '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
    expect(parsed.parse(old_token)).to eq(true)
    expect(parsed.services.size).to eq(1)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).size).to eq(1)
    expect(parsed.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE)).to be_empty
    expect(parsed.verify_signature(app_certificate)).to eq(true)
  end

  # Rejects signature verification before parsing or with invalid certificates.
  it 'test_verify_signature_preconditions' do
    parsed = AgoraDynamicKey2::AccessToken.new
    expect(parsed.verify_signature(app_certificate)).to eq(false)
    expect(parsed.parse('006invalid')).to eq(false)

    access_token = AgoraDynamicKey2::AccessToken.new(app_id, app_certificate, expire)
    service_rtc = AgoraDynamicKey2::ServiceRtc.new(channel_name, uid_s)
    service_rtc.add_privilege(AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL, expire)
    access_token.add_service(service_rtc)
    expect(parsed.parse(access_token.build)).to eq(true)
    expect(parsed.verify_signature(nil)).to eq(false)
    expect(parsed.verify_signature('invalid')).to eq(false)
    expect(parsed.verify_signature('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz')).to eq(false)
    expect(parsed.verify_signature(app_certificate)).to eq(true)

    expect(parsed.parse('006invalid')).to eq(false)
    expect(parsed.verify_signature(app_certificate)).to eq(false)
    expect(parsed.services).to be_empty
  end
end
