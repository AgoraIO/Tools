package accesstoken2

import (
	"testing"
)

const (
	DataMockAppId          = "970CA35de60c44645bbae8a215061b33"
	DataMockAppCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
	DataMockChannelName    = "7d72365eb983485397e3e3f9d460bdda"
	DataMockExpire         = uint32(600)
	DataMockIssueTs        = uint32(1111111)
	DataMockSalt           = uint32(1)
	DataMockUid            = uint32(2882341273)
	DataMockUidStr         = "2882341273"
	DataMockUserId         = "test_user"
)

func Test_AccessToken_Build(t *testing.T) {
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
	AssertNil(t, err)
	AssertEqual(t, "007eJxSYEiJ9+zw7Gb1viNuGtMfy3JriuZNp+1h1iLu/rOePHlS91WBwdLcwNnR2DQl1cwg2cTEzMQ0KSkx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwgAAgAA//+rZxiv", token)
}

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

func Test_AccessToken_Parse_TokenRtc(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=")

	AssertNil(t, err)
	AssertEqual(t, res, true)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeRtc] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream])
}

func Test_AccessToken_Parse_TokenRtc_FromPython(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeRtc] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, uint32(0), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream])
}

func Test_AccessToken_Parse_TokenRtc_Rtm_MultiService_FromPython(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 2, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeRtc] != nil)
	AssertEqual(t, DataMockChannelName, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName)
	AssertEqual(t, DataMockUidStr, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid)
	AssertEqual(t, uint16(ServiceTypeRtc), accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel])
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream])
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream])
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream])
	AssertEqual(t, true, accessToken.Services[ServiceTypeRtm] != nil)
	AssertEqual(t, DataMockUserId, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).UserId)
	AssertEqual(t, uint16(ServiceTypeRtm), accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Privileges[PrivilegeLogin])
}

func Test_AccessToken_Parse_TokenRtm(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeRtm] != nil)
	AssertEqual(t, DataMockUserId, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).UserId)
	AssertEqual(t, uint16(ServiceTypeRtm), accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Privileges[PrivilegeLogin])
}

func Test_AccessToken_Parse_TokenChatUser(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeChat] != nil)
	AssertEqual(t, DataMockUidStr, accessToken.Services[ServiceTypeChat].(*ServiceChat).UserId)
	AssertEqual(t, uint16(ServiceTypeChat), accessToken.Services[ServiceTypeChat].(*ServiceChat).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeChat].(*ServiceChat).Privileges[PrivilegeChatUser])
}

func Test_AccessToken_Parse_TokenChatApp(t *testing.T) {
	accessToken := CreateAccessToken()
	res, err := accessToken.Parse("007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr")

	AssertNil(t, err)
	AssertEqual(t, true, res)
	AssertEqual(t, DataMockAppId, accessToken.AppId)
	AssertEqual(t, DataMockExpire, accessToken.Expire)
	AssertEqual(t, DataMockIssueTs, accessToken.IssueTs)
	AssertEqual(t, DataMockSalt, accessToken.Salt)
	AssertEqual(t, 1, len(accessToken.Services))
	AssertEqual(t, true, accessToken.Services[ServiceTypeChat] != nil)
	AssertEqual(t, "", accessToken.Services[ServiceTypeChat].(*ServiceChat).UserId)
	AssertEqual(t, uint16(ServiceTypeChat), accessToken.Services[ServiceTypeChat].(*ServiceChat).Type)
	AssertEqual(t, DataMockExpire, accessToken.Services[ServiceTypeChat].(*ServiceChat).Privileges[PrivilegeChatApp])
}

func Test_GetUidStr(t *testing.T) {
	AssertEqual(t, "", GetUidStr(0))
	AssertEqual(t, DataMockUidStr, GetUidStr(DataMockUid))
}

func Test_getVersion(t *testing.T) {
	AssertEqual(t, "007", getVersion())
}

func Test_isUuid(t *testing.T) {
	AssertEqual(t, true, isUuid(DataMockAppId))
	AssertEqual(t, true, isUuid(DataMockAppCertificate))
	AssertEqual(t, false, isUuid(""))
	AssertEqual(t, false, isUuid("abc"))
	AssertEqual(t, false, isUuid("Z70CA35de60c44645bbae8a215061b33"))
}
