package convoaitokenbuilder

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
	rtctokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
)

// BuildToken builds a ConvoAI token with RTC and RTM services.
//
// @param appId: The App ID issued to you by Agora.
// @param appCertificate: Certificate of the application registered in the Agora Dashboard.
// @param channelName: The unique channel name for the Agora RTC session in string format. The string length
// must be less than 64 bytes. The channel name may contain the following characters:
// - All lowercase English letters: a to z.
// - All uppercase English letters: A to Z.
// - All numeric characters: 0 to 9.
// - The space character.
// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
// @param account: The account used by both RTC and RTM, max length is 255 bytes.
// @param tokenExpire: The whole token lifetime in seconds from now.
// @param privilegeExpire: The RTC and RTM privilege lifetime in seconds from now. It must not exceed
// tokenExpire; otherwise, it is limited by the token expiration time.
//
// return The ConvoAI token.
func BuildToken(appId string, appCertificate string, channelName string, account string, tokenExpire uint32,
	privilegeExpire uint32) (string, error) {
	return BuildTokenWithPrivilege(
		appId, appCertificate, channelName, account, rtctokenbuilder.RolePublisher, tokenExpire,
		privilegeExpire, privilegeExpire, privilegeExpire, privilegeExpire, account, privilegeExpire)
}

// BuildTokenWithPrivilege builds a ConvoAI token with RTC and RTM services.
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from
// Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in
// the Agora Dashboard. See Get an App Certificate.
// @param channelName: The unique channel name for the Agora RTC session in string format. The string length
// must be less than 64 bytes. The channel name may contain the following characters:
// - All lowercase English letters: a to z.
// - All uppercase English letters: A to Z.
// - All numeric characters: 0 to 9.
// - The space character.
// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
// @param rtcAccount: The RTC user's account, max length is 255 Bytes.
// @param rtcRole: RolePublisher: A broadcaster or host in a live-broadcast profile.
// RoleSubscriber: An audience member in a live-broadcast profile.
// @param rtcTokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated,
// set rtcTokenExpire as 600(seconds). This is the whole token expiration. The whole token is
// invalid after this time, even if a privilege expiration time is later.
// @param joinChannelPrivilegeExpire: represented by the number of seconds elapsed since now.
// If, for example, you want to join channel and expect stay in the channel for 10 minutes,
// set joinChannelPrivilegeExpire as 600(seconds). This value must not exceed rtcTokenExpire;
// otherwise, the privilege is limited by the token expiration time.
// @param pubAudioPrivilegeExpire: represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish audio privilege for 10 minutes,
// set pubAudioPrivilegeExpire as 600(seconds). This value must not exceed rtcTokenExpire;
// otherwise, the privilege is limited by the token expiration time.
// @param pubVideoPrivilegeExpire: represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish video privilege for 10 minutes,
// set pubVideoPrivilegeExpire as 600(seconds). This value must not exceed rtcTokenExpire;
// otherwise, the privilege is limited by the token expiration time.
// @param pubDataStreamPrivilegeExpire: represented by the number of seconds elapsed since now.
// If, for example, you want to enable publish data stream privilege for 10 minutes,
// set pubDataStreamPrivilegeExpire as 600(seconds). This value must not exceed rtcTokenExpire;
// otherwise, the privilege is limited by the token expiration time.
// @param rtmUserId: The RTM user's account, max length is 255 Bytes.
// @param rtmTokenExpire: represented by the number of seconds elapsed since now. If, for example,
// you want to access the Agora Service within 10 minutes after the token is generated,
// set rtmTokenExpire as 600(seconds). This value must not exceed rtcTokenExpire; otherwise,
// the RTM login privilege is limited by the token expiration time.
//
// return The ConvoAI token.
func BuildTokenWithPrivilege(appId string, appCertificate string, channelName string, rtcAccount string, rtcRole rtctokenbuilder.Role, rtcTokenExpire uint32,
	joinChannelPrivilegeExpire uint32, pubAudioPrivilegeExpire uint32, pubVideoPrivilegeExpire uint32, pubDataStreamPrivilegeExpire uint32,
	rtmUserId string, rtmTokenExpire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, rtcTokenExpire)

	serviceRtc := accesstoken.NewServiceRtc(channelName, rtcAccount)
	serviceRtc.AddPrivilege(accesstoken.PrivilegeJoinChannel, joinChannelPrivilegeExpire)
	if rtcRole == rtctokenbuilder.RolePublisher {
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishAudioStream, pubAudioPrivilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishVideoStream, pubVideoPrivilegeExpire)
		serviceRtc.AddPrivilege(accesstoken.PrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
	}
	token.AddService(serviceRtc)

	serviceRtm := accesstoken.NewServiceRtm(rtmUserId)
	serviceRtm.AddPrivilege(accesstoken.PrivilegeLogin, rtmTokenExpire)
	token.AddService(serviceRtm)

	token.AddService(accesstoken.NewServiceConvoAI())

	return token.Build()
}
