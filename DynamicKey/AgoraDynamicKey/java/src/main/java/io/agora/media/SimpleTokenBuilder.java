package io.agora.media;

import java.util.TreeMap;

import static io.agora.media.AccessToken.Privileges.*;
import static io.agora.media.SimpleTokenBuilder.Role.*;

public class SimpleTokenBuilder {
    public AccessToken mTokenCreator;

    public static TreeMap<Short, Integer> attendeePrivileges = new TreeMap<Short, Integer>();

    static {
        attendeePrivileges.put(kJoinChannel.intValue, 0);
        attendeePrivileges.put(kPublishAudioStream.intValue, 0);
        attendeePrivileges.put(kPublishVideoStream.intValue, 0);
        attendeePrivileges.put(kPublishDataStream.intValue, 0);
    }

    public static TreeMap<Short, Integer> publisherPrivileges = new TreeMap<Short, Integer>();

    static {
        publisherPrivileges.put(kJoinChannel.intValue, 0);
        publisherPrivileges.put(kPublishAudioStream.intValue, 0);
        publisherPrivileges.put(kPublishVideoStream.intValue, 0);
        publisherPrivileges.put(kPublishDataStream.intValue, 0);
        publisherPrivileges.put(kPublishAudiocdn.intValue, 0);
        publisherPrivileges.put(kPublishVideoCdn.intValue, 0);
        publisherPrivileges.put(kInvitePublishAudioStream.intValue, 0);
        publisherPrivileges.put(kInvitePublishVideoStream.intValue, 0);
        publisherPrivileges.put(kInvitePublishDataStream.intValue, 0);
    }

    public static TreeMap<Short, Integer> subscriberPrivileges = new TreeMap<Short, Integer>();

    static {
        subscriberPrivileges.put(kJoinChannel.intValue, 0);
        subscriberPrivileges.put(kRequestPublishAudioStream.intValue, 0);
        subscriberPrivileges.put(kRequestPublishVideoStream.intValue, 0);
        subscriberPrivileges.put(kRequestPublishDataStream.intValue, 0);
    }

    public static TreeMap<Short, Integer> adminPrivileges = new TreeMap<Short, Integer>();

    static {
        adminPrivileges.put(kJoinChannel.intValue, 0);
        adminPrivileges.put(kPublishAudioStream.intValue, 0);
        adminPrivileges.put(kPublishVideoStream.intValue, 0);
        adminPrivileges.put(kPublishDataStream.intValue, 0);
        adminPrivileges.put(kAdministrateChannel.intValue, 0);
    }

    public static TreeMap<Integer, TreeMap<Short, Integer>> gRolePrivileges = new TreeMap<Integer, TreeMap<Short, Integer>>();

    static {
        gRolePrivileges.put(Role_Attendee.initValue, attendeePrivileges);
        gRolePrivileges.put(Role_Publisher.initValue, publisherPrivileges);
        gRolePrivileges.put(Role_Subscriber.initValue, subscriberPrivileges);
        gRolePrivileges.put(Role_Admin.initValue, adminPrivileges);
    }

    public enum Role {
        Role_Attendee(0),  // for communication
        Role_Publisher(1), // for live broadcast
        Role_Subscriber(2),  // for live broadcast
        Role_Admin(101);

        public int initValue;

        Role(int initValue) {
            this.initValue = initValue;
        }
    }

    public SimpleTokenBuilder(String appId, String appCertificate, String channelName, String uid) {
        mTokenCreator = new AccessToken(appId, appCertificate, channelName, uid);
    }

    public SimpleTokenBuilder(String appId, String appCertificate, String channelName, int uid) {
        mTokenCreator = new AccessToken(appId, appCertificate, channelName, uid);
    }

    public boolean initTokenBuilder(String originToken) {
        mTokenCreator.fromString(originToken);
        return true;
    }

    public boolean initPrivileges(Role role) {
        TreeMap<Short, Integer> value = gRolePrivileges.get(role.initValue);
        if (value == null) {
            return false;
        }
        mTokenCreator.message.messages = value;
        return true;
    }

    public void setPrivilege(AccessToken.Privileges privilege, int expireTimestamp) {
        mTokenCreator.message.messages.put(privilege.intValue, expireTimestamp);
    }

    public void removePrivilege(AccessToken.Privileges privilege) {
        mTokenCreator.message.messages.remove(privilege.intValue);
    }

    public String buildToken() throws Exception {
        return mTokenCreator.build();
    }
}
