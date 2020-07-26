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

func Test_AssessToken_Build(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
    accessToken.IssueTs = DataMockIssueTs
    accessToken.Salt = DataMockSalt

    AssertEqual(t, accessToken.AppCert, DataMockAppCertificate)
    AssertEqual(t, accessToken.AppId, DataMockAppId)
    AssertEqual(t, accessToken.Expire, DataMockExpire)
    AssertEqual(t, accessToken.IssueTs, DataMockIssueTs)
    AssertEqual(t, accessToken.Salt, DataMockSalt)
    AssertEqual(t, len(accessToken.Services), 0)

    token, err := accessToken.Build()
    AssertNil(t, err)
    AssertEqual(t, token, "007eJxSYEiJ9+zw7Gb1viNuGtMfy3JriuZNp+1h1iLu/rOePHlS91WBwdLcwNnR2DQl1cwg2cTEzMQ0KSkx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwgAAgAA//+rZxiv")
}

func Test_AssessToken_Build_Error_AppId(t *testing.T) {
    accessToken := NewAccessToken("", DataMockAppCertificate, DataMockExpire)
    token, err := accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")

    accessToken = NewAccessToken("abc", DataMockAppCertificate, DataMockExpire)
    token, err = accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")

    accessToken = NewAccessToken("Z70CA35de60c44645bbae8a215061b33", DataMockAppCertificate, DataMockExpire)
    token, err = accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")
}

func Test_AssessToken_Build_Error_AppCertificate(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, "", DataMockExpire)
    token, err := accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")

    accessToken = NewAccessToken(DataMockAppId, "abc", DataMockExpire)
    token, err = accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")

    accessToken = NewAccessToken(DataMockAppId, "5CFd2fd1755d40ecb72977518be15d3Z", DataMockExpire)
    token, err = accessToken.Build()
    AssertEqual(t, err.Error(), "check appId or appCertificate")
    AssertEqual(t, token, "")
}

func Test_AssessToken_Build_ServiceRtc(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
    accessToken.IssueTs = DataMockIssueTs
    accessToken.Salt = DataMockSalt

    serviceRtc := NewServiceRtc(DataMockChannelName, DataMockUidStr)
    serviceRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
    accessToken.AddService(serviceRtc)

    AssertEqual(t, serviceRtc.ChannelName, DataMockChannelName)
    AssertEqual(t, serviceRtc.Uid, DataMockUidStr)

    token, err := accessToken.Build()
    AssertNil(t, err)
    AssertEqual(t, token, "007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=")
}

func Test_AssessToken_Build_ServiceRtc_Uid0(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
    accessToken.IssueTs = DataMockIssueTs
    accessToken.Salt = DataMockSalt

    serviceRtc := NewServiceRtc(DataMockChannelName, "")
    serviceRtc.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
    accessToken.AddService(serviceRtc)

    AssertEqual(t, serviceRtc.ChannelName, DataMockChannelName)
    AssertEqual(t, serviceRtc.Uid, "")

    token, err := accessToken.Build()
    AssertNil(t, err)
    AssertEqual(t, token, "007eJxSYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMgAAAAP//Npwiag==")
}

func Test_AssessToken_Build_ServiceRtm(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
    accessToken.IssueTs = DataMockIssueTs
    accessToken.Salt = DataMockSalt

    serviceRtm := NewServiceRtm(DataMockUserId)
    serviceRtm.AddPrivilege(PrivilegeLogin, DataMockExpire)
    accessToken.AddService(serviceRtm)

    AssertEqual(t, serviceRtm.UserId, DataMockUserId)

    token, err := accessToken.Build()
    AssertNil(t, err)
    AssertEqual(t, token, "007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A")
}

func Test_AssessToken_Build_ServiceStreaming(t *testing.T) {
    accessToken := NewAccessToken(DataMockAppId, DataMockAppCertificate, DataMockExpire)
    accessToken.IssueTs = DataMockIssueTs
    accessToken.Salt = DataMockSalt

    serviceStreaming := NewServiceStreaming(DataMockChannelName, DataMockUidStr)
    serviceStreaming.AddPrivilege(PrivilegeJoinChannel, DataMockExpire)
    accessToken.AddService(serviceStreaming)

    AssertEqual(t, serviceStreaming.ChannelName, DataMockChannelName)
    AssertEqual(t, serviceStreaming.Uid, DataMockUidStr)

    token, err := accessToken.Build()
    AssertNil(t, err)
    AssertEqual(t, token, "007eJxSYGBj//4jzGnul2n88j7n7tb9njDzn/j5BhulK6yLV5/YlWKnwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkQGEmRkYGRjBfAUG8xRzI2Mz09QkSwtjEwtTY0vzVONU4zTLFBMzg6SUlEQuBiMLCyNjE0Mjc2NAAAAA//8zyyXw")
}

