package educationtokenbuilder

import (
	accesstoken2 "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
)

//BuildRoomUserToken method
// appID: The App ID issued to you by Agora. Apply for a new App ID from
//    Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate: Certificate of the application that you registered in
//    the Agora Dashboard. See Get an App Certificate.
// roomUuid: The room's id, must be unique.
// userUuid: The user's id, must be unique.
// role: The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
// expire: represented by the number of seconds elapsed since
//    1/1/1970. If, for example, you want to access the
//    Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current
//    timestamp + 600 (seconds).
func BuildRoomUserToken(appID string, appCertificate string, roomUuid string, userUuid string, role int16, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appID, appCertificate, expire)

	chatUserId := accesstoken2.Md5(userUuid)
	serviceEducation := accesstoken2.NewServiceEducation(roomUuid, userUuid, role)
	serviceEducation.AddPrivilege(accesstoken2.PrivilegeEducationRoomUser, expire)
	token.AddService(serviceEducation)

	serviceRtm := accesstoken2.NewServiceRtm(userUuid)
	serviceRtm.AddPrivilege(accesstoken2.PrivilegeLogin, expire)
	token.AddService(serviceRtm)

	serviceChat := accesstoken2.NewServiceChat(chatUserId)
	serviceChat.AddPrivilege(accesstoken2.PrivilegeChatUser, expire)
	token.AddService(serviceChat)

	return token.Build()
}

//BuildUserToken method
// appID: The App ID issued to you by Agora. Apply for a new App ID from
//    Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate: Certificate of the application that you registered in
//    the Agora Dashboard. See Get an App Certificate.
// userUuid: The user's id, must be unique.
// expire: represented by the number of seconds elapsed since
//    1/1/1970. If, for example, you want to access the
//    Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current
//    timestamp + 600 (seconds).
func BuildUserToken(appID string, appCertificate string, userUuid string, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appID, appCertificate, expire)

	serviceEducation := accesstoken2.NewServiceEducation("", userUuid, -1)
	serviceEducation.AddPrivilege(accesstoken2.PrivilegeEducationUser, expire)
	token.AddService(serviceEducation)

	return token.Build()
}

//BuildAppToken method
// appID: The App ID issued to you by Agora. Apply for a new App ID from
//    Agora Dashboard if it is missing from your kit. See Get an App ID.
// appCertificate: Certificate of the application that you registered in
//    the Agora Dashboard. See Get an App Certificate.
// expire: represented by the number of seconds elapsed since
//    1/1/1970. If, for example, you want to access the
//    Agora Service within 10 minutes after the token is
//    generated, set expireTimestamp as the current
//    timestamp + 600 (seconds).
func BuildAppToken(appID string, appCertificate string, expire uint32) (string, error) {
	token := accesstoken2.NewAccessToken(appID, appCertificate, expire)

	serviceEducation := accesstoken2.NewServiceEducation("", "", -1)
	serviceEducation.AddPrivilege(accesstoken2.PrivilegeEducationApp, expire)
	token.AddService(serviceEducation)

	return token.Build()
}
