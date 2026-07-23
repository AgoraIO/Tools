package io.agora.media;

import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.TreeMap;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Builds, parses, and verifies Token007 tokens containing one or more services.
 */
public class AccessToken2 {
    /**
     * RTC privilege identifiers.
     */
    public enum PrivilegeRtc {
        PRIVILEGE_JOIN_CHANNEL(1), PRIVILEGE_PUBLISH_AUDIO_STREAM(2), PRIVILEGE_PUBLISH_VIDEO_STREAM(3), PRIVILEGE_PUBLISH_DATA_STREAM(4),;

        public short intValue;

        /**
         * Creates an RTC privilege identifier.
         */
        PrivilegeRtc(int value) {
            intValue = (short) value;
        }
    }

    /**
     * RTM privilege identifiers.
     */
    public enum PrivilegeRtm {
        PRIVILEGE_LOGIN(1),;

        public short intValue;

        /**
         * Creates an RTM privilege identifier.
         */
        PrivilegeRtm(int value) {
            intValue = (short) value;
        }
    }

    /**
     * FPA privilege identifiers.
     */
    public enum PrivilegeFpa {
        PRIVILEGE_LOGIN(1),;

        public short intValue;

        /**
         * Creates an FPA privilege identifier.
         */
        PrivilegeFpa(int value) {
            intValue = (short) value;
        }
    }

    /**
     * Chat privilege identifiers.
     */
    public enum PrivilegeChat {
        PRIVILEGE_CHAT_USER(1), PRIVILEGE_CHAT_APP(2),;

        public short intValue;

        /**
         * Creates a Chat privilege identifier.
         */
        PrivilegeChat(int value) {
            intValue = (short) value;
        }
    }

    /**
     * APaaS privilege identifiers.
     */
    public enum PrivilegeApaas {
        PRIVILEGE_ROOM_USER(1), PRIVILEGE_USER(2), PRIVILEGE_APP(3),;

        public short intValue;

        /**
         * Creates an APaaS privilege identifier.
         */
        PrivilegeApaas(int value) {
            intValue = (short) value;
        }
    }

    private static final String VERSION = "007";
    public static final short SERVICE_TYPE_RTC = 1;
    public static final short SERVICE_TYPE_RTM = 2;
    public static final short SERVICE_TYPE_FPA = 4;
    public static final short SERVICE_TYPE_CHAT = 5;
    public static final short SERVICE_TYPE_APAAS = 7;

    public String appCert = "";
    public String appId = "";
    public int expire;
    public int issueTs;
    public int salt;
    public List<Service> services = new ArrayList<>();
    private byte[] signature = new byte[0];
    private byte[] signingInfo = new byte[0];

    /**
     * Creates an empty token parser.
     */
    public AccessToken2() {}

    /**
     * Creates a Token007 builder.
     */
    public AccessToken2(String appId, String appCert, int expire) {
        this.appCert = appCert;
        this.appId = appId;
        this.expire = expire;
        this.issueTs = Utils.getTimestamp();
        this.salt = Utils.randomInt();
    }

    /**
     * Adds a service without replacing services of the same type.
     */
    public void addService(Service service) {
        this.services.add(service);
    }

    /**
     * Returns all services of the requested type in insertion or token order.
     */
    public List<Service> getServices(short serviceType) {
        List<Service> result = new ArrayList<>();
        for (Service service : this.services) {
            if (service.getServiceType() == serviceType) {
                result.add(service);
            }
        }
        return result;
    }

    /**
     * Builds a Token007 token containing all added services.
     */
    public String build() throws Exception {
        if (!Utils.isUUID(this.appId) || !Utils.isUUID(this.appCert)) {
            return "";
        }

        List<Service> services = servicesForPacking();
        ByteBuf buf = new ByteBuf().put(this.appId).put(this.issueTs).put(this.expire).put(this.salt).put((short) services.size());
        byte[] signing = getSign();

        for (Service service : services) {
            service.pack(buf);
        }

        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(signing, "HmacSHA256"));
        byte[] signature = mac.doFinal(buf.asBytes());

        ByteBuf bufferContent = new ByteBuf();
        bufferContent.put(signature);
        bufferContent.buffer.put(buf.asBytes());

