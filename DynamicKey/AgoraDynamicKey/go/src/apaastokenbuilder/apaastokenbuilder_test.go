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

func Test_BuildRoomUserToken(t *testing.T) {
	token, err := BuildRoomUserToken(DataMockAppId, DataMockAppCertificate, DataMockRoomUuid, DataMockUserUuid, DataMockRole, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeApaas] != nil)
	accesstoken.AssertEqual(t, DataMockRoomUuid, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, DataMockUserUuid, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, DataMockRole, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasRoomUser])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeChat].(*accesstoken.ServiceChat).Privileges[accesstoken.PrivilegeChatUser])
}

func Test_BuildUserToken(t *testing.T) {
	token, err := BuildUserToken(DataMockAppId, DataMockAppCertificate, DataMockUserUuid, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeApaas] != nil)

	accesstoken.AssertEqual(t, DataMockUserUuid, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, "", accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, int16(-1), accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasUser])
}

func Test_BuildAppToken(t *testing.T) {
	token, err := BuildAppToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeApaas] != nil)

	accesstoken.AssertEqual(t, "", accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).UserUuid)
	accesstoken.AssertEqual(t, "", accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).RoomUuid)
	accesstoken.AssertEqual(t, int16(-1), accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Role)

	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeApaas].(*accesstoken.ServiceApaas).Privileges[accesstoken.PrivilegeApaasApp])
}
