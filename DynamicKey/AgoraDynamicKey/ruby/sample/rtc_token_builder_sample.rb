require_relative '../lib/dynamic_key'

# Need to set environment variable AGORA_APP_ID
app_id = ENV['AGORA_APP_ID']
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV['AGORA_APP_CERTIFICATE']

expiration_time_in_seconds = 3600
current_time_stamps = Time.now.to_i

puts "App Id: #{app_id}"
puts "App Certificate: #{app_certificate}"
if !app_id || app_id == '' || !app_certificate || app_certificate == ''
  puts 'Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE'
  exit
end

params = {
  app_id: app_id,
  app_certificate: app_certificate,
  channel_name: '7d72365eb983485397e3e3f9d460bdda',
  uid: 2_882_341_273,
  role: AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTCTokenBuilder.build_token_with_uid params
puts "Token With Int Uid: #{result}"

params_with_account = {
  app_id: app_id,
  app_certificate: app_certificate,
  channel_name: '7d72365eb983485397e3e3f9d460bdda',
  account: 'test_user',
  role: AgoraDynamicKey::RTCTokenBuilder::Role::PUBLISHER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTCTokenBuilder.build_token_with_account params_with_account
puts "Token With UserAccount: #{result}"