func Test_AssessToken_Parse_TokenRtc(t *testing.T) {
    accessToken := CreateAccessToken()
    res, err := accessToken.Parse("007eJxSYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxoAAAAD//8JqJOM=")

    AssertNil(t, err)
    AssertEqual(t, res, true)
    AssertEqual(t, accessToken.AppId, DataMockAppId)
    AssertEqual(t, accessToken.Expire, DataMockExpire)
    AssertEqual(t, accessToken.IssueTs, DataMockIssueTs)
    AssertEqual(t, accessToken.Salt, DataMockSalt)
    AssertEqual(t, len(accessToken.Services), 1)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc] != nil, true)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName, DataMockChannelName)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid, DataMockUidStr)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type, uint16(ServiceTypeRtc))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream], uint32(0))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream], uint32(0))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream], uint32(0))
}

func Test_AssessToken_Parse_TokenRtc_FromPython(t *testing.T) {
    accessToken := CreateAccessToken()
    res, err := accessToken.Parse("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj")

    AssertNil(t, err)
    AssertEqual(t, res, true)
    AssertEqual(t, accessToken.AppId, DataMockAppId)
    AssertEqual(t, accessToken.Expire, DataMockExpire)
    AssertEqual(t, accessToken.IssueTs, DataMockIssueTs)
    AssertEqual(t, accessToken.Salt, DataMockSalt)
    AssertEqual(t, len(accessToken.Services), 1)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc] != nil, true)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName, DataMockChannelName)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid, DataMockUidStr)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type, uint16(ServiceTypeRtc))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream], uint32(0))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream], uint32(0))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream], uint32(0))
}

func Test_AssessToken_Parse_TokenRtc_Rtm_MultiService_FromPython(t *testing.T) {
    accessToken := CreateAccessToken()
    res, err := accessToken.Parse("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4")

    AssertNil(t, err)
    AssertEqual(t, res, true)
    AssertEqual(t, accessToken.AppId, DataMockAppId)
    AssertEqual(t, accessToken.Expire, DataMockExpire)
    AssertEqual(t, accessToken.IssueTs, DataMockIssueTs)
    AssertEqual(t, accessToken.Salt, DataMockSalt)
    AssertEqual(t, len(accessToken.Services), 2)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc] != nil, true)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).ChannelName, DataMockChannelName)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Uid, DataMockUidStr)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Type, uint16(ServiceTypeRtc))
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegeJoinChannel], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishAudioStream], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishVideoStream], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtc].(*ServiceRtc).Privileges[PrivilegePublishDataStream], DataMockExpire)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm] != nil, true)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).UserId, DataMockUserId)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Type, uint16(ServiceTypeRtm))
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Privileges[PrivilegeLogin], DataMockExpire)
}

func Test_AssessToken_Parse_TokenRtm(t *testing.T) {
    accessToken := CreateAccessToken()
    res, err := accessToken.Parse("007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A")

    AssertNil(t, err)
    AssertEqual(t, res, true)
    AssertEqual(t, accessToken.AppId, DataMockAppId)
    AssertEqual(t, accessToken.Expire, DataMockExpire)
    AssertEqual(t, accessToken.IssueTs, DataMockIssueTs)
    AssertEqual(t, accessToken.Salt, DataMockSalt)
    AssertEqual(t, len(accessToken.Services), 1)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm] != nil, true)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).UserId, DataMockUserId)
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Type, uint16(ServiceTypeRtm))
    AssertEqual(t, accessToken.Services[ServiceTypeRtm].(*ServiceRtm).Privileges[PrivilegeLogin], DataMockExpire)
}

func Test_GetUidStr(t *testing.T) {
    AssertEqual(t, GetUidStr(0), "")
    AssertEqual(t, GetUidStr(DataMockUid), DataMockUidStr)
}

func Test_getVersion(t *testing.T) {
    AssertEqual(t, getVersion(), "007")
}

func Test_isUuid(t *testing.T) {
    AssertEqual(t, isUuid(DataMockAppId), true)
    AssertEqual(t, isUuid(DataMockAppCertificate), true)
    AssertEqual(t, isUuid(""), false)
    AssertEqual(t, isUuid("abc"), false)
    AssertEqual(t, isUuid("Z70CA35de60c44645bbae8a215061b33"), false)
}
