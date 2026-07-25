package rtmtokenbuilder2

import (
	"reflect"
	"testing"

	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

const (
	DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
	DataMockExpire         = uint32(900)
	DataMockUserId         = "test_user"
)

// Test_BuildToken verifies RTM AccessToken2 contents and login privileges.
func Test_BuildToken(t *testing.T) {
	token, err := BuildToken(DataMockAppId, DataMockAppCertificate, DataMockUserId, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, true, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0] != nil)
	accesstoken.AssertEqual(t, DataMockUserId, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).UserId)
	accesstoken.AssertEqual(t, uint16(accesstoken.ServiceTypeRtm), accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).Type)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
}

// Test_BuildTokenWithPermissions verifies RTM2 resource-level permissions.
func Test_BuildTokenWithPermissions(t *testing.T) {
	permissions := accesstoken.NewRtm2Permissions()
	permissions.Add(accesstoken.Rtm2ResourceMessageChannels, accesstoken.Rtm2PermissionRead, []string{"message-a", "message-b"})
	permissions.Add(accesstoken.Rtm2ResourceStreamChannels, accesstoken.Rtm2PermissionWrite, []string{"stream-a"})

	token, err := BuildTokenWithPermissions(DataMockAppId, DataMockAppCertificate, DataMockUserId, permissions, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	parsed, err := accessToken.Parse(token)
	accesstoken.AssertNil(t, err)
	accesstoken.AssertEqual(t, true, parsed)

	rtm2 := accessToken.GetServices(accesstoken.ServiceTypeRtm2)[0].(*accesstoken.ServiceRtm2)
	accesstoken.AssertEqual(t, DataMockUserId, rtm2.UserId)
	accesstoken.AssertEqual(t, DataMockExpire, rtm2.Privileges[accesstoken.PrivilegeLogin])
	accesstoken.AssertEqual(t, true, reflect.DeepEqual(permissions.Details, rtm2.Permissions.Details))
}
