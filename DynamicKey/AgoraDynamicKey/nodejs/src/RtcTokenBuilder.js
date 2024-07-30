const AccessToken = require('../src/AccessToken').AccessToken
const Priviledges = require('../src/AccessToken').priviledges

const Role = {
    // DEPRECATED. Role::ATTENDEE has the same privileges as Role.PUBLISHER.
    ATTENDEE: 0,

    // RECOMMENDED. Use this role for a voice/video call or a live broadcast, if your scenario does not require authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
    PUBLISHER: 1,

    /* Only use this role if your scenario require authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
     * @note In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role.SUBSCRIBER still has the same privileges as Role.PUBLISHER.
     */
    SUBSCRIBER: 2,

    // DEPRECATED. Role.ADMIN has the same privileges as Role.PUBLISHER.
    ADMIN: 101
}

class RtcTokenBuilder {
    /**
     * Builds an RTC token using an Integer uid.
     * @param {*} appID  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} uid User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} privilegeExpiredTs  represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    static buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs) {
        return this.buildTokenWithAccount(appID, appCertificate, channelName, uid, role, privilegeExpiredTs)
    }

    /**
     * Builds an RTC token with account.
     * @param {*} appID  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} account The user account.
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} privilegeExpiredTs  represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    static buildTokenWithAccount(appID, appCertificate, channelName, account, role, privilegeExpiredTs) {
        this.key = new AccessToken(appID, appCertificate, channelName, account)
        this.key.addPriviledge(Priviledges.kJoinChannel, privilegeExpiredTs)
        if (role == Role.ATTENDEE || role == Role.PUBLISHER || role == Role.ADMIN) {
            this.key.addPriviledge(Priviledges.kPublishAudioStream, privilegeExpiredTs)
            this.key.addPriviledge(Priviledges.kPublishVideoStream, privilegeExpiredTs)
            this.key.addPriviledge(Priviledges.kPublishDataStream, privilegeExpiredTs)
        }
        return this.key.build()
    }
}

module.exports.RtcTokenBuilder = RtcTokenBuilder
module.exports.Role = Role
