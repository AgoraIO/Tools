package io.agora.media;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

import io.agora.signal.SignalingToken;
import java.nio.charset.StandardCharsets;
import org.junit.Test;

/** Tests legacy key generators and RTC builder role branches. */
public class LegacyCoverageTest {
    private static final String APP_ID = "970CA35de60c44645bbae8a215061b33";
    private static final String APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b";
    private static final String CHANNEL = "7d72365eb983485397e3e3f9d460bdda";

    /** Exercises every legacy DynamicKey generation entry point. */
    @Test
    public void generatesEveryLegacyKey() throws Exception {
        assertEquals(90, DynamicKey.generate(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1).length());
        assertEquals(113, DynamicKey3.generate(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 2882341273L, 600).length());
        assertEquals(103, DynamicKey4.generatePublicSharingKey(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 2882341273L, 600).length());
        assertEquals(103, DynamicKey4.generateRecordingKey(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 2882341273L, 600).length());
        assertEquals(103, DynamicKey4.generateMediaChannelKey(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 2882341273L, 600).length());
    }

    /** Exercises all legacy RTC roles and numeric UID conversion branches. */
    @Test
    public void buildsLegacyRtcTokensForEveryRole() {
        RtcTokenBuilder builder = new RtcTokenBuilder();
        for (RtcTokenBuilder.Role role : RtcTokenBuilder.Role.values()) {
            assertFalse(builder.buildTokenWithUid(APP_ID, APP_CERTIFICATE, CHANNEL, 0, role, 600).isEmpty());
            assertFalse(builder.buildTokenWithUid(APP_ID, APP_CERTIFICATE, CHANNEL, 123, role, 600).isEmpty());
            assertFalse(builder.buildTokenWithUserAccount(APP_ID, APP_CERTIFICATE, CHANNEL, "user", role, 600).isEmpty());
        }
    }

    /** Exercises signaling token generation and hexadecimal conversion. */
    @Test
    public void generatesSignalingTokens() throws Exception {
        String token = SignalingToken.getToken(APP_ID, APP_CERTIFICATE, "user", 600);
        assertFalse(token.isEmpty());
        assertEquals("000fff", SignalingToken.hexlify(new byte[] {0, 15, (byte) 255}));
        assertEquals(40, DynamicKeyUtil.bytesToHex(DynamicKeyUtil.encodeHMAC(APP_CERTIFICATE, "message".getBytes(StandardCharsets.UTF_8))).length());
    }
}
