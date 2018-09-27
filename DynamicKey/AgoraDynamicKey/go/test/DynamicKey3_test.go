package test

import (
	"../src/DynamicKey3"
     "testing"
)

func Test_DynamicKey3(t *testing.T) {
	appID:="970ca35de60c44645bbae8a215061b33"
	appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs:=uint32(1446455472)
	uid:=uint32(2882341273)
	randomInt:=uint32(58964981)
	expiredTs:=uint32(1446455471)
	key := DynamicKey3.Generate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	expected := "0037666966591a93ee5a3f712e22633f31f0cbc8f13970ca35de60c44645bbae8a215061b3314464554720383bbf528823412731446455471"
	if key != expected {
         t.Error("Error ")
         t.Error(key)
	}
}
