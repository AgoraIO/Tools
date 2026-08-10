require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::SttTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:channel_name) { 'stt-channel' }
  let(:rtc_account) { 'stt-rtc-user' }
  let(:rtm_user_id) { 'stt-rtm-user' }
  let(:rtc_token_expire) { 3600 }
  let(:join_channel_privilege_expire) { 1800 }
  let(:pub_audio_privilege_expire) { 1700 }
  let(:pub_video_privilege_expire) { 1600 }
  let(:pub_data_stream_privilege_expire) { 1500 }
  let(:rtm_token_expire) { 1400 }

  it 'builds a publisher token' do
    token = AgoraDynamicKey2::SttTokenBuilder.build_token(
      app_id, app_certificate, channel_name, rtc_account, AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER,
      rtc_token_expire, join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
      pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire
    )
    access_token = AgoraDynamicKey2::AccessToken.new
    expect(access_token.parse(token)).to eq(true)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtc::SERVICE_TYPE).first.uid).to eq(rtc_account)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE).first.user_id).to eq(rtm_user_id)
    expect(access_token.get_services(AgoraDynamicKey2::ServiceStt::SERVICE_TYPE).first.privileges).to eq({})
  end
end
