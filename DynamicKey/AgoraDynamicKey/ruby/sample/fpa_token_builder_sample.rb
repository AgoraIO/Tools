require_relative '../lib/dynamic_key2'

# Need to set environment variable AGORA_APP_ID
app_id = ENV['AGORA_APP_ID']
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV['AGORA_APP_CERTIFICATE']

puts "App Id: #{app_id}"
puts "App Certificate: #{app_certificate}"
if !app_id || app_id == '' || !app_certificate || app_certificate == ''
  puts 'Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE'
  exit
end

token = AgoraDynamicKey2::FpaTokenBuilder.build_token(app_id, app_certificate)
puts "Token with FPA service: #{token}"
