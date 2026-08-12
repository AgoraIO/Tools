package stttokenbuilder

import (
	"testing"

	accesstoken "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/accesstoken2"
	rtctokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
)

const (
	DataMockAppCertificate               = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockAppId                        = "970CA35de60c44645bbae8a215061b33"
	DataMockChannelName                  = "7d72365eb983485397e3e3f9d460bdda"
	DataMockRtcAccount                   = "2882341273"
	DataMockRtmUserId                    = "2882341273"
	DataMockRtcTokenExpire               = uint32(600)
	DataMockJoinChannelPrivilegeExpire   = uint32(600)
	DataMockPubAudioPrivilegeExpire      = uint32(600)
	DataMockPubVideoPrivilegeExpire      = uint32(600)
	DataMockPubDataStreamPrivilegeExpire = uint32(600)
	DataMockRtmTokenExpire               = uint32(600)
)

// Test_BuildToken verifies publisher privileges and the STT service payload.
func Test_BuildToken(t *testing.T) {
	token, err := BuildToken(
		DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockRtcAccount, rtctokenbuilder.RolePublisher,
		DataMockRtcTokenExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire,
		DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire, DataMockRtmUserId, DataMockRtmTokenExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	parsedOK, err := accessToken.Parse(token)
	accesstoken.AssertNil(t, err)
	accesstoken.AssertEqual(t, true, parsedOK)

	accesstoken.AssertEqual(t, DataMockAppId, accessToken.AppId)
	accesstoken.AssertEqual(t, DataMockRtcTokenExpire, accessToken.Expire)
	accesstoken.AssertEqual(t, DataMockChannelName, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).ChannelName)
	accesstoken.AssertEqual(t, DataMockRtcAccount, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Uid)
	accesstoken.AssertEqual(t, DataMockJoinChannelPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, DataMockPubAudioPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, DataMockPubVideoPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, DataMockPubDataStreamPrivilegeExpire, accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc).Privileges[accesstoken.PrivilegePublishDataStream])
	accesstoken.AssertEqual(t, DataMockRtmUserId, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).UserId)
	accesstoken.AssertEqual(t, DataMockRtmTokenExpire, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
	accesstoken.AssertEqual(t, 1, len(accessToken.GetServices(accesstoken.ServiceTypeStt)))
	accesstoken.AssertEqual(t, 0, len(accessToken.GetServices(accesstoken.ServiceTypeStt)[0].(*accesstoken.ServiceStt).Privileges))
}

// Test_BuildToken_RoleSubscriber verifies subscriber privileges omit publishing access.
func Test_BuildToken_RoleSubscriber(t *testing.T) {
	token, err := BuildToken(
		DataMockAppId, DataMockAppCertificate, DataMockChannelName, DataMockRtcAccount, rtctokenbuilder.RoleSubscriber,
		DataMockRtcTokenExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire,
		DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire, DataMockRtmUserId, DataMockRtmTokenExpire)
	accesstoken.AssertNil(t, err)

	accessToken := accesstoken.CreateAccessToken()
	parsedOK, err := accessToken.Parse(token)
	accesstoken.AssertNil(t, err)
	accesstoken.AssertEqual(t, true, parsedOK)

	rtcService := accessToken.GetServices(accesstoken.ServiceTypeRtc)[0].(*accesstoken.ServiceRtc)
	accesstoken.AssertEqual(t, DataMockJoinChannelPrivilegeExpire, rtcService.Privileges[accesstoken.PrivilegeJoinChannel])
	accesstoken.AssertEqual(t, uint32(0), rtcService.Privileges[accesstoken.PrivilegePublishAudioStream])
	accesstoken.AssertEqual(t, uint32(0), rtcService.Privileges[accesstoken.PrivilegePublishVideoStream])
	accesstoken.AssertEqual(t, uint32(0), rtcService.Privileges[accesstoken.PrivilegePublishDataStream])
	accesstoken.AssertEqual(t, DataMockRtmTokenExpire, accessToken.GetServices(accesstoken.ServiceTypeRtm)[0].(*accesstoken.ServiceRtm).Privileges[accesstoken.PrivilegeLogin])
}

// Test_BuildToken_InvalidCredentials verifies invalid credentials return an error and an empty token.
func Test_BuildToken_InvalidCredentials(t *testing.T) {
	token, err := BuildToken(
		"invalid", DataMockAppCertificate, DataMockChannelName, DataMockRtcAccount, rtctokenbuilder.RolePublisher,
		DataMockRtcTokenExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire,
		DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire, DataMockRtmUserId, DataMockRtmTokenExpire)
	accesstoken.AssertEqual(t, "check appId or appCertificate", err.Error())
	accesstoken.AssertEqual(t, "", token)

	token, err = BuildToken(
		DataMockAppId, "invalid", DataMockChannelName, DataMockRtcAccount, rtctokenbuilder.RolePublisher,
		DataMockRtcTokenExpire, DataMockJoinChannelPrivilegeExpire, DataMockPubAudioPrivilegeExpire,
		DataMockPubVideoPrivilegeExpire, DataMockPubDataStreamPrivilegeExpire, DataMockRtmUserId, DataMockRtmTokenExpire)
	accesstoken.AssertEqual(t, "check appId or appCertificate", err.Error())
	accesstoken.AssertEqual(t, "", token)
}
