using System;
using System.Collections.Generic;
using System.Text;

namespace AgoraIO.Media
{
    public class AccessToken2
    {
        private static readonly string VERSION = "007";
        private static readonly int VERSION_LENGTH = 3;

        public string _appCert = "";
        public string _appId = "";
        public int _expire;
        public int _issueTs;
        public int _salt;
        public Dictionary<ushort, Service> _services = new Dictionary<ushort, Service>();

        public AccessToken2()
        {
        }

        public AccessToken2(string appId, string appCert, int expire)
        {
            _appCert = appCert;
            _appId = appId;
            _expire = expire;
            _issueTs = Utils.getTimestamp();
            _salt = Utils.randomInt();
        }

        public void addService(Service service)
        {
            _services.Add((ushort)service.getServiceType(), service);
        }

        public static short SERVICE_TYPE_RTC = 1;
        public static short SERVICE_TYPE_RTM = 2;
        public static short SERVICE_TYPE_FPA = 4;
        public static short SERVICE_TYPE_CHAT = 5;
        public static short SERVICE_TYPE_EDUCATION = 7;

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
            if (serviceType == SERVICE_TYPE_EDUCATION)
            {
                return new ServiceEducation();
            }
            throw new ArgumentException("unknown service type:", serviceType.ToString());
        }

        public static string getUidStr(int uid)
        {
            if (uid == 0)
            {
                return "";
            }
            return (uid & 0xFFFFFFFFL).ToString();
        }

        public string getVersion()
        {
            return VERSION;
        }

        public byte[] getSign()
        {
            byte[] signing = DynamicKeyUtil.encodeHMAC(BitConverter.GetBytes(_issueTs), _appCert.getBytes(), "SHA256");
            return DynamicKeyUtil.encodeHMAC(BitConverter.GetBytes(_salt), signing, "SHA256");
        }

        public string build()
        {
            if (!Utils.isUUID(_appId) || !Utils.isUUID(_appCert)) {
                return "";
            }

            ByteBuf buf = new ByteBuf().put(_appId.getBytes()).put((uint)_issueTs).put((uint)_expire).put((uint)_salt).put((ushort)_services.Count);
            byte[] signing = getSign();

            foreach(var it in _services)
            {
                it.Value.pack(buf);
            }

            byte[] signature = DynamicKeyUtil.encodeHMAC(signing, buf.asBytes(), "SHA256");

            ByteBuf bufferContent = new ByteBuf();
            bufferContent.put(signature);
            bufferContent.copy(buf.asBytes());

            return getVersion() + Utils.base64Encode(Utils.compress(bufferContent.asBytes()));
        }

