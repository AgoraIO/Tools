using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace AgoraIO.Media
{
    public class AccessToken2
    {
        private static readonly string VERSION = "007";
        private static readonly int VERSION_LENGTH = 3;

        public string _appCert = "";
        public string _appId = "";
        public uint _expire;
        public uint _issueTs;
        public uint _salt;
        public List<Service> _services = new List<Service>();

        private byte[] _signature = Array.Empty<byte>();
        private byte[] _signingInfo = Array.Empty<byte>();

        // Creates an empty token parser.
        public AccessToken2()
        {
        }

        // Creates a token builder with application credentials and expiration.
        public AccessToken2(string appId, string appCert, uint expire)
        {
            _appCert = appCert;
            _appId = appId;
            _expire = expire;
            _issueTs = (uint)Utils.getTimestamp();
            _salt = (uint)Utils.randomInt();
        }

        // Adds a service without replacing services of the same type.
        public void addService(Service service)
        {
            _services.Add(service);
        }

        // Returns all services of the requested type in insertion or token order.
        public List<Service> getServices(short serviceType)
        {
            return _services.Where(service => service.getServiceType() == serviceType).ToList();
        }

        public static short SERVICE_TYPE_RTC = 1;
        public static short SERVICE_TYPE_RTM = 2;
        public static short SERVICE_TYPE_FPA = 4;
        public static short SERVICE_TYPE_CHAT = 5;
        public static short SERVICE_TYPE_APAAS = 7;

        // Creates a known service for token parsing.
        public Service getService(short serviceType)
        {
            if (serviceType == SERVICE_TYPE_RTC)
            {
                return new ServiceRtc();
            }
            if (serviceType == SERVICE_TYPE_RTM)
            {
                return new ServiceRtm();
            }
            if (serviceType == SERVICE_TYPE_FPA)
            {
                return new ServiceFpa();
            }
            if (serviceType == SERVICE_TYPE_CHAT)
            {
                return new ServiceChat();
            }
            if (serviceType == SERVICE_TYPE_APAAS)
            {
                return new ServiceApaas();
            }
            throw new ArgumentException("unknown service type:", serviceType.ToString());
        }

        // Converts a numeric user ID to its token string representation.
        public static string getUidStr(uint uid)
        {
            if (uid == 0)
            {
                return "";
            }
            return (uid & 0xFFFFFFFFL).ToString();
        }

        // Returns the Token007 version prefix.
        public string getVersion()
        {
            return VERSION;
        }

        // Derives the signing key with the stored App Certificate.
        public byte[] getSign()
        {
            return getSign(_appCert);
        }

        // Derives the signing key with the supplied App Certificate.
        public byte[] getSign(string appCertificate)
        {
            byte[] signing = DynamicKeyUtil.encodeHMAC(BitConverter.GetBytes(_issueTs), appCertificate.getBytes(), "SHA256");
            return DynamicKeyUtil.encodeHMAC(BitConverter.GetBytes(_salt), signing, "SHA256");
        }

        // Builds a Token007 token containing all added services.
        public string build()
        {
            if (!Utils.isUUID(_appId) || !Utils.isUUID(_appCert))
            {
                return "";
            }

            List<Service> services = servicesForPacking();
            ByteBuf buf = new ByteBuf().put(_appId.getBytes()).put((uint)_issueTs).put(_expire).put((uint)_salt).put((ushort)services.Count);
            byte[] signing = getSign();

            foreach (Service service in services)
            {
                service.pack(buf);
            }

            byte[] signature = DynamicKeyUtil.encodeHMAC(signing, buf.asBytes(), "SHA256");

            ByteBuf bufferContent = new ByteBuf();
            bufferContent.put(signature);
            bufferContent.copy(buf.asBytes());

            return getVersion() + Utils.base64Encode(Utils.compress(bufferContent.asBytes()));
        }

        // Parses known services and retains the original bytes for signature verification.
        public bool parse(string token)
        {
            if (string.IsNullOrEmpty(token) || token.Length < VERSION_LENGTH ||
                getVersion().CompareTo(token.Substring(0, VERSION_LENGTH)) != 0)
            {
                return false;
            }

            try
            {
                byte[] data = Utils.decompress(Utils.base64Decode(token.Substring(VERSION_LENGTH)));

                ByteBuf buff = new ByteBuf(data);
                _signature = buff.readBytes();
                _signingInfo = data.Skip(sizeof(ushort) + _signature.Length).ToArray();
                _services.Clear();
                _appId = buff.readBytes().getString();
                _issueTs = buff.readInt();
                _expire = buff.readInt();
                _salt = buff.readInt();
                ushort servicesNum = buff.readShort();

                for (ushort i = 0; i < servicesNum; i++)
                {
                    short serviceType = (short)buff.readShort();
                    Service service = tryCreateService(serviceType);
                    if (service == null)
                    {
                        return true;
                    }
                    service.unpack(buff);
                    addService(service);
                }
            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }

        // Verifies the signature of a successfully parsed token.
        public bool verifySignature(string appCertificate)
        {
            if (_signature.Length == 0 || _signingInfo.Length == 0 ||
                string.IsNullOrEmpty(_appId) || string.IsNullOrEmpty(appCertificate) ||
                !Utils.isUUID(_appId) || !Utils.isUUID(appCertificate))
            {
                return false;
            }

            byte[] signature = DynamicKeyUtil.encodeHMAC(getSign(appCertificate), _signingInfo, "SHA256");
            return _signature.Length == signature.Length && CryptographicOperations.FixedTimeEquals(_signature, signature);
        }

        // Returns services in stable type order while preserving duplicate insertion order.
        private List<Service> servicesForPacking()
        {
            return _services
                .Select((service, index) => new { service, index })
                .OrderBy(entry => entry.service.getServiceType())
                .ThenBy(entry => entry.index)
                .Select(entry => entry.service)
                .ToList();
        }

        // Creates a known service or returns null for forward-compatible parsing.
        private Service tryCreateService(short serviceType)
        {
            if (serviceType == SERVICE_TYPE_RTC)
            {
                return new ServiceRtc();
            }
            if (serviceType == SERVICE_TYPE_RTM)
            {
                return new ServiceRtm();
            }
            if (serviceType == SERVICE_TYPE_FPA)
            {
                return new ServiceFpa();
            }
            if (serviceType == SERVICE_TYPE_CHAT)
            {
                return new ServiceChat();
            }
            if (serviceType == SERVICE_TYPE_APAAS)
            {
                return new ServiceApaas();
            }
            return null;
        }

        public enum PrivilegeRtcEnum
        {
            PRIVILEGE_JOIN_CHANNEL = 1,
            PRIVILEGE_PUBLISH_AUDIO_STREAM = 2,
            PRIVILEGE_PUBLISH_VIDEO_STREAM = 3,
            PRIVILEGE_PUBLISH_DATA_STREAM = 4
        }

        public enum PrivilegeRtmEnum
        {
            PRIVILEGE_LOGIN = 1
        }

        public enum PrivilegeFpaEnum
        {
            PRIVILEGE_LOGIN = 1
        }

        public enum PrivilegeChatEnum
        {
            PRIVILEGE_CHAT_USER = 1,
            PRIVILEGE_CHAT_APP = 2
        }
        public enum PrivilegeApaasEnum
        {
            PRIVILEGE_ROOM_USER = 1,
            PRIVILEGE_USER = 2,
            PRIVILEGE_APP = 3
        }

        public class Service
        {
            private short _type;
            private Dictionary<ushort, uint> _privileges = new Dictionary<ushort, uint>();

            // Creates an empty service for token parsing.
            public Service()
            {

            }

            // Creates a service with the specified ServiceType.
            public Service(short serviceType)
            {
                _type = serviceType;
            }

            // Adds an RTC privilege and its expiration timestamp.
            public void addPrivilegeRtc(PrivilegeRtcEnum privilege, uint expire)
            {
                _privileges.Add((ushort)privilege, expire);
            }

            // Adds an RTM privilege and its expiration timestamp.
            public void addPrivilegeRtm(PrivilegeRtmEnum privilege, uint expire)
            {
                _privileges.Add((ushort)privilege, expire);
            }

            // Adds an FPA privilege and its expiration timestamp.
            public void addPrivilegeFpa(PrivilegeFpaEnum privilege, uint expire)
            {
                _privileges.Add((ushort)privilege, expire);
            }

            // Adds a Chat privilege and its expiration timestamp.
            public void addPrivilegeChat(PrivilegeChatEnum privilege, uint expire)
            {
                _privileges.Add((ushort)privilege, expire);
            }

            // Adds an APaaS privilege and its expiration timestamp.
            public void addPrivilegeApaas(PrivilegeApaasEnum privilege, uint expire)
            {
                _privileges.Add((ushort)privilege, expire);
            }

            // Returns the service privilege expiration map.
            public Dictionary<ushort, uint> getPrivileges()
            {
                return _privileges;
            }

            // Returns the numeric ServiceType.
            public short getServiceType()
            {
                return _type;
            }

            // Sets the numeric ServiceType.
            public void setServiceType(short type)
            {
                _type = type;
            }

            // Packs the ServiceType and privileges into the token buffer.
            public virtual ByteBuf pack(ByteBuf buf)
            {
                return buf.put((ushort)_type).putIntMap(_privileges);
            }

            // Unpacks privileges after the ServiceType has been consumed.
            public virtual void unpack(ByteBuf byteBuf)
            {
                _privileges = byteBuf.readIntMap();
            }
        }

        public class ServiceRtc : Service
        {
            public string _channelName;
            public string _uid;

            // Creates an empty RTC service for token parsing.
            public ServiceRtc()
            {
                setServiceType(SERVICE_TYPE_RTC);
            }

            // Creates an RTC service for a channel and user ID.
            public ServiceRtc(string channelName, string uid)
            {
                setServiceType(SERVICE_TYPE_RTC);
                _channelName = channelName;
                _uid = uid;
            }

            // Returns the RTC channel name.
            public string getChannelName()
            {
                return _channelName;
            }

            // Returns the RTC user ID.
            public string getUid()
            {
                return _uid;
            }

            // Packs the RTC service payload into the token buffer.
            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_channelName.getBytes()).put(_uid.getBytes());
            }

            // Unpacks the RTC service payload from the token buffer.
            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _channelName = byteBuf.readBytes().getString();
                _uid = byteBuf.readBytes().getString();
            }
        }

        public class ServiceRtm : Service
        {
            public string _userId;

            // Creates an empty RTM service for token parsing.
            public ServiceRtm()
            {
                setServiceType(SERVICE_TYPE_RTM);
            }

            // Creates an RTM service for a user ID.
            public ServiceRtm(string userId)
            {
                setServiceType(SERVICE_TYPE_RTM);
                _userId = userId;
            }

            // Returns the RTM user ID.
            public string getUserId()
            {
                return _userId;
            }

            // Packs the RTM service payload into the token buffer.
            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_userId.getBytes());
            }

            // Unpacks the RTM service payload from the token buffer.
            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _userId = byteBuf.readBytes().getString();
            }
        }

        public class ServiceFpa : Service
        {
            // Creates an FPA service.
            public ServiceFpa()
            {
                setServiceType(SERVICE_TYPE_FPA);
            }

            // Packs the FPA service payload into the token buffer.
            public new ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf);
            }

            // Unpacks the FPA service payload from the token buffer.
            public new void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
            }
        }

        public class ServiceChat : Service
        {
            public string _userId;

            // Creates an application-level Chat service for token parsing or building.
            public ServiceChat()
            {
                setServiceType(SERVICE_TYPE_CHAT);
                _userId = "";
            }

            // Creates a user-level Chat service.
            public ServiceChat(string userId)
            {
                setServiceType(SERVICE_TYPE_CHAT);
                _userId = userId;
            }

            // Returns the Chat user ID, or an empty value for an app token.
            public string getUserId()
            {
                return _userId;
            }

            // Packs the Chat service payload into the token buffer.
            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_userId.getBytes());
            }

            // Unpacks the Chat service payload from the token buffer.
            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _userId = byteBuf.readBytes().getString();
            }
        }

        public class ServiceApaas : Service
        {
            public string _roomUuid;
            public string _userUuid;
            public short _role;

            // Creates an empty APaaS service for token parsing.
            public ServiceApaas()
            {
                setServiceType(SERVICE_TYPE_APAAS);
                _roomUuid = "";
                _userUuid = "";
                _role = -1;
            }

            // Creates a room-user APaaS service.
            public ServiceApaas(string roomUuid, string userUuid, short role)
            {
                setServiceType(SERVICE_TYPE_APAAS);
                _roomUuid = roomUuid;
                _userUuid = userUuid;
                _role = role;
            }

            // Creates a user-level APaaS service.
            public ServiceApaas(string userUuid)
            {
                setServiceType(SERVICE_TYPE_APAAS);
                _roomUuid = "";
                _userUuid = userUuid;
                _role = -1;
            }

            // Returns the APaaS room UUID.
            public string getRoomUuid()
            {
                return _roomUuid;
            }

            // Returns the APaaS user UUID.
            public string getUserUuid()
            {
                return _userUuid;
            }

            // Returns the APaaS room role.
            public short getRole()
            {
                return _role;
            }

            // Packs the APaaS service payload into the token buffer.
            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_roomUuid.getBytes()).put(_userUuid.getBytes()).put((ushort)_role);
            }

            // Unpacks the APaaS service payload from the token buffer.
            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _roomUuid = byteBuf.readBytes().getString();
                _userUuid = byteBuf.readBytes().getString();
                _role = (short)byteBuf.readShort();
            }
        }
    }
}
