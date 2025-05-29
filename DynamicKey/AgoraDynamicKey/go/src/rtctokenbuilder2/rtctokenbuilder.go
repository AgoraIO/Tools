package rtctokenbuilder2

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// Role type
type Role uint16

const (
	// RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
	// your scenario does not require authentication for
	// [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
	RolePublisher = 1

	// Only use this role if your scenario require authentication for
	// [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
	// @note In order for this role to take effect, please contact our support team
	// to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
	// still has the same privileges as Role_Publisher.
	RoleSubscriber = 2
)

// BuildTokenWithUid Build the RTC token with uid.
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// @param channelName: Unique channel name for the AgoraRTC session in the string format
// @param uid: User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1). uid must be unique.
// @param role: RolePublisher: A broadcaster/host in a live-broadcast profile.
// RoleSubscriber: An audience(default) in a live-broadcast profile.
// @param tokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated,
// set tokenExpire as 600(seconds).
// @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
//
// return The RTC token.
func BuildTokenWithUid(appId string, appCertificate string, channelName string, uid uint32, role Role, tokenExpire uint32, privilegeExpire uint32) (string, error) {
	return BuildTokenWithUserAccount(appId, appCertificate, channelName, accesstoken.GetUidStr(uid), role, tokenExpire, privilegeExpire)
}

// BuildTokenWithUserAccount Build the RTC token with account.
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// @param channelName: Unique channel name for the AgoraRTC session in the string format
// @param account: The user's account, max length is 255 Bytes.
// @param role: RolePublisher: A broadcaster/host in a live-broadcast profile.
// RoleSubscriber: An audience(default) in a live-broadcast profile.
// @param tokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated,
// set tokenExpire as 600(seconds).
// @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
//
// return The RTC token.
func BuildTokenWithUserAccount(appId string, appCertificate string, channelName string, account string, role Role, tokenExpire uint32, privilegeExpire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, tokenExpire)

	serviceRtc := accesstoken.NewServiceRtc(channelName, account)
	serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, privilegeExpire)
	if role == RolePublisher {
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, privilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, privilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, privilegeExpire)
	}
	token.AddService(serviceRtc)

	return token.Build()
}

// BuildTokenWithUidAndPrivilege Generates an RTC token with the specified privilege.
//
// This method supports generating a token with the following privileges:
// - Joining an RTC channel.
// - Publishing audio in an RTC channel.
// - Publishing video in an RTC channel.
// - Publishing data streams in an RTC channel.
//
// The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
// enabled co-host authentication.
//
// A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
// The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
// or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
// the respective timestamp for each privilege in your app logic. After receiving the callback, you need
// to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
// the channel.
//
// @note
// Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
// Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
// When the token for joining the channel expires, the user is immediately kicked off the RTC channel
// and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
//
// @param appId The App ID of your Agora project.
// @param appCertificate The App Certificate of your Agora project.
// @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
// - All lowercase English letters: a to z.
// - All uppercase English letters: A to Z.
// - All numeric characters: 0 to 9.
// - The space character.
// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
// @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (2^32 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
// @param tokenExpire represented by the number of seconds elapsed since now. If, for example, you want to access the
// Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
// @param joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
// @param pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
// @param pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
// @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
//
// return The RTC token.
func BuildTokenWithUidAndPrivilege(appId string, appCertificate string, channelName string, uid uint32,
	tokenExpire uint32, joinChannelPrivilegeExpire uint32, pubAudioPrivilegeExpire uint32, pubVideoPrivilegeExpire uint32, pubDataStreamPrivilegeExpire uint32) (string, error) {
	return BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, accesstoken.GetUidStr(uid), tokenExpire,
		joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire, pubDataStreamPrivilegeExpire)
}

