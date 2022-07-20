<?php
include("../src/RtmTokenBuilder2.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$user = "2882341273";
$expireTimeInSeconds = 3600;

$token = RtmTokenBuilder2::buildToken($appId, $appCertificate, $user, $expireTimeInSeconds);
echo 'Rtm Token: ' . $token . PHP_EOL;

?>
