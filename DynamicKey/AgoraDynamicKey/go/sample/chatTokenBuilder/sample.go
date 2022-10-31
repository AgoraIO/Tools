package main

import (
	"fmt"

	"github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/chatTokenBuilder"
)

func main() {
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	userUuid := "a7180cb0-1d4a-11ed-9210-89ff47c9da5e"
	expire := uint32(600)

	result, err := chatTokenBuilder.BuildChatAppToken(appID, appCertificate, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("ChatAppToken: %s\n", result)
	}

	result, err = chatTokenBuilder.BuildChatUserToken(appID, appCertificate, userUuid, expire)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("ChatUserToken: %s\n", result)
	}
}
