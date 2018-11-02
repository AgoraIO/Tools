package main

import (
	"../../src/SimpleTokenBuilder"
	"../../src/AccessToken"
    "fmt"
)

func main() {

	appID := "970CA35de60c44645bbae8a215061b33"
	appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	//if uid type is string, comment 14th, 21st line
	//And uncomment below 17th, 23rd line
	//uid := "2882341273"  

	expireTimestamp := uint32(0)

	builder := SimpleTokenBuilder.CreateSimpleTokenBuilder(appID, appCertificate, channelName, uid)
	//String uid
	//builder := SimpleTokenBuilder.CreateSimpleTokenBuilder2(appID, appCertificate, channelName, uid)

	builder.InitPrivileges(SimpleTokenBuilder.Role_Attendee)
	builder.SetPrivilege(AccessToken.KJoinChannel, expireTimestamp)
	builder.SetPrivilege(AccessToken.KPublishAudioStream, expireTimestamp)
	builder.SetPrivilege(AccessToken.KPublishVideoStream, expireTimestamp)
	builder.SetPrivilege(AccessToken.KPublishDataStream, expireTimestamp)

	result, err := builder.BuildToken()
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(result)
	}
}

