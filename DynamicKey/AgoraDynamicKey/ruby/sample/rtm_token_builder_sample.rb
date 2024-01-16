require_relative '../lib/dynamic_key'

expiration_time_in_seconds = 3600

current_time_stamps = Time.now.to_i

params = {
  # Need to set environment variable AGORA_APP_ID
  app_id: ENV['AGORA_APP_ID'],
  # Need to set environment variable AGORA_APP_CERTIFICATE
  app_certificate: ENV['AGORA_APP_CERTIFICATE'],
  account: 'test_user_id',
  role: AgoraDynamicKey::RTMTokenBuilder::Role::RTM_USER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTMTokenBuilder.build_token params

puts "Rtm Token: #{result}"
