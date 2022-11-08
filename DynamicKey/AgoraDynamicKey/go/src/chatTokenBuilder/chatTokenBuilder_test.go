package chatTokenBuilder

import (
	"testing"

	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

const (
	DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
	DataMockUserUuid       = "2882341273"
	DataMockExpire         = uint32(600)
)

func Test_BuildChatUserToken(t *testing.T) {
	token, err := BuildChatUserToken(DataMockAppId, DataMockAppCertificate, DataMockUserUuid, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, DataMockUserUuid, accessToken.Services[accesstoken.ServiceTypeChat].(*accesstoken.ServiceChat).UserId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeChat].(*accesstoken.ServiceChat).Privileges[accesstoken.PrivilegeChatUser])
}

func Test_BuildChatAppToken(t *testing.T) {
	token, err := BuildChatAppToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	accessToken.Parse(token)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, DataMockExpire, accessToken.Services[accesstoken.ServiceTypeChat].(*accesstoken.ServiceChat).Privileges[accesstoken.PrivilegeChatApp])

}
