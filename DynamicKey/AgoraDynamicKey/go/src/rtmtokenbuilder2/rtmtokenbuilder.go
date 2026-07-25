package rtmtokenbuilder2

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// Build the RTM token.
//
// appId:           The App ID issued to you by Agora. Apply for a new App ID from
//
//	Agora Dashboard if it is missing from your kit. See Get an App ID.
//
// appCertificate:  Certificate of the application that you registered in
//
//	the Agora Dashboard. See Get an App Certificate.
//
// userId:          The user's account, max length is 64 Bytes.
// expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
//
//	Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
//
// return The RTM token.
func BuildToken(appId string, appCertificate string, userId string, expire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, expire)

	serviceRtm := accesstoken.NewServiceRtm(userId)
	serviceRtm.AddPrivilege(accesstoken.PrivilegeLogin, expire)
	token.AddService(serviceRtm)

	return token.Build()
}

// BuildTokenWithPermissions builds an RTM2 token with resource-level permissions.
//
// This special interface requires Agora assistance for proper usage. Contact Agora
// before using it to avoid unexpected errors in your application.
//
// @param appId The App ID issued to you by Agora.
// @param appCertificate The certificate of the application registered in the Agora Dashboard.
// @param userId The user's account, with a maximum length of 64 bytes.
// @param permissions The RTM2 resource-level permissions.
// @param expire The number of seconds from token generation until the token and
// login privilege expire. For example, set expire to 600 for a validity period of 10 minutes.
//
// return The RTM2 token and an error if token generation fails.
func BuildTokenWithPermissions(appId string, appCertificate string, userId string, permissions *accesstoken.Rtm2Permissions, expire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, expire)

	serviceRtm2 := accesstoken.NewServiceRtm2(userId, permissions)
	serviceRtm2.AddPrivilege(accesstoken.PrivilegeLogin, expire)
	token.AddService(serviceRtm2)

	return token.Build()
}
