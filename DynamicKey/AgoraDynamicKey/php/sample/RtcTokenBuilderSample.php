<?php
include("../src/RtcTokenBuilder.php");

// Need to set environment variable AGORA_APP_ID
$appID = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$role = RtcTokenBuilder::RoleAttendee;
$expireTimeInSeconds = 3600;
$currentTimestamp = (new DateTime("now", new DateTimeZone('UTC')))->getTimestamp();
$privilegeExpiredTs = $currentTimestamp + $expireTimeInSeconds;

$token = RtcTokenBuilder::buildTokenWithUid($appID, $appCertificate, $channelName, $uid, $role, $privilegeExpiredTs);
echo 'Token with int uid: ' . $token . PHP_EOL;

$token = RtcTokenBuilder::buildTokenWithUserAccount($appID, $appCertificate, $channelName, $uidStr, $role, $privilegeExpiredTs);
echo 'Token with user account: ' . $token . PHP_EOL;
