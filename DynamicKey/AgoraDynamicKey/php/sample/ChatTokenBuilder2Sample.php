<?php
include("../src/ChatTokenBuilder2.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$user = "2882341273";
$expireTimeInSeconds = 3600;

$token = ChatTokenBuilder2::buildUserToken($appId, $appCertificate, $user, $expireTimeInSeconds);
echo 'Chat user token: ' . $token . PHP_EOL;

$token = ChatTokenBuilder2::buildAppToken($appId, $appCertificate, $expireTimeInSeconds);
echo 'Chat app token: ' . $token . PHP_EOL;
?>
