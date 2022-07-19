package rtmtokenbuilder

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/AccessToken"
	"testing"
)

func Test_RtmTokenBuilder(t *testing.T) {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	userAccount := "test_user"
	expiredTs := uint32(1446455471)
	result, err := BuildToken(appID, appCertificate, userAccount, RoleRtmUser, expiredTs)

	if err != nil {
		t.Error(err)
	}

	token := accesstoken.AccessToken{}
	token.FromString(result)
	if token.Message[accesstoken.KLoginRtm] != expiredTs {
		t.Error("no kLoginRtm ts")
	}
}
