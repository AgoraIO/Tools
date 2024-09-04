package main

import (
	"fmt"
	"os"

	apaastokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/apaastokenbuilder"
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

	result, err := apaastokenbuilder.BuildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Apaas room user token: %s\n", result)
	}

	result, err = apaastokenbuilder.BuildUserToken(appId, appCertificate, userUuid, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Apaas user token: %s\n", result)
	}

	result, err = apaastokenbuilder.BuildAppToken(appId, appCertificate, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Apaas app token: %s\n", result)
	}
}
