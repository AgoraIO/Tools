package test

import (
	"../src/DynamicKey4"
     "testing"
)

func Test_PublicSharingKey(t *testing.T) {
	appID:="970ca35de60c44645bbae8a215061b33"
	appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs:=uint32(1446455472)
	uid:=uint32(2882341273)
	randomInt:=uint32(58964981)
	expiredTs:=uint32(1446455471)
	key := DynamicKey4.GeneratePublicSharingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	expected := "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
	if key != expected {
         t.Error("Error")
         t.Error(key)
	}
}
func Test_RecordingKey(t *testing.T) {
	appID:="970ca35de60c44645bbae8a215061b33"
	appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs:=uint32(1446455472)
	uid:=uint32(2882341273)
	randomInt:=uint32(58964981)
	expiredTs:=uint32(1446455471)
	key := DynamicKey4.GenerateRecordingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	expected := "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
	if key != expected {
         t.Error("Error")
         t.Error(key)
	}
}
func Test_MediaChannelKey(t *testing.T) {
	appID:="970ca35de60c44645bbae8a215061b33"
	appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs:=uint32(1446455472)
	uid:=uint32(2882341273)
	randomInt:=uint32(58964981)
	expiredTs:=uint32(1446455471)
	key := DynamicKey4.GenerateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	expected := "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471"
	if key != expected {
         t.Error("Error ")
         t.Error(key)
	}
}
