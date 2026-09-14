import { AccessToken2 as AccessToken, ServiceRtc, ServiceRtm, ServiceStt } from '../src/AccessToken2.js'
import { Role } from '../src/RtcTokenBuilder2.js'

class SttTokenBuilder {
    /**
     * Builds an STT token with RTC and RTM services.
     * @param {*} appId The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} account The account used by both RTC and RTM, max length is 255 bytes.
     * @param {*} tokenExpire Represented by the number of seconds elapsed since now. Defaults to 86400. This
     * is the whole token expiration. The whole token is invalid after this time, even if a privilege
     * expiration time is later.
     * @param {*} privilegeExpire Represented by the number of seconds elapsed since now. Defaults to 0. This
     * value must not exceed tokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @return The STT token.
     */
    static buildToken(appId, appCertificate, channelName, account, tokenExpire = 86400, privilegeExpire = 0) {
        return this.buildTokenWithPrivilege(
            appId, appCertificate, channelName, account, Role.PUBLISHER, tokenExpire,
            privilegeExpire, privilegeExpire, privilegeExpire, privilegeExpire, account, privilegeExpire,
        )
    }

    /**
     * Builds an STT token with RTC and RTM services.
     * @param {*} appId The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} rtcAccount The RTC user's account, max length is 255 bytes.
     * @param {*} rtcRole Role.PUBLISHER for a broadcaster or Role.SUBSCRIBER for an audience member.
     * @param {*} rtcTokenExpire Represented by the number of seconds elapsed since now. This is the whole
     * token expiration. The whole token is invalid after this time, even if a privilege expiration time is
     * later.
     * @param {*} joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now. This
     * value must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now. This
     * value must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} rtmUserId The RTM user's account, max length is 255 bytes.
     * @param {*} rtmTokenExpire Represented by the number of seconds elapsed since now. This value must not
     * exceed rtcTokenExpire; otherwise, the RTM login privilege is limited by the token expiration time.
     * @return The STT token.
     */
    static buildTokenWithPrivilege(
        appId,
        appCertificate,
        channelName,
        rtcAccount,
        rtcRole,
        rtcTokenExpire,
        joinChannelPrivilegeExpire,
        pubAudioPrivilegeExpire,
        pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire,
        rtmUserId,
        rtmTokenExpire,
    ) {
        const token = new AccessToken(appId, appCertificate, 0, rtcTokenExpire)

        const serviceRtc = new ServiceRtc(channelName, rtcAccount)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, joinChannelPrivilegeExpire)
        if (rtcRole === Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pubAudioPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pubVideoPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
        }
        token.add_service(serviceRtc)

        const serviceRtm = new ServiceRtm(rtmUserId)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, rtmTokenExpire)
        token.add_service(serviceRtm)

        token.add_service(new ServiceStt())

        return token.build()
    }
}

export { SttTokenBuilder }
