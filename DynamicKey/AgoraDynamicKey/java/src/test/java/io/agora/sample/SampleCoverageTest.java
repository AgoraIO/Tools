package io.agora.sample;

import static org.junit.Assert.assertTrue;

import io.agora.media.AccessToken2;
import io.agora.media.DynamicKey5;
import java.lang.reflect.Field;
import org.junit.Test;

/** Tests the Java sample entry points that are included in main-source coverage. */
public class SampleCoverageTest {
    private static final String APP_ID = "970CA35de60c44645bbae8a215061b33";
    private static final String APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b";
    private static final String CHANNEL = "7d72365eb983485397e3e3f9d460bdda";

    /** Executes every credential-based sample with test credentials. */
    @Test
    public void runsCredentialBasedSamples() throws Exception {
        Class<?>[] samples = {
            ApaasTokenBuilderSample.class,
            ChatTokenBuilder2Sample.class,
            DynamicKey5Sample.class,
            EducationTokenBuilder2Sample.class,
            FpaTokenBuilderSample.class,
            RtcTokenBuilder2Sample.class,
            RtcTokenBuilderSample.class,
            RtmTokenBuilder2Sample.class,
            RtmTokenBuilderSample.class
        };
        for (Class<?> sample : samples) {
            setStaticField(sample, "appId", APP_ID);
            setStaticField(sample, "appCertificate", APP_CERTIFICATE);
            sample.getMethod("main", String[].class).invoke(null, (Object) new String[0]);
        }

        SignalingTokenSample.main(new String[0]);
    }

    /** Exercises inspector formatting for RTC, RTM, Chat, and unknown services. */
    @Test
    public void formatsEveryInspectorService() {
        AccessTokenInspector inspector = new AccessTokenInspector();
        AccessTokenInspector.main(new String[0]);

        AccessToken2.ServiceRtc rtc = new AccessToken2.ServiceRtc(CHANNEL, "user");
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, 1);
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM, 2);
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM, 3);
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, 4);
        assertTrue(inspector.toServiceStr(rtc).contains("PUBLISH_DATA_STREAM"));

        AccessToken2.ServiceRtm rtm = new AccessToken2.ServiceRtm("user");
        rtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, 1);
        assertTrue(inspector.toServiceStr(rtm).contains("JOIN_LOGIN"));

        AccessToken2.ServiceChat chat = new AccessToken2.ServiceChat("user");
        chat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, 1);
        chat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP, 2);
        assertTrue(inspector.toServiceStr(chat).contains("APP"));
        assertTrue(inspector.toServiceStr(new AccessToken2.Service((short) 99)).contains("unknown"));
    }

    /** Exercises verifier argument validation and supported DynamicKey5 service branches. */
    @Test
    public void verifiesGeneratedDynamicKeys() throws Exception {
        Verifier5.main(new String[0]);
        String media = DynamicKey5.generateMediaChannelKey(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 123, 600);
        String recording = DynamicKey5.generateRecordingKey(APP_ID, APP_CERTIFICATE, CHANNEL, 1111111, 1, 123, 600);
        Verifier5.main(new String[] {APP_ID, APP_CERTIFICATE, CHANNEL, "123", media});
        Verifier5.main(new String[] {APP_ID, APP_CERTIFICATE, CHANNEL, "123", recording});
    }

    /** Sets one static sample credential field regardless of its visibility. */
    private static void setStaticField(Class<?> type, String name, String value) throws Exception {
        Field field = type.getDeclaredField(name);
        field.setAccessible(true);
        field.set(null, value);
    }
}
