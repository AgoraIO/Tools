package test

import (
	rtmtokenbuilder "RtmTokenBuilder"
	"testing"

	"../src/AccessToken"
)

func Test_RtmTokenBuilder(t *testing.T) {
	expected :=
		"006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW"

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	account := "test_user"
	expireTimestamp := uint32(1446455471)

	builder := rtmtokenbuilder.CreateRtmTokenBuilder(appID, appCertificate, account)
	builder.Token.Salt = uint32(1)
	builder.Token.Ts = uint32(1111111)
	builder.Token.Message[AccessToken.KLoginRtm] = expireTimestamp

	if result, err := builder.BuildToken(); err != nil {
		t.Error(err)
	} else {
		if result != expected {
			t.Error("Error ")
			t.Error(result)
		}
	}
}
