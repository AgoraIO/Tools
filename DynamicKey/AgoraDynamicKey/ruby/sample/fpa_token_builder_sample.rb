require_relative '../lib/dynamic_key2'

# Need to set environment variable AGORA_APP_ID
app_id = ENV['AGORA_APP_ID']
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV['AGORA_APP_CERTIFICATE']

token = AgoraDynamicKey2::FpaTokenBuilder.build_token(app_id, app_certificate)
puts "Token with FPA service: #{token}"
