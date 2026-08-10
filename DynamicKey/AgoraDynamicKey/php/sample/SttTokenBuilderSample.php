<?php
include("../src/SttTokenBuilder.php");

$appId = getenv("AGORA_APP_ID");
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$channelName = "stt-channel";
$rtcAccount = "stt-rtc-user";
$rtcRole = RtcTokenBuilder2::ROLE_PUBLISHER;
$rtcTokenExpire = 3600;
$joinChannelPrivilegeExpire = 3600;
$pubAudioPrivilegeExpire = 3600;
$pubVideoPrivilegeExpire = 3600;
$pubDataStreamPrivilegeExpire = 3600;
$rtmUserId = "stt-rtm-user";
$rtmTokenExpire = 3600;

echo "App Id: " . $appId . PHP_EOL;
if ($appId == "" || $appCertificate == "") {
    echo "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" . PHP_EOL;
    exit;
}

$token = SttTokenBuilder::buildToken(
    $appId,
    $appCertificate,
    $channelName,
    $rtcAccount,
    $rtcRole,
    $rtcTokenExpire,
    $joinChannelPrivilegeExpire,
    $pubAudioPrivilegeExpire,
    $pubVideoPrivilegeExpire,
    $pubDataStreamPrivilegeExpire,
    $rtmUserId,
    $rtmTokenExpire
);
echo "STT token: " . $token . PHP_EOL;
