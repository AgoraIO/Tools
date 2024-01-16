require_relative '../lib/dynamic_key'

expiration_time_in_seconds = 3600

current_time_stamps = Time.now.to_i

params = {
  # Need to set environment variable AGORA_APP_ID
  app_id: ENV['AGORA_APP_ID'],
  # Need to set environment variable AGORA_APP_CERTIFICATE
  app_certificate: ENV['AGORA_APP_CERTIFICATE'],
  channel_name: '7d72365eb983485397e3e3f9d460bdda',
  uid: 2_882_341_273,
  role: AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid params
puts "Token With Int Uid: #{result}"

params_with_account = {
  # Need to set environment variable AGORA_APP_ID
  app_id: ENV['AGORA_APP_ID'],
  # Need to set environment variable AGORA_APP_CERTIFICATE
  app_certificate: ENV['AGORA_APP_CERTIFICATE'],
  channel_name: '7d72365eb983485397e3e3f9d460bdda',
  account: 'test_user',
  role: AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTCTokenBuilder.build_token_with_account params_with_account

puts "Token With UserAccount: #{result}"
