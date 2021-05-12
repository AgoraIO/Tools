<?php
include("../src/RtcTokenBuilder2.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$expireTimeInSeconds = 600;

$token = RtcTokenBuilder2::buildTokenWithUid($appId, $appCertificate, $channelName, $uid, RtcTokenBuilder2::ROLE_PUBLISHER, $expireTimeInSeconds);
echo 'Token with int uid: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithAccount($appId, $appCertificate, $channelName, $uidStr, RtcTokenBuilder2::ROLE_PUBLISHER, $expireTimeInSeconds);
echo 'Token with account: ' . $token . PHP_EOL;
?>
