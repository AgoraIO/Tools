<?php
include "../src/DynamicKey5.php";

$appID = '970ca35de60c44645bbae8a215061b33';
$appCertificate = '5cfd2fd1755d40ecb72977518be15d3b';
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$ts = 1446455472;
$randomInt = 58964981;
$uid = 2882341273;
$expiredTs = 1446455471;

echo generateRecordingKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs) . "\n";
echo generateMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs) . "\n";

global $NO_UPLOAD;

echo generateInChannelPermissionKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $NO_UPLOAD) . "\n";

global $AUDIO_VIDEO_UPLOAD;
echo generateInChannelPermissionKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs, $AUDIO_VIDEO_UPLOAD) . "\n";
?>
