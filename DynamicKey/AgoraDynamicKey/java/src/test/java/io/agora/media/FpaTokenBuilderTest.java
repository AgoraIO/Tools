package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class FpaTokenBuilderTest {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private int expire = 24 * 3600;

    @Test
    public void buildToken() {
        FpaTokenBuilder fpaTokenBuilder = new FpaTokenBuilder();
        String token = fpaTokenBuilder.buildToken(appId, appCertificate);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(0, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_FPA).getPrivileges().get(AccessToken2.PrivilegeFpa.PRIVILEGE_LOGIN.intValue));
    }
}