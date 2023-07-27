using System;
using System.Text.RegularExpressions;
using System.IO;
using Ionic.Zlib;

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

        public static byte[] base64Decode(string data)
        {
            return Convert.FromBase64String(data);
        }

        public static bool isUUID(string uuid)
        {
            if (uuid.Length != 32)
            {
                return false;
            }

            Regex regex = new Regex("^[0-9a-fA-F]{32}$");
            return regex.IsMatch(uuid);
        }

        public static byte[] compress(byte[] data)
        {
            byte[] output;
            using (MemoryStream outputStream = new MemoryStream())
            {
                using (var zlibStream = new ZlibStream(outputStream, CompressionMode.Compress, CompressionLevel.Level5, true)) // or use Level6
                {
                    zlibStream.Write(data, 0, data.Length);
                }
                output = outputStream.ToArray();
            }

            return output;
        }

        public static byte[] decompress(byte[] data)
        {
            byte[] output;
            using (MemoryStream outputStream = new MemoryStream())
            {
                using (var zlibStream = new ZlibStream(outputStream, CompressionMode.Decompress))
                {
                    zlibStream.Write(data, 0, data.Length);
                }
                output = outputStream.ToArray();
            }

            return output;
        }
    }
}
