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
         * @param role           The user's role.
         * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
         * @return The user room token.
         */
        public static string buildRoomUserToken(string appId, string appCertificate, string roomUuid, string userUuid, short role, uint expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);

            var md5 = MD5.Create();
            string chatUserId = md5.ComputeHash(userUuid.getBytes()).ToString();

            AccessToken2.Service serviceApaas = new AccessToken2.ServiceApaas(roomUuid, userUuid, role);
            serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaasEnum.PRIVILEGE_ROOM_USER, expire);
            accessToken.addService(serviceApaas);

            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(userUuid);
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, expire);
            accessToken.addService(serviceRtm);

            AccessToken2.Service serviceChat = new AccessToken2.ServiceChat(chatUserId);
            serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_USER, expire);
            accessToken.addService(serviceChat);

            return accessToken.build();
        }

        /**
         * build user token
         *
         * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
         *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate Certificate of the application that you registered in
         *                       the Agora Dashboard. See Get an App Certificate.
         * @param userUuid       The user's id, must be unique.
         * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
         * @return The user token.
         */
        public static string buildUserToken(string appId, string appCertificate, string userUuid, uint expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            AccessToken2.Service service = new AccessToken2.ServiceApaas(userUuid);

            service.addPrivilegeApaas(AccessToken2.PrivilegeApaasEnum.PRIVILEGE_USER, expire);
            accessToken.addService(service);

            return accessToken.build();
        }

        /**
         * build app token
         *
         * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
         *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate Certificate of the application that you registered in
         *                       the Agora Dashboard. See Get an App Certificate.
         * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
         * @return The app token.
         */
        public static string buildAppToken(string appId, string appCertificate, uint expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            AccessToken2.Service serviceApaas = new AccessToken2.ServiceApaas();

            serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaasEnum.PRIVILEGE_APP, expire);
            accessToken.addService(serviceApaas);

            return accessToken.build();
        }
    }
}
