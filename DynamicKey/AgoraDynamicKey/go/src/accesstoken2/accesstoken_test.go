package accesstoken2

import (
	"reflect"
	"testing"
)

const (
	DataMockAppId               = "970CA35de60c44645bbae8a215061b33"
	DataMockAppCertificate      = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockWrongAppCertificate = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	DataMockChannelName         = "7d72365eb983485397e3e3f9d460bdda"
	DataMockExpire              = uint32(600)
	DataMockIssueTs             = uint32(1111111)
	DataMockSalt                = uint32(1)
	DataMockUid                 = uint32(2882341273)
	DataMockUidStr              = "2882341273"
	DataMockUserId              = "test_user"
)

// Test_AccessToken_Build_Error_NoService verifies token generation rejects an empty service list.
func Test_AccessToken_Build_Error_NoService(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	AssertEqual(t, DataMockAppCertificate, accessToken.AppCert)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 0, len(accessToken.Services))

	token, err := accessToken.Build()
	AssertEqual(t, "no service added", err.Error())
	AssertEqual(t, "", token)
}

// Test_AccessToken_Build_Error_AppId verifies rejection of invalid app IDs.
func Test_AccessToken_Build_Error_AppId(t *testing.T) {
	accessToken := NewAccessToken("", DataMockAppCertificate, DataMockExpire)
	token, err := accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)

	accessToken = NewAccessToken("abc", DataMockAppCertificate, DataMockExpire)
	token, err = accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)

	accessToken = NewAccessToken("Z70CA35de60c44645bbae8a215061b33", DataMockAppCertificate, DataMockExpire)
	token, err = accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)
}

// Test_AccessToken_Build_Error_AppCertificate verifies rejection of invalid app certificates.
func Test_AccessToken_Build_Error_AppCertificate(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, "", DataMockExpire)
	token, err := accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)

	accessToken = NewAccessToken(DataMockAppId, "abc", DataMockExpire)
	token, err = accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)

	accessToken = NewAccessToken(DataMockAppId, "5CFd2fd1755d40ecb72977518be15d3Z", DataMockExpire)
	token, err = accessToken.Build()
	AssertEqual(t, "check appId or appCertificate", err.Error())
	AssertEqual(t, "", token)
}

// Test_AccessToken_Build_ServiceRtc verifies deterministic RTC service token generation.
func Test_AccessToken_Build_ServiceRtc(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	serviceRtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
	serviceRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.AddService(serviceRtc)

	AssertEqual(t, DataMockChannelName, serviceRtc.ChannelName)
	AssertEqual(t, DataMockUidStr, serviceRtc.Uid)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=", token)
}

// Test_AccessToken_Build_ServiceRtc_Uid0 verifies RTC service token generation for a zero UID.
func Test_AccessToken_Build_ServiceRtc_Uid0(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	serviceRtc := NewServiceRtc(DataMockChannelName, "")
	serviceRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.AddService(serviceRtc)

	AssertEqual(t, DataMockChannelName, serviceRtc.ChannelName)
	AssertEqual(t, "", serviceRtc.Uid)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMgAAAAP//Npwiag==", token)
}

// Test_AccessToken_Build_ServiceRtm verifies deterministic RTM service token generation.
func Test_AccessToken_Build_ServiceRtm(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	serviceRtm := NewServiceRtm(DataMockUserId)
	serviceRtm.AddPrivilege(PrivilegeLogin, DataMockExpire)
	accessToken.AddService(serviceRtm)

	AssertEqual(t, DataMockUserId, serviceRtm.UserId)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A", token)
}

// Test_AccessToken_Build_ServiceChatUser verifies deterministic Chat user token generation.
func Test_AccessToken_Build_ServiceChatUser(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	serviceChat := NewServiceChat(DataMockUidStr)
	serviceChat.AddPrivilege(PrivilegeChatUser, DataMockExpire)
	accessToken.AddService(serviceChat)

	AssertEqual(t, DataMockUidStr, serviceChat.UserId)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrAyMDIxgPheDkYWFkbGJoZG5MSAAAP//H6UeuA==", token)
}

