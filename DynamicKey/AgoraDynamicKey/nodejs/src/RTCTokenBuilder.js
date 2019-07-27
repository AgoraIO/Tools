const AccessToken = require('../src/AccessToken').AccessToken
const Priviledges = require('../src/AccessToken').priviledges

const Role = {
    ATTENDEE: 0,
    PUBLISHER: 1,
    SUBSCRIBER: 2,
    ADMIN: 101
}

class RTCTokenBuilder {

    static buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs) {
        return this.buildTokenWithAccount(appID, appCertificate, channelName, uid, role, privilegeExpiredTs)
    }

    static buildTokenWithAccount(appID, appCertificate, channelName, uid, role, privilegeExpiredTs) {
        this.key = new AccessToken(appID, appCertificate, channelName, uid)
        this.key.addPriviledge(Priviledges.kJoinChannel, privilegeExpiredTs)
        if (role == Role.PUBLISHER ||
            role == Role.SUBSCRIBER ||
            role == Role.ADMIN) {
            this.key.addPriviledge(Priviledges.kPublishAudioStream, privilegeExpiredTs)
            this.key.addPriviledge(Priviledges.kPublishVideoStream, privilegeExpiredTs)
            this.key.addPriviledge(Priviledges.kPublishDataStream, privilegeExpiredTs)
        }
        return this.key.build();
    }
}

module.exports.RTCTokenBuilder = RTCTokenBuilder;
module.exports.Role = Role;