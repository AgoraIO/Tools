package main

import (
	"fmt"

	"../../src/AccessToken"
	rtmtokenbuilder "../../src/RtmTokenBuilder"
)

func main() {

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	account := "testaccount"

	expireTimestamp := uint32(0)

	builder := rtmtokenbuilder.CreateRtmTokenBuilder(appID, appCertificate, account)
	//String uid
	//builder := SimpleTokenBuilder.CreateSimpleTokenBuilder2(appID, appCertificate, channelName, uid)
	builder.SetPrivilege(AccessToken.KLoginRtm, expireTimestamp)

	result, err := builder.BuildToken()
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(result)
	}
}
