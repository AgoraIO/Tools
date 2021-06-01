require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::RtmTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:expire) { 600 }
  let(:user_id) { 'test_user' }

  it 'test_build_token' do
    token = AgoraDynamicKey2::RtmTokenBuilder.build_token(app_id, app_certificate, user_id, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE].user_id).to eq(user_id)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN]).to eq(expire)
  end
end
