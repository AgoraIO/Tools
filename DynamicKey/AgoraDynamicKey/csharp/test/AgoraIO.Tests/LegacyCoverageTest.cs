using System.Collections.Generic;
using System.IO;
using System.Text;
using AgoraIO.Media;
using Xunit;

namespace AgoraIO.Tests
{
    public class LegacyCoverageTest
    {
        // Verifies dynamic buffer writes, reads, growth, reset, and bounds behavior.
        [Fact]
        public void byteBufferRoundTripsAndHandlesBounds()
        {
            ByteBuffer buffer = new ByteBuffer();
            buffer.PushByte(7);
            buffer.PushUInt16(0x1234);
            buffer.PushInt(0x12345678);
            buffer.PushLong(0x01020304);
            buffer.PushByteArray(new byte[2048]);

            Assert.Equal(2059, buffer.Length);
            Assert.Equal((byte)7, buffer.PopByte());
            Assert.Equal((ushort)0x1234, buffer.PopUInt16());
            Assert.Equal((uint)0x12345678, buffer.PopUInt());
            Assert.Equal(0x04030201, buffer.PopLong());
            Assert.Equal(2048, buffer.PopByteArray(2048).Length);
            Assert.Empty(buffer.PopByteArray(1));

            buffer.Initialize();
            Assert.Equal(0, buffer.Length);
            Assert.Equal((ushort)0, buffer.PopUInt16());
            Assert.Equal((uint)0, buffer.PopUInt());
            Assert.Equal(0, buffer.PopLong());

            buffer = new ByteBuffer(new byte[] { 1, 2, 3, 4 });
            Assert.Equal(new byte[] { 1, 2, 3 }, buffer.PopByteArray(3));
            Assert.Equal(new byte[] { 2, 3 }, buffer.PopByteArray2(2));
            Assert.Empty(buffer.PopByteArray2(2));
            buffer.Position = 4;
            Assert.Equal(4, buffer.Position);
            Assert.Equal(new byte[] { 3, 4 }, buffer.PopByteArray2(2));
        }

        // Verifies legacy packable payloads and UTF-8 extension methods.
        [Fact]
        public void legacyPayloadsRoundTrip()
        {
            byte[] signature = new byte[] { 1, 2, 3 };
            byte[] rawMessage = new byte[] { 4, 5 };
            PackContent content = new PackContent(signature, 11, 12, rawMessage);
            PackContent parsedContent = new PackContent();
            parsedContent.unmarshal(new ByteBuf(content.marshal(new ByteBuf()).asBytes()));

            Assert.Equal(signature, parsedContent.signature);
            Assert.Equal((uint)11, parsedContent.crcChannelName);
            Assert.Equal((uint)12, parsedContent.crcUid);
            Assert.Equal(rawMessage, parsedContent.rawMessage);

            PrivilegeMessage message = new PrivilegeMessage
            {
                salt = 1,
                ts = 2,
                messages = new Dictionary<ushort, uint> { { 3, 4 } }
            };
            PrivilegeMessage parsedMessage = new PrivilegeMessage();
            parsedMessage.unmarshal(new ByteBuf(message.marshal(new ByteBuf()).asBytes()));
            Assert.Equal(message.salt, parsedMessage.salt);
            Assert.Equal(message.ts, parsedMessage.ts);
            Assert.Equal(message.messages, parsedMessage.messages);

            using MemoryStream stream = new MemoryStream();
            stream.write("value");
            Assert.Equal("value", stream.ToArray().getString());
            Assert.Equal(Encoding.UTF8.GetBytes("value"), "value".GetByteArray());
            Assert.Equal(Encoding.UTF8.GetBytes("value"), "value".getBytes());
        }

        // Verifies every supported HMAC algorithm and hexadecimal conversion.
        [Fact]
        public void dynamicKeyUtilitiesSupportAllAlgorithms()
        {
            foreach (string algorithm in new[] { "MD5", "SHA1", "SHA256", "SHA384", "SHA512", "unknown" })
            {
                byte[] digest = DynamicKeyUtil.encodeHMAC("key", Encoding.UTF8.GetBytes("message"), algorithm);
                Assert.NotEmpty(digest);
                Assert.Equal(digest.Length * 2, DynamicKeyUtil.bytesToHex(digest).Length);
            }

            Assert.Equal(
                DynamicKeyUtil.encodeHMAC("key", Encoding.UTF8.GetBytes("message"), "SHA256"),
                DynamicKeyUtil.encodeHMAC(Encoding.UTF8.GetBytes("key"), Encoding.UTF8.GetBytes("message"), "SHA256")
            );
        }

        // Verifies direct FPA and APaaS service serialization and constructors.
        [Fact]
        public void extendedServicesRoundTrip()
        {
            AccessToken2.ServiceFpa fpa = new AccessToken2.ServiceFpa();
            fpa.addPrivilegeFpa(AccessToken2.PrivilegeFpaEnum.PRIVILEGE_LOGIN, 600);
            AccessToken2.ServiceFpa parsedFpa = new AccessToken2.ServiceFpa();
            byte[] packedFpa = fpa.pack(new ByteBuf()).asBytes();
            parsedFpa.unpack(new ByteBuf(packedFpa[2..]));
            Assert.Equal(fpa.getPrivileges(), parsedFpa.getPrivileges());

            foreach (AccessToken2.ServiceApaas apaas in new[]
            {
                new AccessToken2.ServiceApaas(),
                new AccessToken2.ServiceApaas("user"),
                new AccessToken2.ServiceApaas("room", "user", 2)
            })
            {
                apaas.addPrivilegeApaas(AccessToken2.PrivilegeApaasEnum.PRIVILEGE_ROOM_USER, 600);
                AccessToken2.ServiceApaas parsed = new AccessToken2.ServiceApaas();
                byte[] packed = apaas.pack(new ByteBuf()).asBytes();
                parsed.unpack(new ByteBuf(packed[2..]));
                Assert.Equal(apaas.getRoomUuid(), parsed.getRoomUuid());
                Assert.Equal(apaas.getUserUuid(), parsed.getUserUuid());
                Assert.Equal(apaas.getRole(), parsed.getRole());
            }
        }
    }
}
