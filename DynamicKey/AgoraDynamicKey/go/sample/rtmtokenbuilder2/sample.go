package main

import (
    "fmt"
    rtmtokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtmtokenbuilder2"
)

func main() {
    appID := "970CA35de60c44645bbae8a215061b33"
    appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"
    userId := "test_user_id"
    expirationInSeconds := uint32(3600)

    result, err := rtmtokenbuilder.BuildToken(appID, appCertificate, userId, expirationInSeconds)
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Printf("Rtm Token: %s\n", result)
    }
}
