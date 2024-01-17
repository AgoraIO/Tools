package main

import (
	"fmt"
	"os"

	"github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/fpatokenbuilder"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appId := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	fmt.Println("App Id:", appId)
	fmt.Println("App Certificate:", appCertificate)
	if appId == "" || appCertificate == "" {
		fmt.Println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
		return
	}

	result, err := fpatokenbuilder.BuildToken(appId, appCertificate)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with FPA service: %s\n", result)
	}
}
