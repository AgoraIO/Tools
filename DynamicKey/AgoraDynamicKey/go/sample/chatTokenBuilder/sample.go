package main

import (
	"fmt"
	"os"

	"github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/chatTokenBuilder"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appID := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

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
