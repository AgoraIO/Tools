require 'rspec'
require_relative '../../lib/dynamic_key2'

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

    service_chat = AgoraDynamicKey2::ServiceChat.new(uid_s)
    service_chat.add_privilege(AgoraDynamicKey2::ServiceChat::PRIVILEGE_USER, expire)
    access_token.add_service(service_chat)

    token = access_token.build
    expect(token).to eq('007eJxTYLh59YaCUHZeRLXJsRSTDvfv2SV2uddsV+m05Vx5HaP59bMCg6W5gbOjsWlKqplBsomJmYlpUlJiqkWikaGpgZlhkrGx+xcBhggmBgZGBgYGJiDJAsQgPhOYZAaTLGBSgcE8xdzI2Mw0NcnSwtjEwtTY0jzVONU4zTLFxMwgKSUlkYvByMLCyNjE0MjcmBVoDsQkZFEAlCcpOg==')
  end

  it 'test_parse_TokenRtc' do
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse('007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj')

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.issue_ts).to eq(issue_ts)
    expect(access_token.salt).to eq(salt)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(nil)
  end

  it 'test_parse_Token_MultiService' do
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse('007eJxTYLh59YaCUHZeRLXJsRSTDvfv2SV2uddsV+m05Vx5HaP59bMCg6W5gbOjsWlKqplBsomJmYlpUlJiqkWikaGpgZlhkrGx+xcBhggmBgZGBgYGJiDJAsQgPhOYZAaTLGBSgcE8xdzI2Mw0NcnSwtjEwtTY0jzVONU4zTLFxMwgKSUlkYvByMLCyNjE0MjcmBVoDsQkZFEAlCcpOg==')

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.issue_ts).to eq(issue_ts)
    expect(access_token.salt).to eq(salt)
    expect(access_token.services.size).to eq(2)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  it 'test_Service_fetch_uid' do
    service = AgoraDynamicKey2::Service.allocate

    expect(service.fetch_uid(0)).to eq('')
    expect(service.fetch_uid(uid)).to eq(uid_s)
    expect(service.fetch_uid(uid_s)).to eq(uid_s)
  end
end
