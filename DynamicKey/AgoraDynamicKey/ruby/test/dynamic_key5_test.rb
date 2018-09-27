require 'rspec'
require '../src/dynamic_key5'

describe 'Test DynamicKey5' do
  app_id = "970ca35de60c44645bbae8a215061b33"
  app_certificate = "5cfd2fd1755d40ecb72977518be15d3b"
  channel_name = "7d72365eb983485397e3e3f9d460bdda"
  unix_ts = 1446455472
  random_int = 58964981
  uid = 2882341273
  expired_ts = 1446455471

  it "test signature" do
    signature = DynamicKey5.gen_signature(
        DynamicKey5::RECORDING_SERVICE,
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts,
        {})
    puts "signature:#{signature}"
    expect(signature).equal? '929c9e46187a022baab26b7bf018438c675cfe1a'
  end

  it 'test_public sharing' do
    expected = "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
    actual = DynamicKey5.gen_public_sharing_key(
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts)
    puts "public sharing key:#{actual}"
    expect(actual).equal? expected
  end

  it 'test_recording' do
    expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
    actual = DynamicKey5.gen_recording_key(
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts)
    puts "public recording key:#{actual}"
    expect(actual).equal? expected
  end

  it 'test media channel key' do
    expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
    actual = DynamicKey5.gen_media_channel_key(
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts)
    puts "public media channel key:#{actual}"
    expect(actual).equal? expected
  end

  it 'test inChannelPermission key' do
    no_upload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw"
    actual = DynamicKey5.gen_in_channel_permission_key(
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts, DynamicKey5::NO_UPLOAD)
    puts "no_upload:#{no_upload}"
    expect(actual).equal? no_upload
    audio_video_upload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz"
    actual = DynamicKey5.gen_in_channel_permission_key(
        app_id,
        app_certificate,
        channel_name,
        unix_ts,
        random_int,
        uid,
        expired_ts, DynamicKey5::AUDIO_VIDEO_UPLOAD)
    puts "audio_video_upload:#{audio_video_upload}"
    expect(actual).equal? audio_video_upload
  end
end