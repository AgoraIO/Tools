
export namespace RtcRole {
    export const PUBLISHER: number;
    export const SUBSCRIBER: number;
}

export namespace RtcTokenBuilder {

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
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} privilegeExpiredTs  represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    export function buildTokenWithUid(appID: string, appCertificate: string, channelName: string, uid: number, role: number, privilegeExpiredTs: number): string;

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
     * @param {*} account The user account.
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} privilegeExpiredTs  represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
     * @return The new Token.
     */
    export function buildTokenWithAccount(appID: string, appCertificate: string, channelName: string, account: string, role: number, privilegeExpiredTs: number): string;
}

export namespace RtmTokenBuilder {

    /**
     * @param {*} appID: The App ID issued to you by Agora. Apply for a new App ID from 
     *       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param {*} appCertificate:	Certificate of the application that you registered in 
     *                 the Agora Dashboard. See Get an App Certificate.
     * @param {*} account: The user account. 
     * @param {*} role : Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
     *      Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
     * @param {*} privilegeExpiredTs : represented by the number of seconds elapsed since 
     *                   1/1/1970. If, for example, you want to access the
     *                   Agora Service within 10 minutes after the token is 
     *                   generated, set expireTimestamp as the current 
     * @return token
     */
    export function buildToken(appID: string, appCertificate: string, account: string | number, role: number, privilegeExpiredTs: number): string;

}

export namespace RtmRole {
    export const Rtm_User: number;
}

export namespace RtmTokenBuilder {

    /**
     * @param {*} appID: The App ID issued to you by Agora. Apply for a new App ID from 
     *       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param {*} appCertificate:	Certificate of the application that you registered in 
     *                 the Agora Dashboard. See Get an App Certificate.
     * @param {*} account: The user account. 
     * @param {*} role : Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
     *      Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
     * @param {*} privilegeExpiredTs : represented by the number of seconds elapsed since 
     *                   1/1/1970. If, for example, you want to access the
     *                   Agora Service within 10 minutes after the token is 
     *                   generated, set expireTimestamp as the current 
     * @return token
     */
    export function buildToken(appID: string, appCertificate: string, account: string | number, role: number, privilegeExpiredTs: number): string;
}