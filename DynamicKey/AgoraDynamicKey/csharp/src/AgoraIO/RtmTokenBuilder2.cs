using AgoraIO.Media;
using System;
using System.Collections.Generic;
using System.Text;

namespace AgoraIO.Rtm
{
    public class RtmTokenBuilder
    {
        public enum Role
        {
            RoleRtmUser = 1,
        }

        // buildToken
        // appID: The App ID issued to you by Agora. Apply for a new App ID from
        //        Agora Dashboard if it is missing from your kit. See Get an App ID.
        // appCertificate:	Certificate of the application that you registered in
        //                  the Agora Dashboard. See Get an App Certificate.
        // userAccount: The user account.
        // privilegeExpireTs: represented by the number of seconds elapsed since
        //                    1/1/1970. If, for example, you want to access the
        //                    Agora Service within 10 minutes after the token is
        //                    generated, set expireTimestamp as the current
        //                    timestamp + 600 (seconds)./
        public static string buildToken(string appId, string appCertificate, string userAccount, uint privilegeExpiredTs)
        {
            AccessToken accessToken = new AccessToken(appId, appCertificate, userAccount, "");
            accessToken.addPrivilege(Privileges.kRtmLogin, privilegeExpiredTs);

            return accessToken.build();
        }
    }
}
