package main

import (
	"fmt"
	"os"

	rtctokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
	stttokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/stttokenbuilder"
)

func main() {
	appId := os.Getenv("AGORA_APP_ID")
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	channelName := "stt-channel"
	rtcAccount := "stt-rtc-user"
	rtcRole := rtctokenbuilder.Role(rtctokenbuilder.RolePublisher)
	rtcTokenExpire := uint32(3600)
	joinChannelPrivilegeExpire := uint32(3600)
	pubAudioPrivilegeExpire := uint32(3600)
	pubVideoPrivilegeExpire := uint32(3600)
	pubDataStreamPrivilegeExpire := uint32(3600)
	rtmUserId := "stt-rtm-user"
	rtmTokenExpire := uint32(3600)

	fmt.Println("App Id:", appId)
	if appId == "" || appCertificate == "" {
		fmt.Println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
		return
	}

	result, err := stttokenbuilder.BuildToken(
		appId, appCertificate, channelName, rtcAccount, rtcRole, rtcTokenExpire,
		joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
		pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("STT token: %s\n", result)
	}
}