// Test_AccessToken_Build_ServiceChatApp verifies deterministic Chat app token generation.
func Test_AccessToken_Build_ServiceChatApp(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	serviceChat := NewServiceChat("")
	serviceChat.AddPrivilege(PrivilegeChatApp, DataMockExpire)
	accessToken.AddService(serviceChat)

	AssertEqual(t, "", serviceChat.UserId)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZGRgZmMB8BgZAAAAA//+t8hhr", token)
}

// Test_AccessToken_Build_MultipleServices verifies deterministic generation with distinct service types.
func Test_AccessToken_Build_MultipleServices(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	// RTC
	serviceRtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
	serviceRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.AddService(serviceRtc)

	// RTM
	serviceRtm := NewServiceRtm(DataMockUserId)
	serviceRtm.AddPrivilege(PrivilegeLogin, DataMockExpire)
	accessToken.AddService(serviceRtm)

	// CHAT
	serviceChat := NewServiceChat(DataMockUidStr)
	serviceChat.AddPrivilege(PrivilegeChatUser, DataMockExpire)
	accessToken.AddService(serviceChat)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYJjqLJBlM239wwWvmBZ7tW619coNnPKSXaHayfKzZODswxMVGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwMDMwgiGIr8BgnmJuZGxmmppkaWFsYmFqbGmeapxqnGaZYmJmkJSSksjFYGRhYWRsYmhkbswE18fJUJJaXBJfWpxaxAoXRFYKCAAA///aoiqr", token)
}

// Test_AccessToken_BuildAndParse_RepeatedServiceType verifies preservation of repeated service types and signatures.
func Test_AccessToken_BuildAndParse_RepeatedServiceType(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	rtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
	rtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.AddService(rtc)

	rtm := NewServiceRtm(DataMockUserId)
	rtm.AddPrivilege(PrivilegeLogin, DataMockExpire+100)
	accessToken.AddService(rtm)

	streamRtc := NewServiceRtc("stream-channel", "stream-user")
	streamRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire+200)
	streamRtc.AddPrivilege(PrivilegePublishDataStream, DataMockExpire+200)
	accessToken.AddService(streamRtc)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, 3, len(accessToken.Services))
	AssertEqual(t, 2, len(accessToken.GetServices(ServiceTypeRtc)))
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtm)))

	parsed := CreateAccessToken()
	res, err := parsed.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, res)

	rtcServices := parsed.GetServices(ServiceTypeRtc)
	AssertEqual(t, 2, len(rtcServices))
	AssertEqual(t, DataMockChannelName, rtcServices[0].(*ServiceRtc).ChannelName)
	AssertEqual(t, "stream-channel", rtcServices[1].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockExpire+200, rtcServices[1].(*ServiceRtc).Privileges[PrivilegePublishDataStream])

	verified, err := parsed.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)

	verified, err = parsed.VerifySignature(DataMockWrongAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, false, verified)
}

// Test_AccessToken_Build_FromPublicServices verifies token generation from the public Services slice.
func Test_AccessToken_Build_FromPublicServices(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	rtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
	rtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.Services = append(accessToken.Services, rtc)

	token, err := accessToken.Build()
	AssertNil(t, err)

	parsed := CreateAccessToken()
	res, err := parsed.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, 1, len(parsed.GetServices(ServiceTypeRtc)))
}

// Test_AccessToken_AddService_ZeroValue verifies service addition on a zero-value AccessToken.
func Test_AccessToken_AddService_ZeroValue(t *testing.T) {
	accessToken := &AccessToken{}
	rtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)

	accessToken.AddService(rtc)

	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtc)))
}

