package rtctokenbuilder

import (
    "fmt"

    accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/AccessToken"
)

// Role Type
type Role uint16

// Role consts
const (
    RoleAttendee   = 0
    RolePublisher  = 1
    RoleSubscriber = 2
    RoleAdmin      = 101
)

//RtcTokenBuilder class
type RtcTokenBuilder struct {
}

//BuildTokenWithUserAccount method
// appID: The App ID issued to you by Agora. Apply for a new App ID from
//        Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:	Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// channelName:Unique channel name for the AgoraRTC session in the string format
// uid: User ID. A 32-bit unsigned integer with a value ranging from
//      1 to (232-1). optionalUid must be unique.
// role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
//       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
// privilegeExpireTs: represented by the number of seconds elapsed since
//                    1/1/1970. If, for example, you want to access the
//                    Agora Service within 10 minutes after the token is
//                    generated, set expireTimestamp as the current
//                    timestamp + 600 (seconds)./
func BuildTokenWithUserAccount(appID string, appCertificate string, channelName string, userAccount string, role Role, privilegeExpiredTs uint32) (string, error) {
    token := accesstoken.CreateAccessToken2(appID, appCertificate, channelName, userAccount)
    token.AddPrivilege(accesstoken.KJoinChannel, privilegeExpiredTs)

    if (role == RoleAttendee) || (role == RolePublisher) || (role == RoleAdmin) {
        token.AddPrivilege(accesstoken.KPublishVideoStream, privilegeExpiredTs)
        token.AddPrivilege(accesstoken.KPublishAudioStream, privilegeExpiredTs)
        token.AddPrivilege(accesstoken.KPublishDataStream, privilegeExpiredTs)
    }
    return token.Build()
}

//BuildTokenWithUID method
// appID: The App ID issued to you by Agora. Apply for a new App ID from
//        Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:	Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// channelName:Unique channel name for the AgoraRTC session in the string format
// userAccount: The user account.
// role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
//       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
// privilegeExpireTs: represented by the number of seconds elapsed since
//                    1/1/1970. If, for example, you want to access the
//                    Agora Service within 10 minutes after the token is
//                    generated, set expireTimestamp as the current
func BuildTokenWithUID(appID string, appCertificate string, channelName string, uid uint32, role Role, privilegeExpiredTs uint32) (string, error) {
    uidStr := fmt.Sprint(uid)
    if uid == 0 {
        uidStr = ""
    }
    return BuildTokenWithUserAccount(appID, appCertificate, channelName, uidStr, role, privilegeExpiredTs)
}

/**
* Generates an RTC token with the specified privilege.
*
* This method supports generating a token with the following privileges:
* - Joining an RTC channel.
* - Publishing audio in an RTC channel.
* - Publishing video in an RTC channel.
* - Publishing data streams in an RTC channel.
*
* The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
* enabled co-host authentication.
*
* A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
* The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
* or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
* the respective timestamp for each privilege in your app logic. After receiving the callback, you need
* to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
* the channel.
*
* @note
* Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
* Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
* When the token for joining the channel expires, the user is immediately kicked off the RTC channel
* and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
*
* @param appId The App ID of your Agora project.
* @param appCertificate The App Certificate of your Agora project.
* @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
* - All lowercase English letters: a to z.
* - All uppercase English letters: A to Z.
* - All numeric characters: 0 to 9.
* - The space character.
* - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
* @param userAccount The user account.
* @param joinChannelPrivilegeExpiredTs The Unix timestamp when the privilege for joining the channel expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set joinChannelPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes.
* @param pubAudioPrivilegeExpiredTs The Unix timestamp when the privilege for publishing audio expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubAudioPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubAudioPrivilegeExpiredTs as the current Unix timestamp.
* @param pubVideoPrivilegeExpiredTs The Unix timestamp when the privilege for publishing video expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubVideoPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubVideoPrivilegeExpiredTs as the current Unix timestamp.
* @param pubDataStreamPrivilegeExpiredTs The Unix timestamp when the privilege for publishing data streams expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubDataStreamPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubDataStreamPrivilegeExpiredTs as the current Unix timestamp.
 */

func BuildTokenWithUserAccountAndPrivilege(appID string, appCertificate string,
    channelName string, userAccount string,
    joinChannelPrivilegeExpiredTs uint32,
    pubAudioPrivilegeExpiredTs uint32,
    pubVideoPrivilegeExpiredTs uint32,
    pubDataStreamPrivilegeExpiredTs uint32) (string, error) {

    tokenGenerator := accesstoken.CreateAccessToken2(appID, appCertificate, channelName, userAccount)
    tokenGenerator.AddPrivilege(accesstoken.KJoinChannel, joinChannelPrivilegeExpiredTs)
    tokenGenerator.AddPrivilege(accesstoken.KPublishVideoStream, pubVideoPrivilegeExpiredTs)
    tokenGenerator.AddPrivilege(accesstoken.KPublishAudioStream, pubAudioPrivilegeExpiredTs)
    tokenGenerator.AddPrivilege(accesstoken.KPublishDataStream, pubDataStreamPrivilegeExpiredTs)
    return tokenGenerator.Build()
}

/**
* Generates an RTC token with the specified privilege.
*
* This method supports generating a token with the following privileges:
* - Joining an RTC channel.
* - Publishing audio in an RTC channel.
* - Publishing video in an RTC channel.
* - Publishing data streams in an RTC channel.
*
* The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
* enabled co-host authentication.
*
* A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
* The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
* or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
* the respective timestamp for each privilege in your app logic. After receiving the callback, you need
* to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
* the channel.
*
* @note
* Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
* Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
* When the token for joining the channel expires, the user is immediately kicked off the RTC channel
* and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
*
* @param appId The App ID of your Agora project.
* @param appCertificate The App Certificate of your Agora project.
* @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
* - All lowercase English letters: a to z.
* - All uppercase English letters: A to Z.
* - All numeric characters: 0 to 9.
* - The space character.
* - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
* @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (232 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
* @param joinChannelPrivilegeExpiredTs The Unix timestamp when the privilege for joining the channel expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set joinChannelPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes.
* @param pubAudioPrivilegeExpiredTs The Unix timestamp when the privilege for publishing audio expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubAudioPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubAudioPrivilegeExpiredTs as the current Unix timestamp.
* @param pubVideoPrivilegeExpiredTs The Unix timestamp when the privilege for publishing video expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubVideoPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubVideoPrivilegeExpiredTs as the current Unix timestamp.
* @param pubDataStreamPrivilegeExpiredTs The Unix timestamp when the privilege for publishing data streams expires, represented
* by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubDataStreamPrivilegeExpiredTs as the
* current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
* set pubDataStreamPrivilegeExpiredTs as the current Unix timestamp.
 */

func BuildTokenWithUIDAndPrivilege(appID string, appCertificate string, channelName string, uid uint32,
    joinChannelPrivilegeExpiredTs uint32, pubAudioPrivilegeExpiredTs uint32,
    pubVideoPrivilegeExpiredTs uint32,
    pubDataStreamPrivilegeExpiredTs uint32) (string, error) {
    uidStr := fmt.Sprint(uid)
    if uid == 0 {
        uidStr = ""
    }
    return BuildTokenWithUserAccountAndPrivilege(appID, appCertificate, channelName, uidStr, joinChannelPrivilegeExpiredTs,
        pubAudioPrivilegeExpiredTs, pubVideoPrivilegeExpiredTs, pubDataStreamPrivilegeExpiredTs)
}
