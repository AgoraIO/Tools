require 'rspec'
require_relative '../lib/dynamic_key'

describe 'AgoraDynamicKey::RTCTokenBuilder' do
  context 'build_token_with_uid' do
    let(:token_params) do
      {
        app_id: '970CA35de60c44645bbae8a215061b33',
        app_certificate: '5CFd2fd1755d40ecb72977518be15d3b',
        channel_name: '7d72365eb983485397e3e3f9d460bdda',
        uid: 2882341273,
        role: 1,
        privilege_expired_ts: 1446455471
      }
    end

    it 'return string' do
      expect(AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid(token_params).class).to be String
    end

    it 'invalid params' do
      expect {
        AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid(nil)
      }.to raise_error(AgoraDynamicKey::RTCTokenBuilder::InvalidParamsError, "invalid params")
    end

    it 'invalid params' do
      expect {
        AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid({})
      }.to raise_error(AgoraDynamicKey::RTCTokenBuilder::InvalidParamsError, "invalid params")
    end

    let(:sensitive_params) do
      {
        "APPID": '<agora appId>',
        "APPCertificate": '<agora appCertificate>',
        "CHANNELNAME": 'channel',
        "ROLE": 'admin',
        "UID": 'uid',
        "privilegeExpiredTs": 1564156140
      }
    end

    it 'is not support sensitive' do
      expect {
        AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid(sensitive_params)
      }.to raise_error(AgoraDynamicKey::RTCTokenBuilder::InvalidParamsError, "missing params")
    end
  end

  context 'build_token_with_account' do
    let(:token_params) do
      {
        app_id: '<agora appId>',
        app_certificate: '<agora appCertificate>',
        channel_name: 'channel',
        role: 'admin',
        privilege_expired_ts: 1564156140,
        account: '2333',
        expired_to: '1',
      }
    end

    it 'is correct case' do
      expect(AgoraDynamicKey::RTCTokenBuilder.build_token_with_account(token_params).class).to be String
    end

    it 'is incorrect raise' do
      expect {
        AgoraDynamicKey::RTCTokenBuilder.build_token_with_account({})
      }.to raise_error(AgoraDynamicKey::RTCTokenBuilder::InvalidParamsError, "invalid params")
    end

    let(:sensitive_params) do
      {
        "APPID": '<agora appId>',
        "APPCertificate": '<agora appCertificate>',
        "CHANNELNAME": 'channel',
        "ROLE": 'admin',
      }
    end

    it 'is not support sensitive' do
      expect {
        AgoraDynamicKey::RTCTokenBuilder.build_token_with_account(sensitive_params)
      }.to raise_error(AgoraDynamicKey::RTCTokenBuilder::InvalidParamsError, "missing params")
    end
  end

  describe 'Sign' do

    let(:token_payload) do
      {
        app_id: '970CA35de60c44645bbae8a215061b33',
        app_certificate: '5CFd2fd1755d40ecb72977518be15d3b',
        channel_name: '7d72365eb983485397e3e3f9d460bdda',
        uid: 2882341273,
        salt: 1,
        token_expired_ts: 1111111,
        privilege_expired_ts: 1446455471
      }
    end

    it 'decode return truthy' do
      access_token = AgoraDynamicKey::AccessToken.new(token_payload)
      access_token.add_privilege AgoraDynamicKey::Privilege::JOIN_CHANNEL, access_token.privilege_expired_ts
      access_token.salt = token_payload[:salt]
      access_token.expired_ts = token_payload[:token_expired_ts]
      token = access_token.build
      expect(AgoraDynamicKey::Sign.decode!(token)).to be_truthy
    end
  end

  describe 'AccessToken' do

    let(:token_payload) do
      {
        app_id: '970CA35de60c44645bbae8a215061b33',
        app_certificate: '5CFd2fd1755d40ecb72977518be15d3b',
        channel_name: '7d72365eb983485397e3e3f9d460bdda',
        uid: 2882341273,
        salt: 1,
        token_expired_ts: 1111111,
        privilege_expired_ts: 1446455471
      }
    end

    let(:payload) do
      token_payload.select {|e| [:app_id, :app_certificate, :channel_name, :uid, :privilege_expired_ts].include? e}
    end

    let(:expected_result) do
      "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW"
    end

    let(:rtc_token) do
      "006970CA35de60c44645bbae8a215061b33IACMv3I+fsRSejxy6luEwzA/1t/zbEHWfJCJ5m8ssFP/fLdIfRBXoFHlIgABAAAAR/QQAAQAAQCvKDdWAgCvKDdWAwCvKDdWBACvKDdW"
    end

    it 'generate with privilege equal rtc_token' do
      token = AgoraDynamicKey::AccessToken.generate!(payload) do |t|
        t.add_privilege AgoraDynamicKey::Privilege::JOIN_CHANNEL, t.privilege_expired_ts
        t.add_privilege AgoraDynamicKey::Privilege::PUBLISH_AUDIO_STREAM, t.privilege_expired_ts
        t.add_privilege AgoraDynamicKey::Privilege::PUBLISH_VIDEO_STREAM, t.privilege_expired_ts
        t.add_privilege AgoraDynamicKey::Privilege::PUBLISH_DATA_STREAM, t.privilege_expired_ts
        t.salt = token_payload[:salt]
        t.expired_ts = token_payload[:token_expired_ts]
      end
      expect(token).to eq(rtc_token)
    end

    it 'build equal expected_result' do
      access_token = AgoraDynamicKey::AccessToken.new(token_payload)
      access_token.add_privilege AgoraDynamicKey::Privilege::JOIN_CHANNEL, access_token.privilege_expired_ts
      access_token.salt = token_payload[:salt]
      access_token.expired_ts = token_payload[:token_expired_ts]
      expect(access_token.build).to eq(expected_result)
    end

  end
end