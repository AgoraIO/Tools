require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::RtcTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:channel_name) { '7d72365eb983485397e3e3f9d460bdda' }
  let(:expire) { 600 }
  let(:uid) { 2882341273 }
  let(:uid_s) { '2882341273' }

  # Verifies publisher RTC token generation with a numeric user ID.
  it 'test_build_token_with_uid_ROLE_PUBLISHER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name, uid, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  # Verifies publisher RTC token generation with a user account.
  it 'test_build_token_with_user_account_ROLE_PUBLISHER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, uid_s, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  # Verifies subscriber RTC token generation with a user account.
  it 'test_build_token_with_user_account_ROLE_SUBSCRIBER' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, uid_s, AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(nil)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(nil)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(nil)
  end

  # Verifies RTC token generation with explicit numeric-user privileges.
  it 'test_build_token_with_uid_and_privilege' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid_and_privilege(app_id, app_certificate, channel_name, uid, expire, expire, expire, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  # Verifies RTC token generation with explicit user-account privileges.
  it 'test_build_token_with_user_account_and_privilege' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account_and_privilege(app_id, app_certificate, channel_name, uid_s, expire, expire, expire, expire, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services.size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.channel_name).to eq(channel_name)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(uid_s)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.type).to eq(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(expire)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(expire)
  end

  # Verifies combined RTC and RTM token generation.
  it 'test_build_token_with_rtm' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_rtm(
      app_id, app_certificate, channel_name, uid_s, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER, expire, expire
    )
    access_token = AgoraDynamicKey2::AccessToken.new

    expect(access_token.parse(token)).to eq(true)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).size).to eq(1)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).size).to eq(1)
    expect(access_token.verify_signature(app_certificate)).to eq(true)
  end

  # Verifies combined RTC and RTM token generation with independent privileges.
  it 'test_build_token_with_rtm2' do
    token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_rtm2(
      app_id, app_certificate, channel_name, 'rtc-account', AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER,
      expire, 1, 2, 3, 4, 'rtm-account', expire
    )
    access_token = AgoraDynamicKey2::AccessToken.new

    expect(access_token.parse(token)).to eq(true)
    rtc_service = access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first
    rtm_service = access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first
    expect(rtc_service.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_JOIN_CHANNEL]).to eq(1)
    expect(rtc_service.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]).to eq(2)
    expect(rtc_service.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]).to eq(3)
    expect(rtc_service.privileges[AgoraDynamicKey2::ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]).to eq(4)
    expect(rtm_service.user_id).to eq('rtm-account')
    expect(access_token.verify_signature(app_certificate)).to eq(true)
  end
end
