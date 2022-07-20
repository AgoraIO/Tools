package rtmtokenbuilder2

import (
	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// Build the RTM token.
//
// appId:           The App ID issued to you by Agora. Apply for a new App ID from
//                  Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate:  Certificate of the application that you registered in
//                  the Agora Dashboard. See Get an App Certificate.
// userId:          The user's account, max length is 64 Bytes.
// expire:          represented by the number of seconds elapsed since now. If, for example, you want to access the
//                  Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
// return The RTM token.
func BuildToken(appId string, appCertificate string, userId string, expire uint32) (string, error) {
	token := accesstoken.NewAccessToken(appId, appCertificate, expire)

	serviceRtm := accesstoken.NewServiceRtm(userId)
	serviceRtm.AddPrivilege(accesstoken.PrivilegeLogin, expire)
	token.AddService(serviceRtm)

	return token.Build()
}
