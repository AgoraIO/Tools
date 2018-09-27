package io.agora.media.sample;

import io.agora.media.AccessToken;
import io.agora.media.Utils;

public class AccessTokenSample {
    static String appId = "970CA35de60c44645bbae8a215061b33";
    static String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    static String channelName = "7d72365eb983485397e3e3f9d460bdda";
    static String uid = "2882341273";
    static int expireTimestamp = 0;

    public static void main(String[] args) throws Exception {
        AccessToken token = new AccessToken(appId, appCertificate, channelName, uid);
        token.addPrivilege(AccessToken.Privileges.kJoinChannel, expireTimestamp);
        String result = token.build();
        System.out.println(result);

        AccessToken t = new AccessToken("", "", "");
        t.fromString(result);

        System.out.println();
        System.out.print("\nappId:\t" + t.appId);
        System.out.print("\nappCertificate:\t" + t.appCertificate);
        System.out.print("\nCRC channelName:\t" + t.crcChannelName + " crc calculated " + Utils.crc32(channelName));
        System.out.print("\nCRC uid:\t" + t.crcUid + " crc calculated " + Utils.crc32(uid));
        System.out.print("\nts:\t" + t.message.ts);
        System.out.print("\nsalt:\t" + t.message.salt);
    }
}
