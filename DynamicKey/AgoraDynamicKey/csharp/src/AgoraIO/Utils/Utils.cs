using System;

namespace AgoraIO.Media
{
    public class Utils
    {
        public static int getTimestamp()
        {
            return (int)new DateTimeOffset(DateTime.UtcNow).ToUnixTimeSeconds();
        }

        public static int randomInt()
        {
            return new Random().Next();
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
    }
}
