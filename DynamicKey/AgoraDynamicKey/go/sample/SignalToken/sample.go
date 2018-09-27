package main

import (
	"../../src/SignalingToken"
    "time"
    "fmt"
)

func main() {
	account := "2882341273"
	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	now := uint32(time.Now().Unix())
	validTimeInSeconds := uint32(3600*24)
	expiredTsInSeconds := now + validTimeInSeconds

	token := SignalingToken.GenerateSignalingToken(account, appID, appCertificate, expiredTsInSeconds)
	fmt.Println("token = " + token)
}

