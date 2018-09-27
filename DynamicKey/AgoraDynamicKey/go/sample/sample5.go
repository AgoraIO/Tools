package main

import (
    "../src/DynamicKey5"
    "fmt"
)

func main() {
    appID:="970ca35de60c44645bbae8a215061b33"
    appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
    channelName := "7d72365eb983485397e3e3f9d460bdda"
    unixTs:=uint32(1446455472)
    uid:=uint32(2882341273)
    randomInt:=uint32(58964981)
    expiredTs:=uint32(1446455471)
    var publicSharingKey,sharingError = DynamicKey5.GeneratePublicSharingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
    if sharingError == nil {
        fmt.Println(publicSharingKey)
    }

    var mediaChannelKey,channelError = DynamicKey5.GenerateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
    if channelError == nil {
        fmt.Println(mediaChannelKey)
    }

    var recordingKey,recordingError = DynamicKey5.GenerateRecordingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
    if recordingError == nil {
        fmt.Println(recordingKey)
    }

    var noUploadKey,noUploadError = DynamicKey5.GenerateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, DynamicKey5.NoUpload)
    if noUploadError == nil {
        fmt.Println(noUploadKey)
    }

    var audioVideoUploadKey,audioVideoUploadError = DynamicKey5.GenerateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, DynamicKey5.AudioVideoUpload)
    if audioVideoUploadError == nil {
        fmt.Println(audioVideoUploadKey)
    }
}

