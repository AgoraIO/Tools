<?php
include("../src/RtcTokenBuilder2.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$tokenExpirationInSeconds = 3600;
$privilegeExpirationInSeconds = 3600;
$joinChannelPrivilegeExpireInSeconds = 3600;
$pubAudioPrivilegeExpireInSeconds = 3600;
$pubVideoPrivilegeExpireInSeconds = 3600;
$pubDataStreamPrivilegeExpireInSeconds = 3600;

echo "App Id: " . $appId . PHP_EOL;
echo "App Certificate: " . $appCertificate . PHP_EOL;
if ($appId == "" || $appCertificate == "") {
    echo "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" . PHP_EOL;
    exit;
}

$token = RtcTokenBuilder2::buildTokenWithUid($appId, $appCertificate, $channelName, $uid, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with int uid: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccount($appId, $appCertificate, $channelName, $uidStr, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with user account: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUidAndPrivilege($appId, $appCertificate, $channelName, $uid, $tokenExpirationInSeconds, $joinChannelPrivilegeExpireInSeconds, $pubAudioPrivilegeExpireInSeconds, $pubVideoPrivilegeExpireInSeconds, $pubDataStreamPrivilegeExpireInSeconds);
echo 'Token with int uid and privilege: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccountAndPrivilege($appId, $appCertificate, $channelName, $uidStr, $tokenExpirationInSeconds, $joinChannelPrivilegeExpireInSeconds, $pubAudioPrivilegeExpireInSeconds, $pubVideoPrivilegeExpireInSeconds, $pubDataStreamPrivilegeExpireInSeconds);
echo 'Token with user account and privilege: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithRtm($appId, $appCertificate, $channelName, $uidStr, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with RTM: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithRtm2(
    $appId,
    $appCertificate,
    $channelName,
    $uidStr,
    RtcTokenBuilder2::ROLE_PUBLISHER,
    $tokenExpirationInSeconds,
    $joinChannelPrivilegeExpireInSeconds,
    $pubAudioPrivilegeExpireInSeconds,
    $pubVideoPrivilegeExpireInSeconds,
    $pubDataStreamPrivilegeExpireInSeconds,
    $uidStr,
    $tokenExpirationInSeconds
);
echo 'Token with RTM: ' . $token . PHP_EOL;
