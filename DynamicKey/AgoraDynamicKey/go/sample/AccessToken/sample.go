package main

import (
	"../../src/AccessToken"
    "fmt"
)

func main() {

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	expireTimestamp := uint32(0)

	token := AccessToken.CreateAccessToken(appID, appCertificate, channelName, uid)
	token.AddPrivilege(AccessToken.KJoinChannel, expireTimestamp)

	if result, err := token.Build(); err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(result)
	}
}

