package SimpleTokenBuilder

import (
	"../AccessToken"
)

type Role uint16
const (
	Role_Attendee = 1
    Role_Publisher = 2
    Role_Subscriber = 3
    Role_Admin = 4
)

var attendeePrivileges = map[uint16]uint32 {
	AccessToken.KJoinChannel: 0, 
	AccessToken.KPublishAudioStream: 0, 
	AccessToken.KPublishVideoStream: 0, 
	AccessToken.KPublishDataStream: 0,
}
var publisherPrivileges = map[uint16]uint32 {
	AccessToken.KJoinChannel: 0, 
	AccessToken.KPublishAudioStream: 0, 
	AccessToken.KPublishVideoStream: 0, 
	AccessToken.KPublishDataStream: 0,
	AccessToken.KPublishAudiocdn: 0,
	AccessToken.KPublishVideoCdn: 0,
	AccessToken.KInvitePublishAudioStream: 0,
	AccessToken.KInvitePublishVideoStream: 0,
	AccessToken.KInvitePublishDataStream: 0,
}

var subscriberPrivileges = map[uint16]uint32 {
	AccessToken.KJoinChannel: 0, 
	AccessToken.KRequestPublishAudioStream: 0, 
	AccessToken.KRequestPublishVideoStream: 0, 
	AccessToken.KRequestPublishDataStream: 0,
}

var adminPrivileges = map[uint16]uint32 {
	AccessToken.KJoinChannel: 0, 
	AccessToken.KPublishAudioStream: 0, 
	AccessToken.KPublishVideoStream: 0, 
	AccessToken.KPublishDataStream: 0,
	AccessToken.KAdministrateChannel: 0,
}

var RolePrivileges = map[uint16](map[uint16]uint32) {
	Role_Attendee: attendeePrivileges, 
	Role_Publisher: publisherPrivileges, 
	Role_Subscriber: subscriberPrivileges, 
	Role_Admin: adminPrivileges,
}


type SimpleTokenBuilder struct {
	Token AccessToken.AccessToken
}

func CreateSimpleTokenBuilder(appID, appCertificate, channelName string, uid uint32) SimpleTokenBuilder {
    return SimpleTokenBuilder{AccessToken.CreateAccessToken(appID, appCertificate, channelName, uid)}
}

func (builder *SimpleTokenBuilder) InitPrivileges(role Role) {
	rolepri := uint16(role)
	for key, value := range RolePrivileges[rolepri] {
		builder.Token.Message[key] = value
	}
}

func (builder *SimpleTokenBuilder) InitTokenBuilder(originToken string) bool {
	return builder.Token.FromString(originToken)
}

func (builder *SimpleTokenBuilder) SetPrivilege(privilege AccessToken.Privileges, expireTimestamp uint32) {
	pri := uint16(privilege)
	builder.Token.Message[pri] = expireTimestamp
}

func (builder *SimpleTokenBuilder) RemovePrivilege(privilege AccessToken.Privileges) {
	pri := uint16(privilege)
	delete(builder.Token.Message, pri)
}

func (builder *SimpleTokenBuilder) BuildToken() (string,error) {
	return builder.Token.Build()
}



