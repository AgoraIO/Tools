using System;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace AgoraIO.Media
{
    public class Utils
    {
        public static int VERSION_LENGTH = 3;
        public static int APP_ID_LENGTH = 32;

        public static int getTimestamp()
        {
            TimeSpan t = DateTime.Now - new DateTime(1970, 1, 1);
            return (int)t.TotalSeconds;
        }

        public static int randomInt()
        {
            RNGCryptoServiceProvider rngCsp = new RNGCryptoServiceProvider();
            byte[] bytes = new byte[4];
            rngCsp.GetBytes(bytes);
            return BitConverter.ToInt32(bytes, 0);
        }

        public static byte[] pack(PrivilegeMessage packableEx)
        {
            ByteBuf buffer = new ByteBuf();
            packableEx.marshal(buffer);
            return buffer.asBytes();
        }

        public static byte[] pack(IPackable packableEx)
        {
            ByteBuf buffer = new ByteBuf();
            packableEx.marshal(buffer);
            return buffer.asBytes();
        }

        public static string base64Encode(byte[] data)
        {
            return Convert.ToBase64String(data);
        }
       

        public static byte[] base64Decode(String data)
        {
            return Convert.FromBase64String(data);
        }

        public static void unpack(byte[] data, IPackable packableEx)
        {
            ByteBuf buffer = new ByteBuf(data);
            packableEx.unmarshal(buffer);
        }

        public static bool isUUID(string uuid)
        {
            if (uuid.Length != 32)
            {
                return false;
            }
            Regex regex = new Regex(@"[A-Fa-f0-9]+$");
            Match m = regex.Match(uuid);
            return m.Success;
        }
    }
}
