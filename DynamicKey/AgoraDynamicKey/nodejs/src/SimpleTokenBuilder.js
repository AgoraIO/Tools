var AccessToken = require('../src/AccessToken').AccessToken;
var Priviledges = require('../src/AccessToken').priviledges;

var Role = {
    kRoleAttendee: 0,  // for communication
    kRolePublisher: 1, // for live broadcast
    kRoleSubscriber: 2,  // for live broadcast
    kRoleAdmin: 101
};

var attendeePrivileges = {
    [Priviledges.kJoinChannel]: 0,
    [Priviledges.kPublishAudioStream]: 0,
    [Priviledges.kPublishVideoStream]: 0,
    [Priviledges.kPublishDataStream]: 0
};


var publisherPrivileges = {
    [Priviledges.kJoinChannel]: 0,
    [Priviledges.kPublishAudioStream]: 0,
    [Priviledges.kPublishVideoStream]: 0,
    [Priviledges.kPublishDataStream]: 0,
    [Priviledges.kPublishAudiocdn]: 0,
    [Priviledges.kPublishVideoCdn]: 0,
    [Priviledges.kInvitePublishAudioStream]: 0,
    [Priviledges.kInvitePublishVideoStream]: 0,
    [Priviledges.kInvitePublishDataStream]: 0
};

var subscriberPrivileges = {
    [Priviledges.kJoinChannel] : 0,
    [Priviledges.kRequestPublishAudioStream] : 0,
    [Priviledges.kRequestPublishVideoStream] : 0,
    [Priviledges.kRequestPublishDataStream] : 0
};

var adminPrivileges = {
    [Priviledges.kJoinChannel] : 0,
    [Priviledges.kPublishAudioStream] : 0,
    [Priviledges.kPublishVideoStream] : 0,
    [Priviledges.kPublishDataStream] : 0,
    [Priviledges.kAdministrateChannel]: 0
};

var RolePrivileges = {
	[Role.kRoleAttendee]: attendeePrivileges,
    [Role.kRolePublisher]: publisherPrivileges,
    [Role.kRoleSubscriber]: subscriberPrivileges,
    [Role.kRoleAdmin]: adminPrivileges
}

var SimpleTokenBuilder = function (appID, appCertificate, channelName, uid) {
    let builder = this;
    this.key = new AccessToken(appID, appCertificate, channelName, uid);

    this.buildToken = function () {
        return builder.key.build();
    }

    this.initPrivileges = function (role) {
        let rolePri = RolePrivileges[role];
        builder.key.messages = JSON.parse(JSON.stringify(rolePri));
    }

    this.initTokenBuilder = function (originToken) {
        return builder.key.fromString(originToken);
    }

    this.setPrivilege = function (privilege, expireTimestamp) {
        builder.key.messages[privilege] = expireTimestamp;
    }
    
    this.removePrivilege = function (privilege) {
        delete builder.key.messages[privilege];
    }
};

module.exports.SimpleTokenBuilder = SimpleTokenBuilder;
module.exports.Role = Role;