require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::ChatTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:user_id) { '2882341273' }
  let(:expire) { 600 }

  # Verifies Chat user token generation and parsing.
  it 'test_build_user_token' do
    token = AgoraDynamicKey2::ChatTokenBuilder.build_user_token(app_id, app_certificate, user_id, expire)
    access_token = AgoraDynamicKey2::AccessToken.new

    expect(access_token.parse(token)).to eq(true)
    service = access_token.get_services(AgoraDynamicKey2::ServiceChat::SERVICE_TYPE).first
    expect(service.uid).to eq(user_id)
    expect(service.privileges[AgoraDynamicKey2::ServiceChat::PRIVILEGE_USER]).to eq(expire)
    expect(access_token.verify_signature(app_certificate)).to eq(true)
  end

  # Verifies Chat application token generation and parsing.
  it 'test_build_app_token' do
    token = AgoraDynamicKey2::ChatTokenBuilder.build_app_token(app_id, app_certificate, expire)
    access_token = AgoraDynamicKey2::AccessToken.new

    expect(access_token.parse(token)).to eq(true)
    service = access_token.get_services(AgoraDynamicKey2::ServiceChat::SERVICE_TYPE).first
    expect(service.privileges[AgoraDynamicKey2::ServiceChat::PRIVILEGE_APP]).to eq(expire)
    expect(access_token.verify_signature(app_certificate)).to eq(true)
  end
end
