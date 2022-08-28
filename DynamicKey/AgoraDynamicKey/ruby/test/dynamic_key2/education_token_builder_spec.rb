require 'rspec'
require_relative '../../lib/dynamic_key2'

describe 'AgoraDynamicKey2::EducationTokenBuilder' do
  let(:app_id) { '970CA35de60c44645bbae8a215061b33' }
  let(:app_certificate) { '5CFd2fd1755d40ecb72977518be15d3b' }
  let(:room_uuid) { '123' }
  let(:user_uuid) { '2882341273' }
  let(:role) { 1 }
  let(:expire) { 600 }

  it 'test_build_room_user_token' do
    token = AgoraDynamicKey2::EducationTokenBuilder.build_room_user_token(app_id, app_certificate, room_uuid, user_uuid, role, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].room_uuid).to eq(room_uuid)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].user_uuid).to eq(user_uuid)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].role).to eq(role)
    expect(access_token.services.size).to eq(3)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_ROOM_USER]).to eq(600)
    expect(access_token.services[AgoraDynamicKey2::ServiceRtm::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceRtm::PRIVILEGE_JOIN_LOGIN]).to eq(600)
    expect(access_token.services[AgoraDynamicKey2::ServiceChat::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceChat::PRIVILEGE_USER]).to eq(600)
  end

  it 'test_build_user_token' do
    token = AgoraDynamicKey2::EducationTokenBuilder.build_user_token(app_id, app_certificate, user_uuid, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].room_uuid).to eq('')
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].user_uuid).to eq(user_uuid)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].role).to eq(-1)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_ROOM_USER]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_USER]).to eq(600)
  end

  it 'test_build_app_token' do
    token = AgoraDynamicKey2::EducationTokenBuilder.build_app_token(app_id, app_certificate, expire)
    access_token = AgoraDynamicKey2::AccessToken.new
    res = access_token.parse(token)

    expect(res).to eq(true)
    expect(access_token.app_id).to eq(app_id)
    expect(access_token.expire).to eq(expire)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].room_uuid).to eq('')
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].user_uuid).to eq('')
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].role).to eq(-1)
    expect(access_token.services.size).to eq(1)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].type).to eq(AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_ROOM_USER]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_USER]).to eq(nil)
    expect(access_token.services[AgoraDynamicKey2::ServiceEducation::SERVICE_TYPE].privileges[AgoraDynamicKey2::ServiceEducation::PRIVILEGE_APP]).to eq(600)
  end
end
