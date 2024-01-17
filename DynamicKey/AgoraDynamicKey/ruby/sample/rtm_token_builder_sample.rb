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
  account: 'test_user_id',
  role: AgoraDynamicKey::RTMTokenBuilder::Role::RTM_USER,
  privilege_expired_ts: current_time_stamps + expiration_time_in_seconds
}

result = AgoraDynamicKey::RTMTokenBuilder.build_token params
puts "Rtm Token: #{result}"
