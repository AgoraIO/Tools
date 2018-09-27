package io.agora.media;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.TreeMap;

import static io.agora.media.Utils.crc32;

public class AccessToken {

    public enum Privileges {
        kJoinChannel(1),
        kPublishAudioStream(2),
        kPublishVideoStream(3),
        kPublishDataStream(4),

        kPublishAudiocdn(5),
        kPublishVideoCdn(6),
        kRequestPublishAudioStream(7),
        kRequestPublishVideoStream(8),
        kRequestPublishDataStream(9),
        kInvitePublishAudioStream(10),
        kInvitePublishVideoStream(11),
        kInvitePublishDataStream(12),

        kAdministrateChannel(101);

        public short intValue;

        Privileges(int value) {
            intValue = (short) value;
        }
    }

    public String appId;
    public String appCertificate;
    public String channelName;
    public String uid;
    public byte[] signature;
    public byte[] messageRawContent;
    public int crcChannelName;
    public int crcUid;
    public PrivilegeMessage message;

    public int expireTimestamp;

    public AccessToken(String appId, String appCertificate, String channelName) {
        this(appId, appCertificate, channelName, "");
    }

    public AccessToken(String appId, String appCertificate, String channelName, int uid) {
        this.appId = appId;
        this.appCertificate = appCertificate;
        this.channelName = channelName;
        if (uid == 0){
            this.uid = "";
        }else {
            this.uid = String.valueOf(uid);
        }

        this.crcChannelName = 0;
        this.crcUid = 0;

        this.message = new PrivilegeMessage();
    }

    public AccessToken(String appId, String appCertificate, String channelName, String uid) {
        this.appId = appId;
        this.appCertificate = appCertificate;
        this.channelName = channelName;
        this.uid = uid;

        this.crcChannelName = 0;
        this.crcUid = 0;

        this.message = new PrivilegeMessage();
    }

    public String build() throws Exception {
        if (! Utils.isUUID(this.appId)) {
            return "";
        }

        if (! Utils.isUUID(this.appCertificate)) {
            return "";
        }

        this.messageRawContent = Utils.pack(this.message);
        this.signature = generateSignature(appCertificate
                , appId
                , channelName
                , uid
                , messageRawContent);

        this.crcChannelName = crc32(this.channelName);
        this.crcUid = crc32(this.uid);

        PackContent packContent = new PackContent(signature, crcChannelName, crcUid, this.messageRawContent);
        byte[] content = Utils.pack(packContent);
        return getVersion() + this.appId + Utils.base64Encode(content);
    }

    public void addPrivilege(Privileges privilege, int expireTimestamp) {
        message.messages.put(privilege.intValue, expireTimestamp);
    }

    public static String getVersion() {
        return "006";
    }

    public static byte[] generateSignature(String appCertificate
            , String appID
            , String channelName
            , String uid
            , byte[] message) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            baos.write(appID.getBytes());
            baos.write(channelName.getBytes());
            baos.write(uid.getBytes());
            baos.write(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return Utils.hmacSign(appCertificate, baos.toByteArray());
    }

    public boolean fromString(String token) {
        if (!getVersion().equals(token.substring(0, Utils.VERSION_LENGTH))) {
            return false;
        }
        try {
            this.appId = token.substring(Utils.VERSION_LENGTH, Utils.VERSION_LENGTH + Utils.APP_ID_LENGTH);
            PackContent packContent = new PackContent();
            Utils.unpack(Utils.base64Decode(token.substring(Utils.VERSION_LENGTH + Utils.APP_ID_LENGTH, token.length())), packContent);
            this.signature = packContent.signature;
            this.crcChannelName = packContent.crcChannelName;
            this.crcUid = packContent.crcUid;
            this.messageRawContent = packContent.rawMessage;
            Utils.unpack(this.messageRawContent, this.message);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public class PrivilegeMessage implements PackableEx {
        public int salt;
        public int ts;
        public TreeMap<Short, Integer> messages;

        public PrivilegeMessage() {
            this.salt = Utils.randomInt();
            this.ts = Utils.getTimestamp() + 24 * 3600;
            this.messages = new TreeMap<>();
        }

        @Override
        public ByteBuf marshal(ByteBuf out) {
            return out.put(salt).put(ts).putIntMap(messages);
        }

        @Override
        public void unmarshal(ByteBuf in) {
            this.salt = in.readInt();
            this.ts = in.readInt();
            this.messages = in.readIntMap();
        }
    }

    public class PackContent implements PackableEx {
        public byte[] signature;
        public int crcChannelName;
        public int crcUid;
        public byte[] rawMessage;

        public PackContent() {
        }

        public PackContent(byte[] signature, int crcChannelName, int crcUid, byte[] rawMessage) {
            this.signature = signature;
            this.crcChannelName = crcChannelName;
            this.crcUid = crcUid;
            this.rawMessage = rawMessage;
        }

        @Override
        public ByteBuf marshal(ByteBuf out) {
            return out.put(signature).put(crcChannelName).put(crcUid).put(rawMessage);
        }

        @Override
        public void unmarshal(ByteBuf in) {
            this.signature = in.readBytes();
            this.crcChannelName = in.readInt();
            this.crcUid = in.readInt();
            this.rawMessage = in.readBytes();
        }
    }
}
