using System;
using System.IO;

namespace AgoraIO.Media
{
    public class DynamicKey3
    {
        public static String generate(String appID, String appCertificate, String channelName, int unixTs, int randomInt, long uid, int expiredTs) //throws Exception
        {
            String version = "003";
            String unixTsStr = ("0000000000" + unixTs).Substring(unixTs.ToString().Length);
            String randomIntStr = ("00000000" + randomInt.ToString("x4")).Substring(randomInt.ToString("x4").Length);
            uid = uid & 0xFFFFFFFFL;
            String uidStr = ("0000000000" + uid.ToString()).Substring(uid.ToString().Length);
            String expiredTsStr = ("0000000000" + expiredTs.ToString()).Substring(expiredTs.ToString().Length);
            String signature = generateSignature3(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr);
            return String.Format("{0}{1}{2}{3}{4}{5}{6}", version, signature, appID, unixTsStr, randomIntStr, uidStr, expiredTsStr);
        }

        public static String generateSignature3(String appID, String appCertificate, String channelName, String unixTsStr, String randomIntStr, String uidStr, String expiredTsStr)// throws Exception
        {
            using (var ms = new MemoryStream())
            using (BinaryWriter baos = new BinaryWriter(ms))
            {
                baos.Write(appID.GetByteArray());
                baos.Write(unixTsStr.GetByteArray());
                baos.Write(randomIntStr.GetByteArray());
                baos.Write(channelName.GetByteArray());
                baos.Write(uidStr.GetByteArray());
                baos.Write(expiredTsStr.GetByteArray());
                baos.Flush();

                byte[] sign = DynamicKeyUtil.encodeHMAC(appCertificate, ms.ToArray());
                return DynamicKeyUtil.bytesToHex(sign);
            }
        }
    }
}
