require_relative '../lib/dynamic_key2'

# Need to set environment variable AGORA_APP_ID
app_id = ENV['AGORA_APP_ID']
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV['AGORA_APP_CERTIFICATE']

user_id = '2882341273'
token_expiration_in_seconds = 600

puts "App Id: #{app_id}"
puts "App Certificate: #{app_certificate}"
if !app_id || app_id == '' || !app_certificate || app_certificate == ''
  puts 'Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE'
  exit
end

token = AgoraDynamicKey2::ChatTokenBuilder.build_user_token(app_id, app_certificate, user_id,
                                                            token_expiration_in_seconds)
puts "Chat user token : #{token}"

token = AgoraDynamicKey2::ChatTokenBuilder.build_app_token(app_id, app_certificate, token_expiration_in_seconds)
puts "Chat app token: #{token}"
