require_relative '../lib/dynamic_key'

expiration_time_in_seconds = 3600

current_time_stamps = Time.now.to_i

params = {
  app_id: '970CA35de60c44645bbae8a215061b33',
  app_certificate: '5CFd2fd1755d40ecb72977518be15d3b',
  account: "test_user_id",
  role: AgoraDynamicKey::RTMTokenBuilder::Role::RTM_USER,
  privilege_expired_ts: current_time_stamps - expiration_time_in_seconds
}

result = AgoraDynamicKey::RTMTokenBuilder.build_token params

puts "Rtm Token: #{result}"