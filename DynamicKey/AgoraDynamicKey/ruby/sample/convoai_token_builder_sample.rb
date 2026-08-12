require_relative '../lib/dynamic_key2'

app_id = ENV['AGORA_APP_ID']
app_certificate = ENV['AGORA_APP_CERTIFICATE']

channel_name = '7d72365eb983485397e3e3f9d460bdda'
rtc_account = '2882341273'
rtc_role = AgoraDynamicKey2::RtcTokenBuilder::ROLE_PUBLISHER
rtc_token_expire = 3600
join_channel_privilege_expire = 3600
pub_audio_privilege_expire = 3600
pub_video_privilege_expire = 3600
pub_data_stream_privilege_expire = 3600
rtm_user_id = '2882341273'
rtm_token_expire = 3600

puts "App Id: #{app_id}"
if app_id.nil? || app_id.empty? || app_certificate.nil? || app_certificate.empty?
  puts 'Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE'
  exit
end

token = AgoraDynamicKey2::ConvoAITokenBuilder.build_token(
  app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
  join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
  pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire
)
puts "ConvoAI token: #{token}"