// BuildTokenWithUserAccountAndPrivilege Generates an RTC token with the specified privilege.
//
// This method supports generating a token with the following privileges:
// - Joining an RTC channel.
// - Publishing audio in an RTC channel.
// - Publishing video in an RTC channel.
// - Publishing data streams in an RTC channel.
//
// The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
// enabled co-host authentication.
//
// A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
// The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
// or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
// the respective timestamp for each privilege in your app logic. After receiving the callback, you need
// to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
// the channel.
//
// @note
// Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
// Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
// When the token for joining the channel expires, the user is immediately kicked off the RTC channel
// and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
//
// @param appId The App ID of your Agora project.
// @param appCertificate The App Certificate of your Agora project.
// @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
// - All lowercase English letters: a to z.
// - All uppercase English letters: A to Z.
// - All numeric characters: 0 to 9.
// - The space character.
// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
// @param account The user account.
// @param tokenExpire represented by the number of seconds elapsed since now. If, for example, you want to access the
// Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
// @param joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
// @param pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
// @param pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
// @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
//
// return The RTC token.
func BuildTokenWithUserAccountAndPrivilege(appId string, appCertificate string, channelName string, account string,
	tokenExpire uint32, joinChannelPrivilegeExpire uint32, pubAudioPrivilegeExpire uint32, pubVideoPrivilegeExpire uint32, pubDataStreamPrivilegeExpire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, tokenExpire)

	serviceRtc := accesstoken.NewServiceRtc(channelName, account)
	serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, joinChannelPrivilegeExpire)
	serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, pubAudioPrivilegeExpire)
	serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, pubVideoPrivilegeExpire)
	serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
	token.AddService(serviceRtc)

	return token.Build()
}

// BuildTokenWithRtm Build the RTC and RTM token with account.
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// @param channelName: Unique channel name for the AgoraRTC session in the string format
// @param account: The user's account, max length is 255 Bytes.
// @param role: RolePublisher: A broadcaster/host in a live-broadcast profile.
// RoleSubscriber: An audience(default) in a live-broadcast profile.
// @param tokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated,
// set tokenExpire as 600(seconds).
// @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
//
// return The RTC and RTM token.
func BuildTokenWithRtm(appId string, appCertificate string, channelName string, account string, role Role, tokenExpire uint32, privilegeExpire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, tokenExpire)

	serviceRtc := accesstoken.NewServiceRtc(channelName, account)
	serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, privilegeExpire)
	if role == RolePublisher {
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, privilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, privilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, privilegeExpire)
	}
	token.AddService(serviceRtc)

	serviceRtm := accesstoken.NewServiceRtm(account)
	serviceRtm.AddPrivilege(accesstoken.PrivilegeLogin, tokenExpire)
	token.AddService(serviceRtm)

	return token.Build()
}

// BuildTokenWithRtm2 Build the RTC and RTM token with account.
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// @param channelName: Unique channel name for the AgoraRTC session in the string format
// @param rtcAccount: The RTC user's account, max length is 255 Bytes.
// @param rtcRole: RolePublisher: A broadcaster/host in a live-broadcast profile.
// RoleSubscriber: An audience(default) in a live-broadcast profile.
// @param rtcTokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated, set rtcTokenExpire as 600(seconds).
// @param joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
// @param pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
// @param pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
// @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
// @param rtmUserId: The RTM user's account, max length is 255 Bytes.
// @param rtmTokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated, set rtmTokenExpire as 600(seconds).
//
// return The RTC and RTM token.
func BuildTokenWithRtm2(appId string, appCertificate string, channelName string, rtcAccount string, rtcRole Role, rtcTokenExpire uint32,
	joinChannelPrivilegeExpire uint32, pubAudioPrivilegeExpire uint32, pubVideoPrivilegeExpire uint32, pubDataStreamPrivilegeExpire uint32,
	rtmUserId string, rtmTokenExpire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, rtcTokenExpire)

	serviceRtc := accesstoken.NewServiceRtc(channelName, rtcAccount)
	serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, joinChannelPrivilegeExpire)
	if rtcRole == RolePublisher {
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, pubAudioPrivilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, pubVideoPrivilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
	}
	token.AddService(serviceRtc)

	serviceRtm := accesstoken.NewServiceRtm(rtmUserId)
	serviceRtm.AddPrivilege(accesstoken.PrivilegeLogin, rtmTokenExpire)
	token.AddService(serviceRtm)

	return token.Build()
}
