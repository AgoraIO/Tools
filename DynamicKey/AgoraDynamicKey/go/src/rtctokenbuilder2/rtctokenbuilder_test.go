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

    accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
    accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeRtc] != nil)
    accesstoken.AssertEqual(t, DataMockChannelName, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName)
    accesstoken.AssertEqual(t, DataMockUidStr, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid)
    accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

func Test_BuildTokenWithUid_RoleSubscriber(t *testing.T) {
    token, err := BuildTokenWithUid(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, RoleSubscriber, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
    accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeRtc] != nil)
    accesstoken.AssertEqual(t, DataMockChannelName, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName)
    accesstoken.AssertEqual(t, DataMockUidStr, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid)
    accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

func Test_BuildTokenWithAccount_RolePublisher(t *testing.T) {
    token, err := BuildTokenWithAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RolePublisher, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
    accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeRtc] != nil)
    accesstoken.AssertEqual(t, DataMockChannelName, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName)
    accesstoken.AssertEqual(t, DataMockAccount, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid)
    accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

func Test_BuildTokenWithAccount_RoleSubscriber(t *testing.T) {
    token, err := BuildTokenWithAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RoleSubscriber, DataMockExpire)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
    accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeRtc] != nil)
    accesstoken.AssertEqual(t, DataMockChannelName, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).ChannelName)
    accesstoken.AssertEqual(t, DataMockAccount, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Uid)
    accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Type)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
    accesstoken.AssertEqual(t, uint32(0), accessToken.Services[accesstoken.ServiceTypeRtc].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}
