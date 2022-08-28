require_relative '../lib/dynamic_key2'

app_id = '970CA35de60c44645bbae8a215061b33'
app_certificate = '5CFd2fd1755d40ecb72977518be15d3b'
room_uuid = '123'
user_uuid = '2882341273'
role = 1
token_expiration_in_seconds = 3600

token = AgoraDynamicKey2::EducationTokenBuilder.build_room_user_token(app_id, app_certificate, room_uuid, user_uuid, role, token_expiration_in_seconds)
puts "Education room user token: #{token}"

token = AgoraDynamicKey2::EducationTokenBuilder.build_user_token(app_id, app_certificate, user_uuid, token_expiration_in_seconds)
puts "Education user token: #{token}"

token = AgoraDynamicKey2::EducationTokenBuilder.build_app_token(app_id, app_certificate, token_expiration_in_seconds)
puts "Education app token: #{token}"