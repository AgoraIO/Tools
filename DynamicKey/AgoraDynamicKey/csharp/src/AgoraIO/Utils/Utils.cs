using System;
using System.Text.RegularExpressions;
using System.IO;
using ICSharpCode.SharpZipLib.Zip.Compression.Streams;

namespace AgoraIO.Media
{
    public class Utils
    {
        // Returns the current Unix timestamp in seconds.
        public static int getTimestamp()
        {
            return (int)new DateTimeOffset(DateTime.UtcNow).ToUnixTimeSeconds();
        }

        // Returns a non-negative pseudo-random integer.
        public static int randomInt()
        {
            return new Random().Next();
        }

        // Serializes a privilege message into bytes.
        public static byte[] pack(PrivilegeMessage packableEx)
        {
            ByteBuf buffer = new ByteBuf();
            packableEx.marshal(buffer);
            return buffer.asBytes();
        }

        // Serializes an IPackable value into bytes.
        public static byte[] pack(IPackable packableEx)
        {
            ByteBuf buffer = new ByteBuf();
            packableEx.marshal(buffer);
            return buffer.asBytes();
        }

        // Encodes bytes as a Base64 string.
        public static string base64Encode(byte[] data)
        {
            return Convert.ToBase64String(data);
        }

        // Decodes a Base64 string into bytes.
        public static byte[] base64Decode(string data)
        {
            return Convert.FromBase64String(data);
        }

        // Reports whether a value is a 32-character hexadecimal identifier.
        public static bool isUUID(string uuid)
        {
            if (string.IsNullOrEmpty(uuid) || uuid.Length != 32)
            {
                return false;
            }

            Regex regex = new Regex("^[0-9a-fA-F]{32}$");
            return regex.IsMatch(uuid);
        }

        // Compresses bytes with zlib.
        public static byte[] compress(byte[] data)
        {
            byte[] output;
            using (MemoryStream outputStream = new MemoryStream())
            {
                using (var zlibStream = new DeflaterOutputStream(outputStream))
                {
                    zlibStream.Write(data, 0, data.Length);
                }
                output = outputStream.ToArray();
            }

            return output;
        }

        // Decompresses zlib-compressed bytes.
        public static byte[] decompress(byte[] data)
        {
            byte[] output;
            using (MemoryStream inputStream = new MemoryStream(data))
            using (MemoryStream outputStream = new MemoryStream())
            {
                using (var zlibStream = new InflaterInputStream(inputStream))
                {
                    zlibStream.CopyTo(outputStream);
                }
                output = outputStream.ToArray();
            }

            return output;
        }
    }
}
