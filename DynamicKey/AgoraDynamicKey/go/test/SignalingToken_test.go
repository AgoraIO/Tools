package test

import (
	"../src/SignalingToken"
	 "testing"
)

func Test_SignalingToken(t *testing.T) {
	account := "2882341273"
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	now := uint32(1514133234)
	validTimeInSeconds := uint32(3600*24)
	expiredTsInSeconds := now + validTimeInSeconds

	token := SignalingToken.GenerateSignalingToken(account, appID, appCertificate, expiredTsInSeconds)
	expected := "1:970CA35de60c44645bbae8a215061b33:1514219634:82539e1f3973bcfe3f0d0c8993e6c051"
	if token != expected {
         t.Error("Error ")
         t.Error(token)
	}
}
