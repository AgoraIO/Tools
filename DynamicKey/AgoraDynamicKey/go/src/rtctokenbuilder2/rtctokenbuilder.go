package rtctokenbuilder2

import (
    accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// Role type
type Role uint16

const (
    RolePublisher  = 1 // for live broadcaster
    RoleSubscriber = 2 // default, for live audience
)

// Build the RTC token with uid.
//
// appId:           The App ID issued to you by Agora. Apply for a new App ID from
//                  Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:  Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// channelName:     Unique channel name for the AgoraRTC session in the string format
// uid:             User ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1).
//                  optionalUid must be unique.
// role:            RolePublisher: A broadcaster/host in a live-broadcast profile.
//                  RoleSubscriber: An audience(default) in a live-broadcast profile.
// expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
//                  Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
// return The RTC token.
func BuildTokenWithUid(appId string, appCertificate string, channelName string, uid uint32, role Role, expire uint32) (string, error) {
    return BuildTokenWithAccount(appId, appCertificate, channelName, accesstoken.GetUidStr(uid), role, expire)
}

// Build the RTC token with account.
//
// appId:           The App ID issued to you by Agora. Apply for a new App ID from
//                  Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:  Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// channelName:     Unique channel name for the AgoraRTC session in the string format
// account:         The user's account, max length is 255 Bytes.
// role:            RolePublisher: A broadcaster/host in a live-broadcast profile.
//                  RoleSubscriber: An audience(default) in a live-broadcast profile.
// expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
//                  Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
// return The RTC token.
func BuildTokenWithAccount(appId string, appCertificate string, channelName string, account string, role Role, expire uint32) (string, error) {
    token := accesstoken.NewAccessToken(appId, appCertificate, expire)

    serviceRtc := accesstoken.NewServiceRtc(channelName, account)
    serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, expire)
    if role == RolePublisher {
        serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, expire)
        serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, expire)
        serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, expire)
    }
    token.AddService(serviceRtc)

    return token.Build()
}
