package rtmtokenbuilder2

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
	"testing"
)

const (
	DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
	DataMockExpire         = uint32(900)
	DataMockUserId         = "test_user"
)

func Test_BuildToken(t *testing.T) {
	token, err := BuildToken(DataMockAppId, DataMockAppCertificate, DataMockUserId, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeRtm] != nil)
	accesstoken.AssertEqual(t, DataMockUserId, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).UserId)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtm), accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
}
