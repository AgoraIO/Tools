module.exports = {
    ApaasTokenBuilder: require('./src/ApaasTokenBuilder').ApaasTokenBuilder,
    ChatTokenBuilder: require('./src/ChatTokenBuilder').ChatTokenBuilder,
    EducationTokenBuilder: require('./src/EducationTokenBuilder').EducationTokenBuilder,
    FpaTokenBuilder: require('./src/FpaTokenBuilder').FpaTokenBuilder,
    RtcRole: require('./src/RtcTokenBuilder2').Role,
    RtcTokenBuilder: require('./src/RtcTokenBuilder2').RtcTokenBuilder,
    /**
     * @attention This is a special interface that requires Agora assistance for proper 
     * usage. Please seek help from Agora before using this interface to avoid unknown 
     * errors in your application.
     */
    RtmTokenBuilder: require('./src/token3/RtmTokenBuilder3').RtmTokenBuilder,
    RtmPermission: require('./src/token3/RtmTokenBuilder3').RtmPermission
}
