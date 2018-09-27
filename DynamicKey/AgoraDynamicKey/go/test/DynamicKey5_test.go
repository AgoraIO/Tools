package test

import (
	"testing"

	"../src/DynamicKey5"
)

func Test_PublicSharingKey5(t *testing.T) {
	appID := "970ca35de60c44645bbae8a215061b33"
	appCertificate := "5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs := uint32(1446455472)
	uid := uint32(2882341273)
	randomInt := uint32(58964981)
	expiredTs := uint32(1446455471)
	key, err := DynamicKey5.GeneratePublicSharingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	if err != nil {
		t.Error(err)
	}
	expected := "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
	if key != expected {
		t.Error("Error")
		t.Error(key)
	}
}
func Test_RecordingKey5(t *testing.T) {
	appID := "970ca35de60c44645bbae8a215061b33"
	appCertificate := "5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs := uint32(1446455472)
	uid := uint32(2882341273)
	randomInt := uint32(58964981)
	expiredTs := uint32(1446455471)
	key, err := DynamicKey5.GenerateRecordingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	if err != nil {
		t.Error(err)
	}
	expected := "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
	if key != expected {
		t.Error("Error")
		t.Error(key)
	}
}
func Test_MediaChannelKey5(t *testing.T) {
	appID := "970ca35de60c44645bbae8a215061b33"
	appCertificate := "5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs := uint32(1446455472)
	uid := uint32(2882341273)
	randomInt := uint32(58964981)
	expiredTs := uint32(1446455471)
	key, err := DynamicKey5.GenerateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
	if err != nil {
		t.Error(err)
	}
	expected := "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA=="
	if key != expected {
		t.Error("Error ")
		t.Error(key)
	}
}

func Test_InChannelPermission(t *testing.T) {
	appID := "970ca35de60c44645bbae8a215061b33"
	appCertificate := "5cfd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	unixTs := uint32(1446455472)
	uid := uint32(2882341273)
	randomInt := uint32(58964981)
	expiredTs := uint32(1446455471)
	noUploadExpected := "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw"
	audioVideoUploadExpected := "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz"

	//no upload permission case
	if noUploadKey, err := DynamicKey5.GenerateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs,
		DynamicKey5.NoUpload); err != nil {
		t.Error(err)
	} else {
		if noUploadExpected != noUploadKey {
			t.Error("Error ")
			t.Error(noUploadKey)
		}
	}

	//audio video upload permission case
	if audioVideoUploadKey, err := DynamicKey5.GenerateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs,
		DynamicKey5.AudioVideoUpload); err != nil {
		t.Error(err)
	} else {
		if audioVideoUploadExpected != audioVideoUploadKey {
			t.Error("Error ")
			t.Error(audioVideoUploadKey)
		}
	}

}
