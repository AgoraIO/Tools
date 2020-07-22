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

    accesstoken.AssertEqual(t, accessToken.AppId, DataMockAppId)
    accesstoken.AssertEqual(t, accessToken.Expire, DataMockExpire)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtm] != nil, true)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).UserId, DataMockUserId)
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).Type, uint16(accesstoken.ServiceTypeRtm))
    accesstoken.AssertEqual(t, accessToken.Services[accesstoken.ServiceTypeRtm].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin], DataMockExpire)
}
