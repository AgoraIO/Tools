package rtctokenbuilder2

import (
	"testing"

	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

const (
	DataMockAccount                      = "2882341273"
	DataMockAppCertificate               = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId                        = "970CA35de60c44645bbae8a215061b33"
	DataMockChannelName                  = "7d72365eb983485397e3e3f9d460bdda"
	DataMockExpire                       = uint32(600)
	DataMockJoinChannelPrivilegeExpire   = uint32(600)
	DataMockPubAudioPrivilegeExpire      = uint32(600)
	DataMockPubVideoPrivilegeExpire      = uint32(600)
	DataMockPubDataStreamPrivilegeExpire = uint32(600)
	DataMockUid                          = uint32(2882341273)
	DataMockUidStr                       = "2882341273"
)

// Test_BuildTokenWithUid_RolePublisher verifies publisher privileges for a numeric UID.
func Test_BuildTokenWithUid_RolePublisher(t *testing.T) {
	token, err := BuildTokenWithUid(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, RolePublisher, DataMockExpire, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockUidStr, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// Test_BuildTokenWithUid_RoleSubscriber verifies subscriber privileges for a numeric UID.
func Test_BuildTokenWithUid_RoleSubscriber(t *testing.T) {
	token, err := BuildTokenWithUid(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, RoleSubscriber, DataMockExpire, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockUidStr, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// Test_BuildTokenWithUserAccount_RolePublisher verifies publisher privileges for a user account.
func Test_BuildTokenWithUserAccount_RolePublisher(t *testing.T) {
	token, err := BuildTokenWithUserAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RolePublisher, DataMockExpire, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockAccount, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// Test_BuildTokenWithUserAccount_RoleSubscriber verifies subscriber privileges for a user account.
func Test_BuildTokenWithUserAccount_RoleSubscriber(t *testing.T) {
	token, err := BuildTokenWithUserAccount(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, RoleSubscriber, DataMockExpire, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockAccount, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, uint32(0), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// Test_BuildTokenWithUidAndPrivilege verifies explicit privilege expirations for a numeric UID.
func Test_BuildTokenWithUidAndPrivilege(t *testing.T) {
	token, err := BuildTokenWithUidAndPrivilege(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockUid, DataMockExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire, DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockUidStr, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockJoinChannelPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, DataMockPubAudioPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, DataMockPubVideoPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, DataMockPubDataStreamPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// Test_BuildTokenWithUserAccountAndPrivilege verifies explicit privilege expirations for a user account.
func Test_BuildTokenWithUserAccountAndPrivilege(t *testing.T) {
	token, err := BuildTokenWithUserAccountAndPrivilege(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, DataMockExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire, DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0] != nil)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockAccount, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtc), accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Type)
	accesstoken.AssertEqual(t, DataMockJoinChannelPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, DataMockPubAudioPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, DataMockPubVideoPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, DataMockPubDataStreamPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
}

// TestBuildCombinedRtcRtmTokens verifies both combined-token builders and role branches.
func TestBuildCombinedRtcRtmTokens(t *testing.T) {
	tokens := make([]string, 0, 4)
	for _, role := range []Role{RolePublisher, RoleSubscriber} {
		token, err := BuildTokenWithRtm(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, role, DataMockExpire, DataMockExpire)
		accesstoken.AssertNil(t, err)
		tokens = append(tokens, token)

		token, err = BuildTokenWithRtm2(DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockAccount, role, DataMockExpire,
			1, 2, 3, 4, DataMockAccount, DataMockExpire)
		accesstoken.AssertNil(t, err)
		tokens = append(tokens, token)
	}

	for _, token := range tokens {
		parsed := accesstoken.CreateAccessToken()
		parsedOK, err := parsed.Parse(token)
		accesstoken.AssertNil(t, err)
		accesstoken.AssertEqual(t, true, parsedOK)
		accesstoken.AssertEqual(t, 1, len(parsed.GetServices(accesstoken.ServiceTypeRtc)))
		accesstoken.AssertEqual(t, 1, len(parsed.GetServices(accesstoken.ServiceTypeRtm)))
	}
}
