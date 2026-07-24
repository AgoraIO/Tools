package apaastokenbuilder

import (
	"testing"

	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

const (
	DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
	DataMockRoomUuid       = "123"
	DataMockUserUuid       = "2882341273"
	DataMockRole           = int16(1)
	DataMockExpire         = uint32(600)
)

// Test_BuildRoomUserToken verifies APaaS room-user token contents and privileges.
func Test_BuildRoomUserToken(t *testing.T) {
	token, err := BuildRoomUserToken(DataMockAppId, DataMockAppCertificate, DataMockRoomUuid, DataMockUserUuid, DataMockRole, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0] != nil)
	accesstoken.AssertEqual(t, DataMockRoomUuid, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, DataMockUserUuid, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, DataMockRole, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasRoomUser])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeChat)[0].(*accesstoken.ServiceChat).Privileges[accesstoken.PrivilegeChatUser])
}

// Test_BuildUserToken verifies APaaS user token contents and privileges.
func Test_BuildUserToken(t *testing.T) {
	token, err := BuildUserToken(DataMockAppId, DataMockAppCertificate, DataMockUserUuid, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0] != nil)

	accesstoken.AssertEqual(t, DataMockUserUuid, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, "", accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, int16(-1), accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasUser])
}

// Test_BuildAppToken verifies APaaS app token contents and privileges.
func Test_BuildAppToken(t *testing.T) {
	token, err := BuildAppToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0] != nil)

	accesstoken.AssertEqual(t, "", accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, "", accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, int16(-1), accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeApaas)[0].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasApp])
}
