using AgoraIO.Media;
using System;
using System.Collections.Generic;
using System.Text;

namespace AgoraIO.Rtm
{
    public class RtmTokenBuilder
    {

        public AccessToken mTokenCreator;

        public string buildToken(string appId, string appCertificate, string uid, uint privilegeTs)
        {
            mTokenCreator = new AccessToken(appId, appCertificate, uid, "");
            mTokenCreator.addPrivilege(Privileges.kRtmLogin, privilegeTs);
            return mTokenCreator.build();
        }
    }
}