// Test_AccessToken_Parse_TokenRtc verifies RTC token fields, privileges, and signature.
func Test_AccessToken_Parse_TokenRtc(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=")

	AssertNil(t, err)
	AssertEqual(t, res, true)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtc)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeRtc)[0] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishDataStream])

	verified, err := accessToken.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)
}

// Test_AccessToken_Parse_UnknownServiceType verifies known services and signatures remain usable before an unknown service.
func Test_AccessToken_Parse_UnknownServiceType(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	rtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
	rtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
	accessToken.AddService(rtc)

	unknown := NewService(999)
	unknown.AddPrivilege(1, DataMockExpire)
	accessToken.AddService(unknown)

	token, err := accessToken.Build()
	AssertNil(t, err)

	parsed := CreateAccessToken()
	res, err := parsed.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, 1, len(parsed.GetServices(ServiceTypeRtc)))
	AssertEqual(t, 0, len(parsed.GetServices(999)))

	verified, err := parsed.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)
}

// Test_AccessToken_Parse_UnknownServiceTypeOnly verifies signature validation for a token containing only an unknown service.
func Test_AccessToken_Parse_UnknownServiceTypeOnly(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt

	unknown := NewService(999)
	unknown.AddPrivilege(1, DataMockExpire)
	accessToken.AddService(unknown)

	token, err := accessToken.Build()
	AssertNil(t, err)

	parsed := CreateAccessToken()
	res, err := parsed.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, 0, len(parsed.GetServices(ServiceTypeRtc)))

	verified, err := parsed.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)
}

// Test_AccessToken_VerifySignature_Errors verifies signature validation preconditions and certificate checks.
func Test_AccessToken_VerifySignature_Errors(t *testing.T) {
	accessToken := CreateAccessToken()

	verified, err := accessToken.VerifySignature(DataMockAppCertificate)
	AssertEqual(t, false, verified)
	AssertEqual(t, "parse token before verifying signature", err.Error())

	res, err := accessToken.Parse("007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=")
	AssertNil(t, err)
	AssertEqual(t, true, res)

	verified, err = accessToken.VerifySignature("invalid")
	AssertEqual(t, false, verified)
	AssertEqual(t, "check appId or appCertificate", err.Error())

	verified, err = accessToken.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)

	res, err = accessToken.Parse("006invalid")
	AssertEqual(t, false, res)
	AssertEqual(t, "invalid token version", err.Error())
	AssertEqual(t, 0, len(accessToken.Services))

	verified, err = accessToken.VerifySignature(DataMockAppCertificate)
	AssertEqual(t, false, verified)
	AssertEqual(t, "parse token before verifying signature", err.Error())
}

// Test_AccessToken_Parse_InvalidToken verifies malformed tokens return parsing errors.
func Test_AccessToken_Parse_InvalidToken(t *testing.T) {
	accessToken := CreateAccessToken()

	res, err := accessToken.Parse("00")
	AssertEqual(t, false, res)
	AssertEqual(t, "invalid token length", err.Error())

	res, err = accessToken.Parse("006invalid")
	AssertEqual(t, false, res)
	AssertEqual(t, "invalid token version", err.Error())

	res, err = accessToken.Parse("007aW52YWxpZA==")
	AssertEqual(t, false, res)
	AssertEqual(t, true, err != nil)
}

// Test_AccessToken_Parse_TokenRtc_FromPython verifies compatibility with RTC tokens generated by Python.
func Test_AccessToken_Parse_TokenRtc_FromPython(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtc)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeRtc)[0] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, uint32(0), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishDataStream])
}

// Test_AccessToken_Parse_TokenRtc_Rtm_MultiService_FromPython verifies compatibility with Python multi-service tokens.
func Test_AccessToken_Parse_TokenRtc_Rtm_MultiService_FromPython(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtc)))
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtm)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeRtc)[0] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtc)[0].(*ServiceRtc).Privileges[PrivilegePublishDataStream])
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeRtm)[0] != nil)
	AssertEqual(t, DataMockUserId, accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).UserId)
	AssertEqual(t, uint16(ServiceTypeRtm), accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).Privileges[PrivilegeLogin])
}

