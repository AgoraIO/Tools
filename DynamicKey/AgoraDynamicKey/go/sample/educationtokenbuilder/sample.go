package main

import (
	"fmt"
	"os"

	educationtokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/educationtokenbuilder"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appId := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	roomUuid := "123"
	userUuid := "2882341273"
	role := int16(1)
	expire := uint32(600)

	fmt.Println("App Id:", appId)
	fmt.Println("App Certificate:", appCertificate)
	if appId == "" || appCertificate == "" {
		fmt.Println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
		return
	}

	result, err := educationtokenbuilder.BuildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Education room user token: %s\n", result)
	}

	result, err = educationtokenbuilder.BuildUserToken(appId, appCertificate, userUuid, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Education user token: %s\n", result)
	}

	result, err = educationtokenbuilder.BuildAppToken(appId, appCertificate, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Education app token: %s\n", result)
	}
}
