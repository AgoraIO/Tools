package test

import (
	"../src/DynamicKey"
     "testing"
)

func Test_DynamicKey(t *testing.T) {
	appID:="970ca35de60c44645bbae8a215061b33"
	appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs:=uint32(1446455472)
	randomInt:=uint32(58964981)

	key := DynamicKey.Generate(appID, appCertificate, channelName, unixTs, randomInt)
	expected := "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5"
	if key != expected {
         t.Error("Error ")
         t.Error(key)
	}
}
