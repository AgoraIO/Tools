package rtctokenbuilder

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/AccessToken"
	"testing"
)

func Test_RtcTokenBuilder(t *testing.T) {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uidZero := uint32(0)
	expiredTs := uint32(1446455471)
	result, err := BuildTokenWithUID(appID, appCertificate, channelName, uidZero, RoleSubscriber, expiredTs)

	if err != nil {
		t.Error(err)
	}

	token := accesstoken.AccessToken{}
	token.FromString(result)
	if token.Message[accesstoken.KJoinChannel] != expiredTs {
		t.Error("no kJoinChannel ts")
	}

	if token.Message[accesstoken.KPublishVideoStream] != 0 {
		t.Error("should not have publish video stream privilege")
	}
}