        public bool parse(string token)
        {
            if (getVersion().CompareTo(token.Substring(0, VERSION_LENGTH)) != 0)
            {
                return false;
            }

            byte[] data = Utils.decompress(Utils.base64Decode(token.Substring(VERSION_LENGTH)));

            ByteBuf buff = new ByteBuf(data);
            string signature = buff.readBytes().getString();
            _appId = buff.readBytes().getString();
            _issueTs = (int)buff.readInt();
            _expire = (int)buff.readInt();
            _salt = (int)buff.readInt();
            short servicesNum = (short)buff.readShort();

            for(short i = 0; i< servicesNum; i++)
            {
                short serviceType = (short)buff.readShort();
                Service service = getService(serviceType);
                service.unpack(buff);
                _services.Add((ushort)serviceType, service);
            }

            return true;
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
        public enum PrivilegeEducationEnum
        {
            PRIVILEGE_ROOM_USER = 1,
            PRIVILEGE_USER = 2,
            PRIVILEGE_APP = 3
        }

        public class Service
        {
            private short _type;
            private Dictionary<ushort, uint> _privileges = new Dictionary<ushort, uint>();

            public Service()
            {

            }

            public Service(short serviceType)
            {
                _type = serviceType;
            }

            public void addPrivilegeRtc(PrivilegeRtcEnum privilege, int expire)
            {
                _privileges.Add((ushort)privilege, (uint)expire);
            }

            public void addPrivilegeRtm(PrivilegeRtmEnum privilege, int expire)
            {
                _privileges.Add((ushort)privilege, (uint)expire);
            }

            public void addPrivilegeFpa(PrivilegeFpaEnum privilege, int expire)
            {
                _privileges.Add((ushort)privilege, (uint)expire);
            }

            public void addPrivilegeChat(PrivilegeChatEnum privilege, int expire)
            {
                _privileges.Add((ushort)privilege, (uint)expire);
            }

            public void addPrivilegeEducation(PrivilegeEducationEnum privilege, int expire)
            {
                _privileges.Add((ushort)privilege, (uint)expire);
            }

            public Dictionary<ushort, uint> getPrivileges()
            {
                return _privileges;
            }

            public short getServiceType()
            {
                return _type;
            }

            public void setServiceType(short type)
            {
                _type = type;
            }

            public virtual ByteBuf pack(ByteBuf buf)
            {
                return buf.put((ushort)_type).putIntMap(_privileges);
            }

            public virtual void unpack(ByteBuf byteBuf)
            {
                _privileges = byteBuf.readIntMap();
            }
        }

        public class ServiceRtc : Service
        {
            public string _channelName;
            public string _uid;

            public ServiceRtc()
            {
                setServiceType(SERVICE_TYPE_RTC);
            }

            public ServiceRtc(string channelName, string uid)
            {
                setServiceType(SERVICE_TYPE_RTC);
                _channelName = channelName;
                _uid = uid;
            }

            public string getChannelName()
            {
                return _channelName;
            }

            public string getUid()
            {
                return _uid;
            }

            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_channelName.getBytes()).put(_uid.getBytes());
            }

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

            public ServiceRtm()
            {
                setServiceType(SERVICE_TYPE_RTM);
            }

            public ServiceRtm(string userId)
            {
                setServiceType(SERVICE_TYPE_RTM);
                _userId = userId;
            }

            public string getUserId()
            {
                return _userId;
            }

            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_userId.getBytes());
            }

            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _userId = byteBuf.readBytes().getString();
            }
        }

        public class ServiceFpa : Service
        {
            public ServiceFpa()
            {
                setServiceType(SERVICE_TYPE_FPA);
            }

            public new ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf);
            }

            public new void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
            }
        }

        public class ServiceChat : Service
        {
            public string _userId;

            public ServiceChat()
            {
                setServiceType(SERVICE_TYPE_CHAT);
                _userId = "";
            }

            public ServiceChat(string userId)
            {
                setServiceType(SERVICE_TYPE_CHAT);
                _userId = userId;
            }

            public string getUserId()
            {
                return _userId;
            }

            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_userId.getBytes());
            }

            public override void unpack(ByteBuf byteBuf)
            {
                base.unpack(byteBuf);
                _userId = byteBuf.readBytes().getString();
            }
        }

        public class ServiceEducation : Service
        {
            public string _roomUuid;
            public string _userUuid;
            public short _role;

            public ServiceEducation()
            {
                setServiceType(SERVICE_TYPE_EDUCATION);
                _roomUuid = "";
                _userUuid = "";
                _role = -1;
            }

            public ServiceEducation(string roomUuid, string userUuid, short role)
            {
                setServiceType(SERVICE_TYPE_EDUCATION);
                _roomUuid = roomUuid;
                _userUuid = userUuid;
                _role = role;
            }

            public ServiceEducation(string userUuid)
            {
                setServiceType(SERVICE_TYPE_EDUCATION);
                _roomUuid = "";
                _userUuid = userUuid;
                _role = -1;
            }

            public string getRoomUuid()
            {
                return _roomUuid;
            }

            public string getUserUuid()
            {
                return _userUuid;
            }

            public short getRole()
            {
                return _role;
            }

            public override ByteBuf pack(ByteBuf buf)
            {
                return base.pack(buf).put(_roomUuid.getBytes()).put(_userUuid.getBytes()).put((ushort)_role);
            }

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
