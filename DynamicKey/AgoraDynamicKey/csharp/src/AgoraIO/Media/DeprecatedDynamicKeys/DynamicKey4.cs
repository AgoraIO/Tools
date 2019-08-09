using System;
using System.IO;

namespace AgoraIO.Media
{
    public class DynamicKey4
    {
        private static String PUBLIC_SHARING_SERVICE = "APSS";
        private static String RECORDING_SERVICE = "ARS";
        private static String MEDIA_CHANNEL_SERVICE = "ACS";
        /**
         * Generate Dynamic Key for Public Sharing Service
         * @param appID App IDassigned by Agora
         * @param appCertificate App Certificate assigned by Agora
         * @param channelName name of channel to join, limited to 64 bytes and should be printable ASCII characters
         * @param unixTs unix timestamp in seconds when generating the Dynamic Key
         * @param randomInt salt for generating dynamic key
         * @param uid user id, range from 0 - max uint32
         * @param expiredTs should be 0
         * @return String representation of dynamic key
         * @throws Exception if any error occurs
         */
        public static String generatePublicSharingKey(String appID, String appCertificate, String channelName, int unixTs, int randomInt, string uid, int expiredTs)// throws Exception
        {
            return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, PUBLIC_SHARING_SERVICE);
        }


        /**
         * Generate Dynamic Key for recording service
         * @param appID Vendor key assigned by Agora
         * @param appCertificate Sign key assigned by Agora
         * @param channelName name of channel to join, limited to 64 bytes and should be printable ASCII characters
         * @param unixTs unix timestamp in seconds when generating the Dynamic Key
         * @param randomInt salt for generating dynamic key
         * @param uid user id, range from 0 - max uint32
         * @param expiredTs should be 0
         * @return String representation of dynamic key
         * @throws Exception if any error occurs
         */
        public static String generateRecordingKey(String appID, String appCertificate, String channelName, int unixTs, int randomInt, string uid, int expiredTs)// throws Exception
        {
            return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, RECORDING_SERVICE);
        }

        /**
         * Generate Dynamic Key for media channel service
         * @param appID Vendor key assigned by Agora
         * @param appCertificate Sign key assigned by Agora
         * @param channelName name of channel to join, limited to 64 bytes and should be printable ASCII characters
         * @param unixTs unix timestamp in seconds when generating the Dynamic Key
         * @param randomInt salt for generating dynamic key
         * @param uid user id, range from 0 - max uint32
         * @param expiredTs service expiring timestamp. After this timestamp, user will not be able to stay in the channel.
         * @return String representation of dynamic key
         * @throws Exception if any error occurs
         */
        public static String generateMediaChannelKey(String appID, String appCertificate, String channelName, int unixTs, int randomInt, string uid, int expiredTs)// throws Exception
        {
            return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, MEDIA_CHANNEL_SERVICE);
        }

        private static String doGenerate(String appID, String appCertificate, String channelName, int unixTs, int randomInt, string uid, int expiredTs, String serviceType) //throws Exception
        {
            String version = "004";
            String unixTsStr = ("0000000000" + unixTs).Substring(unixTs.ToString().Length);

            String randomIntStr = ("00000000" + randomInt.ToString("x4")).Substring(randomInt.ToString("x4").Length);
            //uid = uid & 0xFFFFFFFFL;
            String uidStr = uid; //("0000000000" + uid.ToString()).Substring(uid.ToString().Length);
            String expiredTsStr = ("0000000000" + expiredTs.ToString()).Substring(expiredTs.ToString().Length);


            //String randomIntStr = ("00000000" + Integer.toHexString(randomInt)).Substring(Integer.toHexString(randomInt).length());
            //uid = uid & 0xFFFFFFFFL;
            //String uidStr = ("0000000000" + Long.toString(uid)).Substring(Long.toString(uid).length());
            //String expiredTsStr = ("0000000000" + Integer.toString(expiredTs)).Substring(Integer.toString(expiredTs).length());
            String signature = generateSignature4(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr, serviceType);
            return String.Format("{0}{1}{2}{3}{4}{5}", version, signature, appID, unixTsStr, randomIntStr, expiredTsStr);
        }

        private static String generateSignature4(String appID, String appCertificate, String channelName, String unixTsStr, String randomIntStr, String uidStr, String expiredTsStr, String serviceType) //throws Exception
        {
            using (var ms = new MemoryStream())
            using (BinaryWriter baos = new BinaryWriter(ms))
            {
                baos.Write(serviceType.getBytes());
                baos.Write(appID.getBytes());
                baos.Write(unixTsStr.getBytes());
                baos.Write(randomIntStr.getBytes());
                baos.Write(channelName.getBytes());
                baos.Write(uidStr.getBytes());
                baos.Write(expiredTsStr.getBytes());

                byte[] sign = DynamicKeyUtil.encodeHMAC(appCertificate, ms.ToArray());
                return DynamicKeyUtil.bytesToHex(sign);
            }


            //byte[] sign = DynamicKeyUtil.encodeHMAC(appCertificate, baos.toByteArray());
            //return DynamicKeyUtil.bytesToHex(sign);
        }
    }
}
