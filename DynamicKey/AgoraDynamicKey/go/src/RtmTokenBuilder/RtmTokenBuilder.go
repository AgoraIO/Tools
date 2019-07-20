package rtmtokenbuilder

import "AccessToken"

//RtmTokenBuilder constructor
type RtmTokenBuilder struct {
	Token AccessToken.AccessToken
}

//CreateRtmTokenBuilder static func to create a token builder with int uid
func CreateRtmTokenBuilder(appID, appCertificate, account string) RtmTokenBuilder {
	return RtmTokenBuilder{AccessToken.CreateAccessToken(appID, appCertificate, account, 0)}
}

//InitTokenBuilder initialize the token builder with existing token, usually used for renew token
func (builder *RtmTokenBuilder) InitTokenBuilder(originToken string) bool {
	return builder.Token.FromString(originToken)
}

//SetPrivilege set priviledge to an existing token
func (builder *RtmTokenBuilder) SetPrivilege(privilege AccessToken.Privileges, expireTimestamp uint32) {
	pri := uint16(privilege)
	builder.Token.Message[pri] = expireTimestamp
}

//RemovePrivilege remove a priviledge from a token builder
func (builder *RtmTokenBuilder) RemovePrivilege(privilege AccessToken.Privileges) {
	pri := uint16(privilege)
	delete(builder.Token.Message, pri)
}

//BuildToken build and return the result token
func (builder *RtmTokenBuilder) BuildToken() (string, error) {
	return builder.Token.Build()
}
