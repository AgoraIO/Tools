<?php
include("../src/ConvoAITokenBuilder.php");

$appId = getenv("AGORA_APP_ID");
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$channelName = "7d72365eb983485397e3e3f9d460bdda";
$rtcAccount = "2882341273";
$rtcRole = RtcTokenBuilder2::ROLE_PUBLISHER;
$rtcTokenExpire = 3600;
$joinChannelPrivilegeExpire = 3600;
$pubAudioPrivilegeExpire = 3600;
$pubVideoPrivilegeExpire = 3600;
$pubDataStreamPrivilegeExpire = 3600;
$rtmUserId = "2882341273";
$rtmTokenExpire = 3600;

echo "App Id: " . $appId . PHP_EOL;
if ($appId == "" || $appCertificate == "") {
    echo "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" . PHP_EOL;
    exit;
}

$token = ConvoAITokenBuilder::buildToken(
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
echo "ConvoAI token: " . $token . PHP_EOL;
