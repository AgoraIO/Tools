package main

import (
	"fmt"
	"os"

	rtmtokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtmtokenbuilder2"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appID := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	userId := "test_user_id"
	expirationInSeconds := uint32(3600)

	result, err := rtmtokenbuilder.BuildToken(appID, appCertificate, userId, expirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Rtm Token: %s\n", result)
	}
}
