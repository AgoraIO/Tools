<?php
include("../src/RtcTokenBuilder2.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$tokenExpirationInSeconds = 3600;
$privilegeExpirationInSeconds = 3600;

$token = RtcTokenBuilder2::buildTokenWithUid($appId, $appCertificate, $channelName, $uid, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with int uid: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccount($appId, $appCertificate, $channelName, $uidStr, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with user account: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUidAndPrivilege($appId, $appCertificate, $channelName, $uid, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with int uid and privilege: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccountAndPrivilege($appId, $appCertificate, $channelName, $uidStr, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with user account and privilege: ' . $token . PHP_EOL;
