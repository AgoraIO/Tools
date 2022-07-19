package fpatokenbuilder

import (
    accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
    "testing"
)

const (
    DataMockAppCertificate       = "5CFd2fd1755d40ecb72977518be15d3b"
    DataMockAppId                = "970CA35de60c44645bbae8a215061b33"
    DataMockExpire               = uint32(24 * 3600)
    DataMockPrivilegeLoginExpire = uint32(0)
)

func Test_BuildToken(t *testing.T) {
    token, err := BuildToken(DataMockAppId, DataMockAppCertificate)
    accesstoken.AssertNil(t, err)

    accessToken := accesstoken.CreateAccessToken()
    accessToken.Parse(token)

    accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
    accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
    accesstoken.AssertEqual(t, true, accessToken.Services[accesstoken.ServiceTypeFpa] != nil)
    accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeFpa), accessToken.Services[accesstoken.ServiceTypeFpa].(*accesstoken.ServiceFpa).Type)
    accesstoken.AssertEqual(t, DataMockPrivilegeLoginExpire, accessToken.Services[accesstoken.ServiceTypeFpa].(*accesstoken.ServiceFpa).Privileges[accesstoken.PrivilegeLogin])
}
