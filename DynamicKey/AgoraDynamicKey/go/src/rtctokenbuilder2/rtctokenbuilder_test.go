package rtctokenbuilder2

import (
    accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
    "testing"
)

const (
    DataMockAccount        = "^ZSgT<%q:Fj*@`92>#OHL?\"hkm~nGYiP"
    DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
    DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
    DataMockChannelName    = "7d72365eb983485397e3e3f9d460bdda"
    DataMockExpire         = uint32(600)
    DataMockUid            = uint32(2882341273)
    DataMockUidStr         = "2882341273"
)

func Test_BuildTokenWithUid_RolePublisher(t *testing.T) {
    token, err := BuildTokenWithUid(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, RolePublisher, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, accessToken.AppId, DataMockAppId)
    accesstoken.AssertEqual(t, accessToken.Expire, DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc] != nil, true)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName , DataMockChannelName)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid , DataMockUidStr)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type , uint16(accesstoken.ServiceTypeRtc))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream], DataMockExpire)
}

func Test_BuildTokenWithUid_RoleSubscriber(t *testing.T) {
    token, err := BuildTokenWithUid(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, RoleSubscriber, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, accessToken.AppId, DataMockAppId)
    accesstoken.AssertEqual(t, accessToken.Expire, DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc] != nil, true)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName , DataMockChannelName)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid , DataMockUidStr)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type , uint16(accesstoken.ServiceTypeRtc))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream], uint32(0))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream], uint32(0))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream], uint32(0))
}


func Test_BuildTokenWithAccount_RolePublisher(t *testing.T) {
    token, err := BuildTokenWithAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RolePublisher, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, accessToken.AppId, DataMockAppId)
    accesstoken.AssertEqual(t, accessToken.Expire, DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc] != nil, true)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName , DataMockChannelName)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid , DataMockAccount)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type , uint16(accesstoken.ServiceTypeRtc))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream], DataMockExpire)
}

func Test_BuildTokenWithAccount_RoleSubscriber(t *testing.T) {
    token, err := BuildTokenWithAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RoleSubscriber, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, accessToken.AppId, DataMockAppId)
    accesstoken.AssertEqual(t, accessToken.Expire, DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc] != nil, true)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName , DataMockChannelName)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid , DataMockAccount)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type , uint16(accesstoken.ServiceTypeRtc))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel], DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream], uint32(0))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream], uint32(0))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream], uint32(0))
}