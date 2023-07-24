package main

import (
	"fmt"

	educationtokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/educationtokenbuilder"
)

func main() {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
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
