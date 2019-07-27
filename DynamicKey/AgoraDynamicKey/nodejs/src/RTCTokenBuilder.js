const AccessToken = require('../src/AccessToken').AccessToken
const Priviledges = require('../src/AccessToken').priviledges

const Role = {
    ATTENDEE: 0,
    PUBLISHER: 1,
    SUBSCRIBER: 2,
    ADMIN: 101
}

class RTCTokenBuilder {

   /**
    * @param {*} appID  The App ID issued to you by Agora. Apply for a new App ID from 
    *        Agora Dashboard if it is missing from your kit. See Get an App ID.
    * @param {*} appCertificate:	Certificate of the application that you registered in 
    *                  the Agora Dashboard. See Get an App Certificate.
    * @param {*} channelName: Unique channel name for the AgoraRTC session in the string format
    * @param {*} uid: User ID. A 32-bit unsigned integer with a value ranging from 
    *      1 to (232-1). optionalUid must be unique.
    * @param {*} role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
    *       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
    * @param {*} privilegeExpiredTs: represented by the number of seconds elapsed since 
    *                    1/1/1970. If, for example, you want to access the
    *                    Agora Service within 10 minutes after the token is 
    *                    generated, set expireTimestamp as the current 
    *                    timestamp + 600 (seconds).
    * @return token
    */
    static buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs) {
        return this.buildTokenWithAccount(appID, appCertificate, channelName, uid, role, privilegeExpiredTs)
    }

    /**
     * @param {*} appID: The App ID issued to you by Agora. Apply for a new App ID from 
     *       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param {*} appCertificate:	Certificate of the application that you registered in 
     *                 the Agora Dashboard. See Get an App Certificate.
     * @param {*} channelName:Unique channel name for the AgoraRTC session in the string format
     * @param {*} account: The user account. 
     * @param {*} role : Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
     *      Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
     * @param {*} privilegeExpiredTs : represented by the number of seconds elapsed since 
     *                   1/1/1970. If, for example, you want to access the
     *                   Agora Service within 10 minutes after the token is 
     *                   generated, set expireTimestamp as the current 
     * @return token
     */
    static buildTokenWithAccount(appID, appCertificate, channelName, account, role, privilegeExpiredTs) {
        this.key = new AccessToken(appID, appCertificate, channelName, account)
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