        return getVersion() + Utils.base64Encode(Utils.compress(bufferContent.asBytes()));
    }

    /**
     * Creates a parser for a known service type or returns null for an unknown type.
     */
    public Service getService(short serviceType) {
        if (serviceType == SERVICE_TYPE_RTC) {
            return new ServiceRtc();
        }
        if (serviceType == SERVICE_TYPE_RTM) {
            return new ServiceRtm();
        }
        if (serviceType == SERVICE_TYPE_FPA) {
            return new ServiceFpa();
        }
        if (serviceType == SERVICE_TYPE_CHAT) {
            return new ServiceChat();
        }
        if (serviceType == SERVICE_TYPE_APAAS) {
            return new ServiceApaas();
        }
        return null;
    }

    /**
     * Derives the signing key with the stored App Certificate.
     */
    public byte[] getSign() throws Exception {
        return getSign(this.appCert);
    }

    /**
     * Derives the signing key with the supplied App Certificate.
     */
    public byte[] getSign(String appCertificate) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(new ByteBuf().put(this.issueTs).asBytes(), "HmacSHA256"));
        byte[] signing = mac.doFinal(appCertificate.getBytes());
        mac.init(new SecretKeySpec(new ByteBuf().put(this.salt).asBytes(), "HmacSHA256"));
        return mac.doFinal(signing);
    }

    /**
     * Converts a numeric user ID to its unsigned token representation.
     */
    public static String getUidStr(int uid) {
        if (uid == 0) {
            return "";
        }
        return String.valueOf(uid & 0xFFFFFFFFL);
    }

    /**
     * Returns the Token007 version prefix.
     */
    public static String getVersion() {
        return VERSION;
    }

    /**
     * Parses known services and retains the original bytes for signature verification.
     */
    public boolean parse(String token) {
        if (token == null || token.length() < Utils.VERSION_LENGTH
                || !getVersion().equals(token.substring(0, Utils.VERSION_LENGTH))) {
            return false;
        }

        try {
            byte[] data = Utils.decompress(Utils.base64Decode(token.substring(Utils.VERSION_LENGTH)));
            ByteBuf buff = new ByteBuf(data);
            this.signature = buff.readBytes();
            this.signingInfo = Arrays.copyOfRange(data, Short.BYTES + this.signature.length, data.length);
            this.services.clear();
            this.appId = buff.readString();
            this.issueTs = buff.readInt();
            this.expire = buff.readInt();
            this.salt = buff.readInt();
            short servicesNum = buff.readShort();

            for (int i = 0; i < servicesNum; i++) {
                short serviceType = buff.readShort();
                Service service = getService(serviceType);
                if (service == null) {
                    return true;
                }
                service.unpack(buff);
                this.addService(service);
            }
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    /**
     * Verifies the signature of a successfully parsed token.
     */
    public boolean verifySignature(String appCertificate) {
        if (this.signature.length == 0 || this.signingInfo.length == 0
                || appCertificate == null || !Utils.isUUID(this.appId) || !Utils.isUUID(appCertificate)) {
            return false;
        }

        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(getSign(appCertificate), "HmacSHA256"));
            return MessageDigest.isEqual(this.signature, mac.doFinal(this.signingInfo));
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Returns services in stable type order while preserving duplicate insertion order.
     */
    private List<Service> servicesForPacking() {
        List<Service> result = new ArrayList<>(this.services);
        result.sort(Comparator.comparingInt(service -> Short.toUnsignedInt(service.getServiceType())));
        return result;
    }

    /**
     * Represents the common service type and privilege payload.
     */
    public static class Service {
        public short type;
        public TreeMap<Short, Integer> privileges = new TreeMap<Short, Integer>() {};

        /**
         * Creates an empty service.
         */
        public Service() {}

        /**
         * Creates a service with the specified numeric type.
         */
        public Service(short serviceType) {
            this.type = serviceType;
        }

        /**
         * Adds or updates an RTC privilege expiration timestamp.
         */
        public void addPrivilegeRtc(PrivilegeRtc privilege, int expire) {
            this.privileges.put(privilege.intValue, expire);
        }

        /**
         * Adds or updates an RTM privilege expiration timestamp.
         */
        public void addPrivilegeRtm(PrivilegeRtm privilege, int expire) {
            this.privileges.put(privilege.intValue, expire);
        }

        /**
         * Adds or updates an FPA privilege expiration timestamp.
         */
        public void addPrivilegeFpa(PrivilegeFpa privilege, int expire) {
            this.privileges.put(privilege.intValue, expire);
        }

        /**
         * Adds or updates a Chat privilege expiration timestamp.
         */
        public void addPrivilegeChat(PrivilegeChat privilege, int expire) {
            this.privileges.put(privilege.intValue, expire);
        }

        /**
         * Adds or updates an APaaS privilege expiration timestamp.
         */
        public void addPrivilegeApaas(PrivilegeApaas privilege, int expire) {
            this.privileges.put(privilege.intValue, expire);
        }

        /**
         * Returns the service privilege map.
         */
        public TreeMap<Short, Integer> getPrivileges() {
            return this.privileges;
        }

        /**
         * Returns the numeric service type.
         */
        public short getServiceType() {
            return this.type;
        }

        /**
         * Serializes the service type and privileges.
         */
        public ByteBuf pack(ByteBuf buf) {
            return buf.put(this.type).putIntMap(this.privileges);
        }

        /**
         * Deserializes service privileges from the token payload.
         */
        public void unpack(ByteBuf byteBuf) {
            this.privileges = byteBuf.readIntMap();
        }
    }

    /**
     * Represents RTC channel and user privileges.
     */
    public static class ServiceRtc extends Service {
        public String channelName;
        public String uid;

        /**
         * Creates an empty RTC service parser.
         */
        public ServiceRtc() {
            this.type = SERVICE_TYPE_RTC;
        }

        /**
         * Creates an RTC service for a channel and user.
         */
        public ServiceRtc(String channelName, String uid) {
            this.type = SERVICE_TYPE_RTC;
            this.channelName = channelName;
            this.uid = uid;
        }

        /**
         * Returns the RTC channel name.
         */
        public String getChannelName() {
            return this.channelName;
        }

        /**
         * Returns the RTC user ID.
         */
        public String getUid() {
            return this.uid;
        }

        /**
         * Serializes the RTC service payload.
         */
        public ByteBuf pack(ByteBuf buf) {
            return super.pack(buf).put(this.channelName).put(this.uid);
        }

        /**
         * Deserializes the RTC service payload.
         */
        public void unpack(ByteBuf byteBuf) {
            super.unpack(byteBuf);
            this.channelName = byteBuf.readString();
            this.uid = byteBuf.readString();
        }
    }

    /**
     * Represents RTM user login privileges.
     */
    public static class ServiceRtm extends Service {
        public String userId;

        /**
         * Creates an empty RTM service parser.
         */
        public ServiceRtm() {
            this.type = SERVICE_TYPE_RTM;
        }

        /**
         * Creates an RTM service for a user.
         */
        public ServiceRtm(String userId) {
            this.type = SERVICE_TYPE_RTM;
            this.userId = userId;
        }

        /**
         * Returns the RTM user ID.
         */
        public String getUserId() {
            return this.userId;
        }

        /**
         * Serializes the RTM service payload.
         */
        public ByteBuf pack(ByteBuf buf) {
            return super.pack(buf).put(this.userId);
        }

        /**
         * Deserializes the RTM service payload.
         */
        public void unpack(ByteBuf byteBuf) {
            super.unpack(byteBuf);
            this.userId = byteBuf.readString();
        }
    }

    /**
     * Represents FPA login privileges.
     */
    public static class ServiceFpa extends Service {
        /**
         * Creates an FPA service.
         */
        public ServiceFpa() {
            this.type = SERVICE_TYPE_FPA;
        }

        /**
         * Serializes the FPA service payload.
         */
        public ByteBuf pack(ByteBuf buf) {
            return super.pack(buf);
        }

        /**
         * Deserializes the FPA service payload.
         */
        public void unpack(ByteBuf byteBuf) {
            super.unpack(byteBuf);
        }
    }

    /**
     * Represents Chat user or application privileges.
     */
    public static class ServiceChat extends Service {
        public String userId;

        /**
         * Creates an empty Chat application service.
         */
        public ServiceChat() {
            this.type = SERVICE_TYPE_CHAT;
            this.userId = "";
        }

        /**
         * Creates a Chat service for a user.
         */
        public ServiceChat(String userId) {
            this.type = SERVICE_TYPE_CHAT;
            this.userId = userId;
        }

        /**
         * Returns the Chat user ID.
         */
        public String getUserId() {
            return this.userId;
        }

        /**
         * Serializes the Chat service payload.
         */
        public ByteBuf pack(ByteBuf buf) {
            return super.pack(buf).put(this.userId);
        }

        /**
         * Deserializes the Chat service payload.
         */
        public void unpack(ByteBuf byteBuf) {
            super.unpack(byteBuf);
            this.userId = byteBuf.readString();
        }
    }

    /**
     * Represents APaaS room, user, and application privileges.
     */
    public static class ServiceApaas extends Service {
        public String roomUuid;
        public String userUuid;
        public Short role;

        /**
         * Creates an empty APaaS application service.
         */
        public ServiceApaas() {
            this.type = SERVICE_TYPE_APAAS;
            this.roomUuid = "";
            this.userUuid = "";
            this.role = -1;
        }

        /**
         * Creates an APaaS room user service.
         */
        public ServiceApaas(String roomUuid, String userUuid, Short role) {
            this.type = SERVICE_TYPE_APAAS;
            this.roomUuid = roomUuid;
            this.userUuid = userUuid;
            this.role = role;
        }

        /**
         * Creates an APaaS user service.
         */
        public ServiceApaas(String userUuid) {
            this.type = SERVICE_TYPE_APAAS;
            this.roomUuid = "";
            this.userUuid = userUuid;
            this.role = -1;
        }

        /**
         * Returns the APaaS room ID.
         */
        public String getRoomUuid() {
            return this.roomUuid;
        }

        /**
         * Returns the APaaS user ID.
         */
        public String getUserUuid() {
            return this.userUuid;
        }

        /**
         * Returns the APaaS user role.
         */
        public Short getRole() {
            return this.role;
        }

        /**
         * Serializes the APaaS service payload.
         */
        public ByteBuf pack(ByteBuf buf) {
            return super.pack(buf).put(this.roomUuid).put(this.userUuid).put(this.role);
        }

        /**
         * Deserializes the APaaS service payload.
         */
        public void unpack(ByteBuf byteBuf) {
            super.unpack(byteBuf);
            this.roomUuid = byteBuf.readString();
            this.userUuid = byteBuf.readString();
            this.role = byteBuf.readShort();
        }
    }
}
