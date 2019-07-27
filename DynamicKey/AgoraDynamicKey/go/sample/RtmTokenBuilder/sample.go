package main

import (
	rtmtokenbuilder "RtmTokenBuilder"
	"fmt"
	"time"
)

func main() {

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	user := "test_user_id"
	expireTimeInSeconds := uint32(3600)
	currentTimestamp := uint32(time.Now().UTC().Unix())
	expireTimestamp := currentTimestamp + expireTimeInSeconds

	result, err := rtmtokenbuilder.BuildToken(appID, appCertificate, user, rtmtokenbuilder.RoleRtmUser, expireTimestamp)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Rtm Token: %s\n", result)
	}
}
