package io.agora.media;

public class RtmTokenBuilder {
    public AccessToken mTokenCreator;

    public RtmTokenBuilder(String appId, String appCertificate, String userId) {
        mTokenCreator = new AccessToken(appId, appCertificate, userId, "");
    }

    public boolean initTokenBuilder(String originToken) {
        mTokenCreator.fromString(originToken);
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
