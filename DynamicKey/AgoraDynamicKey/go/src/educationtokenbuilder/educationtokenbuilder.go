package educationtokenbuilder

import (
	accesstoken2 "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

// BuildRoomUserToken
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// @param roomUuid: The room's id, must be unique.
// @param userUuid: The user's id, must be unique.
// @param role: The user's role.
// @param expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
// generated, set expireTimestamp as the current timestamp + 600 (seconds).
//
// return The Room User token.
func BuildRoomUserToken(appId string, appCertificate string, roomUuid string, userUuid string, role int16, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appId, appCertificate, expire)

	chatUserId := accesstoken2.Md5(userUuid)
	serviceApaas := accesstoken2.NewServiceApaas(roomUuid, userUuid, role)
	serviceApaas.AddPrivilege(accesstoken2.PrivilegeApaasRoomUser, expire)
	token.AddService(serviceApaas)

	serviceRtm := accesstoken2.NewServiceRtm(userUuid)
	serviceRtm.AddPrivilege(accesstoken2.PrivilegeLogin, expire)
	token.AddService(serviceRtm)

	serviceChat := accesstoken2.NewServiceChat(chatUserId)
	serviceChat.AddPrivilege(accesstoken2.PrivilegeChatUser, expire)
	token.AddService(serviceChat)

	return token.Build()
}

// BuildUserToken
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// @param userUuid: The user's id, must be unique.
// @param expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
// generated, set expireTimestamp as the current timestamp + 600 (seconds).
//
// return The User token.
func BuildUserToken(appId string, appCertificate string, userUuid string, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appId, appCertificate, expire)

	serviceApaas := accesstoken2.NewServiceApaas("", userUuid, -1)
	serviceApaas.AddPrivilege(accesstoken2.PrivilegeApaasUser, expire)
	token.AddService(serviceApaas)

	return token.Build()
}

// BuildAppToken
//
// @param appId: The App ID issued to you by Agora. Apply for a new App ID from Agora Dashboard if it is missing from your kit. See Get an App ID.
// @param appCertificate: Certificate of the application that you registered in the Agora Dashboard. See Get an App Certificate.
// @param expire: represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is
// generated, set expireTimestamp as the current timestamp + 600 (seconds).
//
// return The App token.
func BuildAppToken(appId string, appCertificate string, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appId, appCertificate, expire)

	serviceApaas := accesstoken2.NewServiceApaas("", "", -1)
	serviceApaas.AddPrivilege(accesstoken2.PrivilegeApaasApp, expire)
	token.AddService(serviceApaas)

	return token.Build()
}
