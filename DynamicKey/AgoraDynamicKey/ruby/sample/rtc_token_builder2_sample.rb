require_relative '../lib/dynamic_key2'

app_id = '970CA35de60c44645bbae8a215061b33'
app_certificate = '5CFd2fd1755d40ecb72977518be15d3b'
channel_name = '7d72365eb983485397e3e3f9d460bdda'
uid = 2_882_341_273
account = '2882341273'
token_expiration_in_seconds = 3600
privilege_expiration_in_seconds = 3600
join_channel_privilege_expiration_in_seconds = 3600
pub_audio_privilege_expiration_in_seconds = 3600
pub_video_privilege_expiration_in_seconds = 3600
pub_data_stream_privilege_expiration_in_seconds = 3600

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid(
  app_id, app_certificate, channel_name, uid,
  AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, token_expiration_in_seconds, privilege_expiration_in_seconds
)
puts "Token with int uid: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(
  app_id, app_certificate, channel_name, account,
  AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, token_expiration_in_seconds, privilege_expiration_in_seconds
)
puts "Token with user account: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid_and_privilege(
  app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
  join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
  pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds
)
puts "Token with int uid and privilege: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account_and_privilege(
  app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
  join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
  pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds
)
puts "Token with user account and privilege: #{token}"
