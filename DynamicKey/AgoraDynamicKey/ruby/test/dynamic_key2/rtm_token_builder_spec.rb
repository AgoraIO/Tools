require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::RtmTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:expire) { 600 }
  let(:user_id) { 'test_user' }

  # Verifies RTM Token007 generation and parsing.
  it 'test_build_token' do
    token = AgoraDynamicKey2::RtmTokenBuilder.build_token(app_id, app_certificate, user_id, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.user_id).to eq(user_id)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN]).to eq(expire)
  end


  # Builds, parses, and verifies an RTM2 resource permission token.
  it 'test_build_token_with_permissions' do
    permissions = AgoraDynamicKey2::ServiceRtm2::Permissions.new
    permissions.add(
      AgoraDynamicKey2::ServiceRtm2::Permissions::MESSAGE_CHANNELS,
      AgoraDynamicKey2::ServiceRtm2::Permissions::READ,
      %w[message-a message-b]
    )
    permissions.add(
      AgoraDynamicKey2::ServiceRtm2::Permissions::STREAM_CHANNELS,
      AgoraDynamicKey2::ServiceRtm2::Permissions::WRITE,
      ['stream-a']
    )

    token = AgoraDynamicKey2::RtmTokenBuilder.build_token_with_permissions(
      app_id, app_certificate, user_id, permissions, expire
    )
    access_token = AgoraDynamicKey2::AccessToken.new

    expect(access_token.parse(token)).to eq(true)
    expect(access_token.verify_signature(app_certificate)).to eq(true)
    service = access_token.get_services(AgoraDynamicKey2::ServiceRtm2::SERVICE_TYPE).first
    expect(service.user_id).to eq(user_id)
    expect(service.permissions.details).to eq(permissions.details)
    expect(service.privileges[AgoraDynamicKey2::ServiceRtm2::PRIVILEGE_LOGIN]).to eq(expire)
  end
end
