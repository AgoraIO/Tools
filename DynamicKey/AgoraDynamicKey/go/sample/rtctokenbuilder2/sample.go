package main

import (
	"fmt"
	"os"

	rtctokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appId := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	uidStr := "2882341273"
	tokenExpirationInSeconds := uint32(3600)
	privilegeExpirationInSeconds := uint32(3600)
	joinChannelPrivilegeExpireInSeconds := uint32(3600)
	pubAudioPrivilegeExpireInSeconds := uint32(3600)
	pubVideoPrivilegeExpireInSeconds := uint32(3600)
	pubDataStreamPrivilegeExpireInSeconds := uint32(3600)

	fmt.Println("App Id:", appId)
	fmt.Println("App Certificate:", appCertificate)
	if appId == "" || appCertificate == "" {
		fmt.Println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
		return
	}

	result, err := rtctokenbuilder.BuildTokenWithUid(appId, appCertificate, channelName, uid, rtctokenbuilder.RolePublisher, tokenExpirationInSeconds, privilegeExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with int uid: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUserAccount(appId, appCertificate, channelName, uidStr, rtctokenbuilder.RolePublisher, tokenExpirationInSeconds, privilegeExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with user account: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUidAndPrivilege(appId, appCertificate, channelName, uid,
		tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with int uid and privilege: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, uidStr,
		tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with user account and privilege: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithRtm(appId, appCertificate, channelName, uidStr, rtctokenbuilder.RolePublisher, tokenExpirationInSeconds, privilegeExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with RTM: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithRtm2(appId, appCertificate, channelName, uidStr, rtctokenbuilder.RolePublisher, tokenExpirationInSeconds, privilegeExpirationInSeconds, pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds, uidStr, tokenExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with RTM: %s\n", result)
	}
}
