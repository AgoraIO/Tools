require_relative '../lib/dynamic_key2'

# Need to set environment variable AGORA_APP_ID
app_id = ENV.fetch('AGORA_APP_ID', nil)
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV.fetch('AGORA_APP_CERTIFICATE', nil)

room_uuid = '123'
user_uuid = '2882341273'
role = 1
token_expiration_in_seconds = 3600

puts "App Id: #{app_id}"
puts "App Certificate: #{app_certificate}"
if !app_id || app_id == '' || !app_certificate || app_certificate == ''
  puts 'Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE'
  exit
end

token = AgoraDynamicKey2::ApaasTokenBuilder.build_room_user_token(app_id, app_certificate, room_uuid, user_uuid,
                                                                  role, token_expiration_in_seconds)
puts "Apaas room user token: #{token}"

token = AgoraDynamicKey2::ApaasTokenBuilder.build_user_token(app_id, app_certificate, user_uuid,
                                                             token_expiration_in_seconds)
puts "Apaas user token: #{token}"

token = AgoraDynamicKey2::ApaasTokenBuilder.build_app_token(app_id, app_certificate, token_expiration_in_seconds)
puts "Apaas app token: #{token}"
