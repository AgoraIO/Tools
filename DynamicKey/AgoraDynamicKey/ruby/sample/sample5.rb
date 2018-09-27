require '../src/dynamic_key5'
app_id = "970ca35de60c44645bbae8a215061b33"
app_certificate = "5cfd2fd1755d40ecb72977518be15d3b"
channel_name = "7d72365eb983485397e3e3f9d460bdda"
unix_ts = Time.now.to_i
uid = 2882341273
random_int = rand(10000000)
expired_ts = 0

puts "%.8x" % (random_int & 0xFFFFFFFF)

recording_key = DynamicKey5.gen_recording_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts)
media_channel_key = DynamicKey5.gen_media_channel_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts)
public_sharing_key = DynamicKey5.gen_public_sharing_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts)
in_channel_permission_key1 = DynamicKey5.gen_in_channel_permission_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts, DynamicKey5::NO_UPLOAD)
in_channel_permission_key2 = DynamicKey5.gen_in_channel_permission_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts, DynamicKey5::AUDIO_VIDEO_UPLOAD)

puts "recording_key\t#{recording_key}"
puts "media_channel_key\t#{media_channel_key}"
puts "public_sharing_key\t#{public_sharing_key}"
puts "in_channel_permission_no_upload\t#{in_channel_permission_key1}"
puts "in_channel_permission_video_audio_upload\t#{in_channel_permission_key2}"