// Test_AccessToken_Parse_TokenRtm verifies RTM token fields and login privileges.
func Test_AccessToken_Parse_TokenRtm(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeRtm)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeRtm)[0] != nil)
	AssertEqual(t, DataMockUserId, accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).UserId)
	AssertEqual(t, uint16(ServiceTypeRtm), accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeRtm)[0].(*ServiceRtm).Privileges[PrivilegeLogin])
}

// Test_AccessToken_Parse_TokenChatUser verifies Chat user token fields and privileges.
func Test_AccessToken_Parse_TokenChatUser(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeChat)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeChat)[0] != nil)
	AssertEqual(t, DataMockUidStr, accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).UserId)
	AssertEqual(t, uint16(ServiceTypeChat), accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).Privileges[PrivilegeChatUser])
}

// Test_AccessToken_Parse_TokenChatApp verifies Chat app token fields and privileges.
func Test_AccessToken_Parse_TokenChatApp(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.GetServices(ServiceTypeChat)))
	AssertEqual(t, true, accessToken.GetServices(ServiceTypeChat)[0] != nil)
	AssertEqual(t, "", accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).UserId)
	AssertEqual(t, uint16(ServiceTypeChat), accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).Type)
	AssertEqual(t, DataMockExpire, accessToken.GetServices(ServiceTypeChat)[0].(*ServiceChat).Privileges[PrivilegeChatApp])
}

// Test_AccessToken_Parse_ExtendedServices_FromCpp verifies C++ Streaming, FCDN, and RTM2 compatibility.
func Test_AccessToken_Parse_ExtendedServices_FromCpp(t *testing.T) {
	const token = "007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ=="

	accessToken := CreateAccessToken()
	parsed, err := accessToken.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, parsed)

	verified, err := accessToken.VerifySignature(DataMockAppCertificate)
	AssertNil(t, err)
	AssertEqual(t, true, verified)

	streaming := accessToken.GetServices(ServiceTypeStreaming)[0].(*ServiceStreaming)
	AssertEqual(t, DataMockChannelName, streaming.ChannelName)
	AssertEqual(t, DataMockUidStr, streaming.Account)
	AssertEqual(t, DataMockExpire, streaming.Privileges[PrivilegeStreamingPublishMixStream])
	AssertEqual(t, DataMockExpire, streaming.Privileges[PrivilegeStreamingPublishRawStream])

	fcdn := accessToken.GetServices(ServiceTypeFCdn)[0].(*ServiceFCdn)
	AssertEqual(t, DataMockChannelName, fcdn.ChannelName)
	AssertEqual(t, DataMockUidStr, fcdn.Account)
	AssertEqual(t, DataMockExpire, fcdn.Privileges[PrivilegeFCdnPublish])
	AssertEqual(t, DataMockExpire, fcdn.Privileges[PrivilegeFCdnPlay])

	rtm2 := accessToken.GetServices(ServiceTypeRtm2)[0].(*ServiceRtm2)
	AssertEqual(t, DataMockUserId, rtm2.UserId)
	AssertEqual(t, DataMockExpire, rtm2.Privileges[PrivilegeLogin])
	AssertEqual(t, true, reflect.DeepEqual([]string{"message-a", "message-b"}, rtm2.Permissions.Details[Rtm2ResourceMessageChannels][Rtm2PermissionRead]))
	AssertEqual(t, true, reflect.DeepEqual([]string{"stream-a"}, rtm2.Permissions.Details[Rtm2ResourceStreamChannels][Rtm2PermissionWrite]))
	AssertEqual(t, true, reflect.DeepEqual([]string{"user-a"}, rtm2.Permissions.Details[Rtm2ResourceUsers][Rtm2PermissionRead]))
}

