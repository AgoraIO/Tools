<?php
include("../src/EducationTokenBuilder.php");

$appId = "970CA35de60c44645bbae8a215061b33";
$appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
$expire = 600;
$roomUuid = "123";
$userUuid = "2882341273";
$role = 1;

$token = EducationTokenBuilder::buildRoomUserToken($appId, $appCertificate, $roomUuid, $userUuid, $role, $expire);
echo 'Education room user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildUserToken($appId, $appCertificate, $userUuid, $expire);
echo 'Education user token: ' . $token . PHP_EOL;

$token = EducationTokenBuilder::buildAppToken($appId, $appCertificate, $expire);
echo 'Education app token: ' . $token . PHP_EOL;
?>
