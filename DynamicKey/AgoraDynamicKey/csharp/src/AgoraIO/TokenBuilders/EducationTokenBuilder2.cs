using System.Security.Cryptography;

namespace AgoraIO.Media
{
    public class EducationTokenBuilder2
    {
        /**
        * build user room token
        *
        * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
        *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
        * @param appCertificate Certificate of the application that you registered in
        *                       the Agora Dashboard. See Get an App Certificate.
        * @param roomUuid       The room's id, must be unique.
        * @param userUuid       The user's id, must be unique.
        * @param role           The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
        * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
        *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
        * @return The education user room token.
        */
        public string buildRoomUserToken(string appId, string appCertificate, string roomUuid, string userUuid, short role, int expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);

            var md5 = MD5.Create();
            string chatUserId = md5.ComputeHash(userUuid.getBytes()).ToString();

            AccessToken2.Service serviceEducation = new AccessToken2.ServiceEducation(roomUuid, userUuid, role);
            serviceEducation.addPrivilegeEducation(AccessToken2.PrivilegeEducationEnum.PRIVILEGE_ROOM_USER, expire);
            accessToken.addService(serviceEducation);

            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(userUuid);
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, expire);
            accessToken.addService(serviceRtm);

            AccessToken2.Service serviceChat = new AccessToken2.ServiceChat(chatUserId);
            serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_USER, expire);
            accessToken.addService(serviceChat);

            return accessToken.build();
        }

        /**
         * build user individual token
         *
         * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
         *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate Certificate of the application that you registered in
         *                       the Agora Dashboard. See Get an App Certificate.
         * @param userUuid       The user's id, must be unique.
         * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
         * @return The education user token.
         */
        public string buildUserToken(string appId, string appCertificate, string userUuid, int expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            AccessToken2.Service service = new AccessToken2.ServiceEducation(userUuid);

            service.addPrivilegeEducation(AccessToken2.PrivilegeEducationEnum.PRIVILEGE_USER, expire);
            accessToken.addService(service);

            return accessToken.build();
        }

        /**
         * build app global token
         *
         * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
         *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate Certificate of the application that you registered in
         *                       the Agora Dashboard. See Get an App Certificate.
         * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
         * @return The education global token.
         */
        public string buildAppToken(string appId, string appCertificate, int expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            AccessToken2.Service serviceEducation = new AccessToken2.ServiceEducation();

            serviceEducation.addPrivilegeEducation(AccessToken2.PrivilegeEducationEnum.PRIVILEGE_APP, expire);
            accessToken.addService(serviceEducation);

            return accessToken.build();
        }
    }
}
