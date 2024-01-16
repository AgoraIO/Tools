package main

import (
	"fmt"
	"os"

	educationtokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/educationtokenbuilder"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appID := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	roomUuid := "123"
	userUuid := "2882341273"
	role := int16(1)
	expire := uint32(600)

	result, err := educationtokenbuilder.BuildRoomUserToken(appID, appCertificate, roomUuid, userUuid, role, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("RoomUserToken: %s\n", result)
	}

	result, err = educationtokenbuilder.BuildUserToken(appID, appCertificate, userUuid, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("UserToken: %s\n", result)
	}

	result, err = educationtokenbuilder.BuildAppToken(appID, appCertificate, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("AppToken: %s\n", result)
	}
}
