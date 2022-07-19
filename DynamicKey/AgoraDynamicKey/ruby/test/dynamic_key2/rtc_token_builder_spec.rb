require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::RtcTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:channel_name) { '7d72365eb983485397e3e3f9d460bdda' }
  let(:expire) { 600 }
  let(:uid) { 2882341273 }
  let(:uid_s) { '2882341273' }

  it 'test_build_token_with_uid_ROLE_PUBLISHER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name, uid, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  it 'test_build_token_with_user_account_ROLE_PUBLISHER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, uid_s, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  it 'test_build_token_with_user_account_ROLE_SUBSCRIBER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, uid_s, AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(nil)
  end

  it 'test_build_token_with_uid_and_privilege' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid_and_privilege(app_id, app_certificate, channel_name, uid, expire, expire, expire, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  it 'test_build_token_with_user_account_and_privilege' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account_and_privilege(app_id, app_certificate, channel_name, uid_s, expire, expire, expire, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].channel_name).to eq(channel_name)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].uid).to eq(uid_s)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end
end
