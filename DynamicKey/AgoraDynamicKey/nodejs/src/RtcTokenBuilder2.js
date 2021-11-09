const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceRtc = require('../src/AccessToken2').ServiceRtc

const Role = {
    // for live broadcaster
    PUBLISHER: 1,

    // default, for live audience
    SUBSCRIBER: 2,
}

class RtcTokenBuilder {
    /**
     * Builds an RTC token using an Integer uid.
     * @param {*} appId  The App ID issued to you by Agora.
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
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} expire represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    static buildTokenWithUid(appId, appCertificate, channelName, uid, role, expire) {
        return this.buildTokenWithUserAccount(appId, appCertificate, channelName, uid, role, expire)
    }

    /**
     * Builds an RTC token using an Integer uid.
     * @param {*} appId  The App ID issued to you by Agora.
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
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} expire represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    static buildTokenWithUserAccount(appId, appCertificate, channelName, account, role, expire) {
        let token = new AccessToken(appId, appCertificate, null, expire)

        let serviceRtc = new ServiceRtc(channelName, account)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
        if (role == Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)
        }
        token.add_service(serviceRtc)

        return token.build()
    }
}

module.exports.RtcTokenBuilder = RtcTokenBuilder
module.exports.Role = Role
