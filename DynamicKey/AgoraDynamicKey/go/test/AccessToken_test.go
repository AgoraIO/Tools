package test

import (
	rtmtokenbuilder "RtmTokenBuilder"
	"accesstoken"
	"rtctokenbuilder"
	"testing"
)

func Test_AccessToken(t *testing.T) {
	expected :=
		"006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW"

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	expiredTs := uint32(1446455471)

	token := accesstoken.CreateAccessToken(appID, appCertificate, channelName, uid)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[accesstoken.KJoinChannel] = expiredTs

	if result, err := token.Build(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}

	// test uid = 0
	expected =
		"006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW"

	appID = "970CA35de60c44645bbae8a215061b33"
	appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	channelName = "7d72365eb983485397e3e3f9d460bdda"
	uidZero := uint32(0)
	expiredTs = uint32(1446455471)

	token = accesstoken.CreateAccessToken(appID, appCertificate, channelName, uidZero)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[accesstoken.KJoinChannel] = expiredTs

	if result, err := token.Build(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}
}

func Test_RtcTokenBuilder(t *testing.T) {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uidZero := uint32(0)
	expiredTs := uint32(1446455471)
	result, err := rtctokenbuilder.BuildTokenWithUID(appID, appCertificate, channelName, uidZero, rtctokenbuilder.RoleSubscriber, expiredTs)

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

func Test_RtmTokenBuilder(t *testing.T) {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	userAccount := "test_user"
	expiredTs := uint32(1446455471)
	result, err := rtmtokenbuilder.BuildToken(appID, appCertificate, userAccount, rtmtokenbuilder.RoleRtmUser, expiredTs)

	if err != nil {
		t.Error(err)
	}

	token := accesstoken.AccessToken{}
	token.FromString(result)
	if token.Message[accesstoken.KLoginRtm] != expiredTs {
		t.Error("no kLoginRtm ts")
	}
}