// Test_ExtendedServiceNumericUidConversion verifies deterministic Streaming and FCDN generation and UID conversion against C++.
func Test_ExtendedServiceNumericUidConversion(t *testing.T) {
	accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
	accessToken.IssueTs = DataMockIssueTs
	accessToken.Salt = DataMockSalt
	streamingUid := NewServiceStreamingWithUid(DataMockChannelName, DataMockUid)
	streamingUid.AddPrivilege(PrivilegeStreamingPublishMixStream, DataMockExpire)
	accessToken.AddService(streamingUid)
	streamingWildcard := NewServiceStreamingWithUid(DataMockChannelName, 0)
	streamingWildcard.AddPrivilege(PrivilegeStreamingPublishRawStream, DataMockExpire)
	accessToken.AddService(streamingWildcard)
	streamingAccount := NewServiceStreaming(DataMockChannelName, "stream-account")
	streamingAccount.AddPrivilege(PrivilegeStreamingPublishMixStream, DataMockExpire)
	streamingAccount.AddPrivilege(PrivilegeStreamingPublishRawStream, DataMockExpire)
	accessToken.AddService(streamingAccount)
	fcdnUid := NewServiceFCdnWithUid(DataMockChannelName, DataMockUid)
	fcdnUid.AddPrivilege(PrivilegeFCdnPublish, DataMockExpire)
	accessToken.AddService(fcdnUid)
	fcdnWildcard := NewServiceFCdnWithUid(DataMockChannelName, 0)
	fcdnWildcard.AddPrivilege(PrivilegeFCdnPlay, DataMockExpire)
	accessToken.AddService(fcdnWildcard)
	fcdnAccount := NewServiceFCdn(DataMockChannelName, "fcdn-account")
	fcdnAccount.AddPrivilege(PrivilegeFCdnPublish, DataMockExpire)
	fcdnAccount.AddPrivilege(PrivilegeFCdnPlay, DataMockExpire)
	accessToken.AddService(fcdnAccount)

	token, err := accessToken.Build()
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwMzAyMIL5CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxiB9TETqY2BgZmCC2kKsHj6G4pKi1MRc3cTk5PzSvBI2Mt3JRpI72Uh2Jw9DWnJKHsyVgAAAAP//SW9fVw==", token)
	parsed := CreateAccessToken()
	ok, err := parsed.Parse(token)
	AssertNil(t, err)
	AssertEqual(t, true, ok)

	streaming := parsed.GetServices(ServiceTypeStreaming)
	AssertEqual(t, DataMockUidStr, streaming[0].(*ServiceStreaming).Account)
	AssertEqual(t, "", streaming[1].(*ServiceStreaming).Account)
	AssertEqual(t, "stream-account", streaming[2].(*ServiceStreaming).Account)
	fcdn := parsed.GetServices(ServiceTypeFCdn)
	AssertEqual(t, DataMockUidStr, fcdn[0].(*ServiceFCdn).Account)
	AssertEqual(t, "", fcdn[1].(*ServiceFCdn).Account)
	AssertEqual(t, "fcdn-account", fcdn[2].(*ServiceFCdn).Account)
}

// Test_GetUidStr verifies numeric UID conversion, including the wildcard zero value.
func Test_GetUidStr(t *testing.T) {
	AssertEqual(t, "", GetUidStr(0))
	AssertEqual(t, DataMockUidStr, GetUidStr(DataMockUid))
}

// Test_getVersion verifies the AccessToken2 version prefix.
func Test_getVersion(t *testing.T) {
	AssertEqual(t, "007", getVersion())
}

// Test_isUuid verifies app identifier format validation.
func Test_isUuid(t *testing.T) {
	AssertEqual(t, true, isUuid(DataMockAppId))
	AssertEqual(t, true, isUuid(DataMockAppCertificate))
	AssertEqual(t, false, isUuid(""))
	AssertEqual(t, false, isUuid("abc"))
	AssertEqual(t, false, isUuid("Z70CA35de60c44645bbae8a215061b33"))
}
