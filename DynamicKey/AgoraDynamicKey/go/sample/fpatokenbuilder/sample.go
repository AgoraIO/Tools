package main

import (
	"fmt"
	"os"

	"github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/fpatokenbuilder"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appID := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	result, err := fpatokenbuilder.BuildToken(appID, appCertificate)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with FPA service: %s\n", result)
	}
}
