package main

import (
    "fmt"
    "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/fpatokenbuilder"
)

func main() {
    appID := "970CA35de60c44645bbae8a215061b33"
    appCertificate := "5CFd2fd1755d40ecb72977518be15d3b"

    result, err := fpatokenbuilder.BuildToken(appID, appCertificate)
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Printf("Token with FPA service: %s\n", result)
    }
}
