package test

import (
	"../src/AccessToken"
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

	token := AccessToken.CreateAccessToken(appID, appCertificate, channelName, uid)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[AccessToken.KJoinChannel] = expiredTs

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
	uid_zero := uint32(0)
	expiredTs = uint32(1446455471)

	token = AccessToken.CreateAccessToken(appID, appCertificate, channelName, uid_zero)
	token.Salt = uint32(1)
	token.Ts = uint32(1111111)
	token.Message[AccessToken.KJoinChannel] = expiredTs

	if result, err := token.Build(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}
}
