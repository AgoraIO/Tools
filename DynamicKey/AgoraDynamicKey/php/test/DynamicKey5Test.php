<?php
include "../src/DynamicKey5.php";
include "TestTool.php";

    $appID = '970ca35de60c44645bbae8a215061b33';
    $appCertificate = '5cfd2fd1755d40ecb72977518be15d3b';
    $channelName = "7d72365eb983485397e3e3f9d460bdda";
    $ts = 1446455472;
    $randomInt = 58964981;
    $uid = 2882341273;
    $expiredTs = 1446455471;

    function testRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs)
    {   
        $expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
        $actual = generateRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);

        assertEqual($expected, $actual);
    }

    function testMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs)
    {   
        $expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
        
        $actual = generateMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);

        assertEqual($expected, $actual);
    }

    function testInChannelPermission($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs)
    {
        global $NO_UPLOAD;

        $noUpload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw";
        $generatedNoUpload = generateInChannelPermissionKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $NO_UPLOAD);
        assertEqual($noUpload, $generatedNoUpload);

        global $AUDIO_VIDEO_UPLOAD;
        $audioVideoUpload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz";
        $generatedAudioVideoUpload = generateInChannelPermissionKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $AUDIO_VIDEO_UPLOAD);
        assertEqual($audioVideoUpload, $generatedAudioVideoUpload);
    }

    testRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);
    testMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);
    testInChannelPermission($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs);
?>