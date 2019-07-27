require 'rspec'
require_relative '../lib/dynamic_key'

describe 'AgoraDynamicKey::RTMTokenBuilder' do

  let(:rtm_token_params) do
    {
      app_id: "970CA35de60c44645bbae8a215061b33",
      app_certificate: "5CFd2fd1755d40ecb72977518be15d3b",
      account: "test_user",
      salt: 1,
      role: AgoraDynamicKey::RTMTokenBuilder::Role::RTM_USER,
      privilege_expired_ts: 1446455471
    }
  end

  let(:valid_token) do
    "006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW"
  end

  context 'build_token' do

    it 'should equal valid token' do
      # token = AgoraDynamicKey::RTMTokenBuilder.build_token rtm_token_params
      token = AgoraDynamicKey::AccessToken.new rtm_token_params.merge(:channel_name => rtm_token_params[:account])
      token.salt = 1
      token.expired_ts = 1111111
      token.grant AgoraDynamicKey::Privilege::RTM_LOGIN, rtm_token_params[:privilege_expired_ts]
      result = token.build!
      expect(result).to eq(valid_token)
    end
  end
end