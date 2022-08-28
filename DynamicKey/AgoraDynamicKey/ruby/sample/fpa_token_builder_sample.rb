require_relative '../lib/dynamic_key2'

app_id = '970CA35de60c44645bbae8a215061b33'
app_certificate = '5CFd2fd1755d40ecb72977518be15d3b'

token = AgoraDynamicKey2::FpaTokenBuilder.build_token(app_id, app_certificate)
puts "Token with FPA service: #{token}"
