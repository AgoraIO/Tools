using System;
using System.Security.Cryptography;
using System.Text;

namespace AgoraIO.Media
{
    public class SignalingToken
    {
        public static String getToken(String appId, String certificate, String account, int expiredTsInSeconds)
        {
            StringBuilder digest_String = new StringBuilder().Append(account).Append(appId).Append(certificate).Append(expiredTsInSeconds);
            var md5 = MD5.Create();
            byte[] output = md5.ComputeHash(Encoding.UTF8.GetBytes(digest_String.ToString()));
            String token = hexlify(output);
            String token_String = new StringBuilder().Append("1").Append(":").Append(appId).Append(":").Append(expiredTsInSeconds).Append(":").Append(token).ToString();
            return token_String;
        }

        public static String hexlify(byte[] data)
        {
            char[] DIGITS_LOWER = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
            char[] toDigits = DIGITS_LOWER;
            int l = data.Length;
            char[] outCharArray = new char[l << 1];
            // two characters form the hex value.
            for (int i = 0, j = 0; i < l; i++)
            {
                outCharArray[j++] = toDigits[(uint)(0xF0 & data[i]) >> 4];
                //outCharArray[j++] = toDigits[rightMove((0xF0 & data[i]), 4)];
                outCharArray[j++] = toDigits[0x0F & data[i]];
            }
            return new string(outCharArray);
        }
    }
}
